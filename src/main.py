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

from motor import Motor
from player import Player
from leds import Leds
from neos import Neos
from buttons import Buttons

# --- configuration   --------------------------------------------------------

#import config_breadboard as config
#import config_simple as config
import config_pcb as config

# --- main task   ------------------------------------------------------------

_stop_event = asyncio.Event()
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

  # start configured controller tasks and wait for end
  if config.DEBUG:
    print("starting controller tasks")
  coprocs = [t[0].run(t[1],_stop_event) for t in tasks]

  await asyncio.gather(*coprocs)

# --- cleanup task   ---------------------------------------------------------

async def terminate():
  """ wait for task termination """
  if config.DEBUG:
    print("running terminate()...")
  _stop_event.set()
  await asyncio.sleep(3)
  if config.DEBUG:
    print("finished terminate()")

# --- main program   ---------------------------------------------------------

if config.DEBUG:
  start = time.monotonic()
  while (not supervisor.runtime.serial_connected and
         time.monotonic() < start + config.WAIT4CONSOLE):
    time.sleep(1)

try:
  asyncio.run(main())
except KeyboardInterrupt:
  if config.DEBUG:
    print(f"interrupted!")
except Exception as ex:
  if config.DEBUG:
    print(f"exception: {ex}")
finally:
  asyncio.run(terminate())

if config.DEBUG:
  print("done running main")
