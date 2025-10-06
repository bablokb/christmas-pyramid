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
from neos import Neos
from buttons import Buttons

# --- configuration   --------------------------------------------------------

#import config_breadboard as config
import config_simple as config
#import config_pcb as config

# --- exit-processing   ------------------------------------------------------

def at_exit(stop_event,player,neos):
  """ exit processing """
  if config.DEBUG:
    print("stopping tasks")
  stop_event.set()
  if player:
    player.stop()
  if neos:
    neos.clear()

# --- main task   ------------------------------------------------------------

async def main():
  """ main co-routine """

  # individual controller objects and tasks
  # tasks is a list of (obj,initial-delay)-pairs
  tasks = []
  if config.WITH_MOTOR:
    motor = Motor(config.PINS_MOTOR,
                  config.GEAR_RATIO,
                  config.DIRECTION,
                  config.RPM,
                  config.DEBUG)
    tasks.append((motor,0))
  else:
    motor = None

  if config.WITH_PLAYER:
    player = Player(config.PINS_UART, config.VOLUME, config.DEBUG)
    tasks.append((player,0.2))
  else:
    player = None

  if config.WITH_BUTTONS:
    buttons = Buttons(config.PINS_BUTTON, config.PINS_CB,
                      motor, player, config.DEBUG)
    tasks.append((buttons,0))

  if config.WITH_LEDS:
    leds = Leds(config.PINS_LED, config.DUTY_LED, config.DEBUG)
    tasks.append((leds,0.5))

  if config.WITH_NEOPIXEL:
    neos = Neos(config.PINS_NEO, config.DUTY_NEO, config.DEBUG)
    tasks.append((neos,0.5))
  else:
    neos = None

  # register atexit-processing (for development)
  stop_event = asyncio.Event()
  atexit.register(at_exit,stop_event,player,neos)

  # start configured controller tasks and wait for end
  if config.DEBUG:
    print("starting controller tasks")
  coprocs = [t[0].run(t[1],stop_event) for t in tasks]
  await asyncio.gather(*coprocs)

# --- main program   ---------------------------------------------------------

if config.DEBUG:
  start = time.monotonic()
  while (not supervisor.runtime.serial_connected and
         time.monotonic() < start + config.WAIT4CONSOLE):
    time.sleep(1)

asyncio.run(main())
if config.DEBUG:
  print("done running main")
