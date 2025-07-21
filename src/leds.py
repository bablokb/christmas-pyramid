# ----------------------------------------------------------------------------
# Class Leds controls the LED peripherals.
#
# Author: Bernhard Bablok
# License: GPL3
#
# Website: https://github.com/bablokb/christmas-pyramid
# ----------------------------------------------------------------------------

import asyncio
from jled import JLed
from base import Base

class Leds(Base):
  """ LED-Controller """

  # --- constructor   --------------------------------------------------------

  def __init__(self, pins_led, duty_led, debug=False):
    """ constructor """

    super().__init__(debug)
    self._leds = [None]*3

    # base-level lighting
    hal2 = JLed._DEFAULT_PWM_HAL(pin=pins_led[2],duty_scale=duty_led[2])
    self._leds[2] = JLed(hal=hal2).on()
    #self._leds[2] = JLed(hal=hal2).breathe(1000).delay_after(500).forever()
    #self._leds[2] = JLed(hal=hal2).candle(
    #  speed=5, jitter=100, period=0xFFFF)

  # --- LED task   -----------------------------------------------------------

  async def run(self, delay, stop_event):
    """ create LED task """

    self._msg("start LED animation")
    await asyncio.sleep(delay)
    while True:
      for led in self._leds:
        if led:
          led.update()
      await asyncio.sleep(0.1)
      if stop_event.is_set():
        return
