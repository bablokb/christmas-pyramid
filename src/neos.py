# ----------------------------------------------------------------------------
# Class Neos controls a neopixel-strand.
#
# Author: Bernhard Bablok
# License: GPL3
#
# Website: https://github.com/bablokb/christmas-pyramid
# ----------------------------------------------------------------------------

import asyncio
import neopixel

#from adafruit_led_animation.animation.sparkle import Sparkle
from adafruit_led_animation.animation.sparklepulse import SparklePulse
from adafruit_led_animation.color import BLUE as NEO_COLOR

from base import Base

class Neos(Base):
  """ Simple Neopixel-Controller """

  # --- constructor   --------------------------------------------------------

  def __init__(self, pins_neo, duty_neo, debug=False):
    """ constructor """

    super().__init__(debug)

    pixel_pin, pixel_count = pins_neo
    self._pixels = neopixel.NeoPixel(pixel_pin,
                               pixel_count,
                               brightness=duty_neo,
                               auto_write=False)

    #self._anim = Sparkle(self._pixels, speed=1, color=NEO_COLOR,
    #                     num_sparkles=int(pixel_count/4))
    self._anim = SparklePulse(self._pixels,
                              speed=0.2, period=5, color=NEO_COLOR)

  # --- NEO task   -----------------------------------------------------------

  async def run(self, delay, stop_event):
    """ create NEO task """

    self._msg("start NEO animation")
    await asyncio.sleep(delay)
    while True:
      self._anim.animate()
      await asyncio.sleep(0.2)
      if stop_event.is_set():
        self.clear()
        return

  # --- clear neopixels   ------------------------------------------------------

  def clear(self):
    """ force clear neopixels """
    self._pixels.fill(0)
    self._pixels.show()
