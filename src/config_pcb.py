# ----------------------------------------------------------------------------
# Pin configuration for PCB.
#
# Author: Bernhard Bablok
# License: GPL3
#
# Website: https://github.com/bablokb/christmas-pyramid
# ----------------------------------------------------------------------------

import board
from uln2003a import GEAR_RATIO_64
from buttons import CB_SLOWER, CB_FASTER, CB_PREV, CB_PAUSE, CB_NEXT

# --- setup   ----------------------------------------------------------------

GEAR_RATIO   = GEAR_RATIO_64
DIRECTION    = -1
RPM          = 6
DEBUG        = False
WAIT4CONSOLE = 5      # in debug-mode, wait x secs for console

WITH_MOTOR    = True
WITH_PLAYER   = True
WITH_LEDS     = True
WITH_BUTTONS  = True
WITH_NEOPIXEL = False

# --- pin definitions   ------------------------------------------------------

# I2C
PIN_SCL = board.IO13
PIN_SDA = board.IO14

# DFPlayer
PINS_UART = [board.IO11, board.IO12]  # TX, RX
VOLUME    = 95

# SD-card (SPI, unused for DFPlayer)
PINS_SD = [
  board.IO10,  # MISO
  board.IO6,   # MOSI
  board.IO8,   # CLK
  board.IO4,   # CS
]

# motor GPIOs
PINS_MOTOR = [board.IO39,board.IO37,board.IO35,board.IO33]

# LED GPIOs
PINS_LED = [board.IO18,board.IO17,board.IO16]
DUTY_LED = [0.5,0.5,0.5]

# NEO PINs (unused)
PINS_NEO = (None,0)
DUTY_NEO = 0.1

# I2S (unused for DFPlayer)
PIN_MUTE   = board.IO38
PINS_I2S   = [board.IO11,board.IO12,board.IO9,PIN_MUTE] # BLCK, WSEL, DATA

# Buttons (audio next/volup and prev/voldown are handled directly by DFPlayer)
PINS_BUTTON = [
  board.IO7,    # slower
  board.IO5,    # faster
  board.IO3,    # pause
]
PINS_CB = [CB_SLOWER, CB_FASTER, CB_PAUSE]
