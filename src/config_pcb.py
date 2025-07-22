# ----------------------------------------------------------------------------
# Pin configuration for PCB.
#
# Author: Bernhard Bablok
# License: GPL3
#
# Website: https://github.com/bablokb/circuitpython-uln2003a
#
# ----------------------------------------------------------------------------

import board
from uln2003a import GEAR_RATIO_16

# --- setup   ----------------------------------------------------------------

GEAR_RATIO   = GEAR_RATIO_16
DIRECTION    = 1
RPM          = 6
DEBUG        = True
WAIT4CONSOLE = 5      # in debug-mode, wait x secs for console

# --- pin definitions   ------------------------------------------------------

# I2C
PIN_SCL = board.IO13
PIN_SDA = board.IO14

# SD-card (SPI)
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

# I2S
PIN_MUTE   = board.IO38
PINS_I2S   = [board.IO11,board.IO12,board.IO9,PIN_MUTE] # BLCK, WSEL, DATA

# Buttons
PINS_BUTTON = [
  board.IO1,    # slower
  board.IO2,    # faster
  board.IO3,    # prev
  board.IO5,    # pause
  board.IO7,    # next
]
