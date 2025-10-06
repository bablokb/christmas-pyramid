# ----------------------------------------------------------------------------
# Class Neos controls a neopixel-strand.
#
# The animation will twinkle random pixels while the color slowly moves
# through the color-wheel.
#
# Author: Bernhard Bablok
# License: GPL3
#
# Website: https://github.com/bablokb/christmas-pyramid
# ----------------------------------------------------------------------------

import asyncio
import neopixel
import random
import time

from base import Base

ANIM_INTERVAL  = 0.2   # change pixel-animation
COLOR_CHANGE   = 5     # color change interval
PIXEL_ON       = 1.0   # on-duration for every pixel
PIXEL_SUBSET   = 0.25  # fraction of pixels to turn on every interval

class Neos(Base):
  """ Simple Neopixel-Animation """

  # --- constructor   --------------------------------------------------------

  def __init__(self, pins_neo, duty_neo, debug=False):
    """ constructor """

    super().__init__(debug)

    pixel_pin, pixel_count = pins_neo
    self._pixels = neopixel.NeoPixel(pixel_pin,
                               pixel_count,
                               brightness=duty_neo,
                               auto_write=False)
    random.seed(time.monotonic_ns() % 256)
    self._color = random.randint(0,255)
    self._color_update = 0
    self._pixel_state = [0]*pixel_count

  # --- colorwheel   ---------------------------------------------------------

  def wheel(self, pos):
    # Input a value 0 to 255 to get a color value.
    # The colours are a transition r - g - b - back to r.
    if pos < 0 or pos > 255:
      r = g = b = 0
    elif pos < 85:
      r = int(pos * 3)
      g = int(255 - pos * 3)
      b = 0
    elif pos < 170:
      pos -= 85
      r = int(255 - pos * 3)
      g = 0
      b = int(pos * 3)
    else:
      pos -= 170
      r = 0
      g = int(pos * 3)
      b = int(255 - pos * 3)
    return (r, g, b)


  # --- NEO task   -----------------------------------------------------------

  async def run(self, delay, stop_event):
    """ create NEO task """

    self._msg("start NEO animation")
    await asyncio.sleep(delay)

    while True:
      # clear pixels with elapsed on-time
      for i in range(self._pixels.n):
        if time.monotonic() > self._pixel_state[i] + PIXEL_ON:
          self._pixels[i] = 0

      # update the color
      if time.monotonic() > self._color_update + COLOR_CHANGE:
        self._color = (self._color+1)%256
        self._msg(f"changing color to {self._color}")
        self._color_update = time.monotonic()

      # pick some random pixels and turn them on
      for _ in range(int(PIXEL_SUBSET*self._pixels.n)):
        i = random.randint(0,self._pixels.n-1)
        self._pixels[i] = self.wheel(self._color)
        self._pixel_state[i] = time.monotonic()

      # update pixels and sleep the given interval
      self._pixels.show()
      await asyncio.sleep(ANIM_INTERVAL)
      if stop_event.is_set():
        self.clear()
        return

  # --- clear neopixels   ------------------------------------------------------

  def clear(self):
    """ force clear neopixels """
    self._pixels.fill(0)
    self._pixels.show()
