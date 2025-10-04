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

    # top-level lighting
    hal0 = JLed._DEFAULT_PWM_HAL(pin=pins_led[0],duty_scale=duty_led[0])
    self._leds[0] = JLed(hal=hal0).on()

    # level1 lighting
    hal1 = JLed._DEFAULT_PWM_HAL(pin=pins_led[1],duty_scale=duty_led[1])
    self._leds[1] = JLed(hal=hal1).candle(speed=5, jitter=100,
                                          period=0xFFFF).forever()

    # base-level lighting
    hal2 = JLed._DEFAULT_PWM_HAL(pin=pins_led[2],duty_scale=duty_led[2])
    self._leds[2] = JLed(hal=hal2).breathe(20000).delay_after(0).forever()



  # --- LED task   -----------------------------------------------------------

  async def run(self, delay, stop_event):
    """ create LED task """

    self._msg("start LED animation")
    await asyncio.sleep(delay)
    while True:
      for led in self._leds:
        if led:
          led.update()
      await asyncio.sleep(0.05)
      if stop_event.is_set():
        return
