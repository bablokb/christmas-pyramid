# ----------------------------------------------------------------------------
# Main program.
#
# Author: Bernhard Bablok
# License: GPL3
#
# Website: https://github.com/bablokb/christmas-pyramid
# ----------------------------------------------------------------------------

import supervisor
import time
import board
import asyncio
import atexit

from motor import Motor
from player import Player
from leds import Leds
from buttons import Buttons

# --- configuration   --------------------------------------------------------

#from config_breadboard import PIN_*
import config_pcb as config

# --- exit-processing   ------------------------------------------------------

def at_exit(stop_event):
  """ exit processing """
  if config.DEBUG:
    print("stopping tasks")
  stop_event.set()

# --- main task   ------------------------------------------------------------

async def main():
  """ main co-routine """
  stop_event = asyncio.Event()
  atexit.register(at_exit,stop_event)

  # individual controller objects
  motor = Motor(config.PINS_MOTOR,
                config.GEAR_RATIO,
                config.DIRECTION,
                config.RPM,
                config.DEBUG)
  player = Player(config.PINS_I2S, config.PINS_SD, config.DEBUG)
  buttons = Buttons(config.PINS_BUTTON, motor, player, config.DEBUG)
  leds = Leds(config.PINS_LED, config.DUTY_LED, config.DEBUG)

  # start controller tasks and wait for end
  if config.DEBUG:
    print("starting controller tasks")
  await asyncio.gather(buttons.run(0,stop_event),
                       motor.run(0,stop_event),
                       player.run(0.2,stop_event),
                       leds.run(0.5,stop_event)
                       )

# --- main program   ---------------------------------------------------------

if config.DEBUG:
  start = time.monotonic()
  while (not supervisor.runtime.serial_connected and
         time.monotonic() < start + config.WAIT4CONSOLE):
    time.sleep(1)

asyncio.run(main())
if config.DEBUG:
  print("done running main")
