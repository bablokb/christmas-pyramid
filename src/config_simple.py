# ----------------------------------------------------------------------------
# Pin configuration for simple build with Waveshare RP2040-Zero.
#
# Author: Bernhard Bablok
# License: GPL3
#
# Website: https://github.com/bablokb/christmas-pyramid
# ----------------------------------------------------------------------------

import board
from uln2003a import GEAR_RATIO_16

# --- setup   ----------------------------------------------------------------

GEAR_RATIO   = GEAR_RATIO_16
DIRECTION    = -1
RPM          = 7
DEBUG        = False
WAIT4CONSOLE = 5      # in debug-mode, wait x secs for console

WITH_MOTOR    = True
WITH_PLAYER   = True
WITH_LEDS     = False
WITH_BUTTONS  = False
WITH_NEOPIXEL = True

# --- pin definitions   ------------------------------------------------------

# DFPlayer
PINS_UART = [board.GP12, board.GP13]  # TX, RX
VOLUME    = 85

# SD-card (SPI, unused for DFPlayer)
PINS_SD = [
]

# motor GPIOs
PINS_MOTOR = [board.GP5,board.GP6,board.GP7,board.GP8]

# LED GPIOs (unused)
PINS_LED = []
DUTY_LED = [0.5,0.5,0.5]

# NEO PINs
PINS_NEO = (board.GP11,16)
DUTY_NEO = 0.1

# Buttons (unused)
PINS_BUTTON = [
]
PINS_CB = []
