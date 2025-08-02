# ----------------------------------------------------------------------------
# Class Motor links to the motor-driver and keeps state.
#
# Author: Bernhard Bablok
# License: GPL3
#
# Website: https://github.com/bablokb/christmas-pyramid
# ----------------------------------------------------------------------------

import asyncio
import uln2003a

from base import Base

class Motor(Base):
  """ Controller of motor-driver """

  # --- constructor   --------------------------------------------------------

  def __init__(self, pins,
               gear_ratio=uln2003a.GEAR_RATIO_16,
               direction=1,
               rpm=0,
               debug=False):
    """ constructor """

    super().__init__(debug)
    self._pins = pins
    self._gear_ratio = gear_ratio
    self._direction = direction
    self._rpm = rpm
    self._motor = None
    self.running = False

  # --- motor task   ---------------------------------------------------------

  async def run(self, delay, stop_event):
    """ create motor task """

    await asyncio.sleep(delay)
    self._motor = uln2003a.Uln2003aFullStep(*self._pins,
                                            self._gear_ratio,
                                            debug=self._debug)
    self._msg("starting rotation")
    asyncio.create_task(self._motor.rotate(self._direction,self._rpm))
    self._msg("waiting for stop")
    await stop_event.wait()
    self._msg("stopping rotation")
    self._motor.stop()
    self._motor.deinit()

  # --- change RPM   ---------------------------------------------------------

  def inc_rpm(self,delta):
    """ change RPM value """

    self._msg(f"inc_rpm({delta})")
    if self._motor:
      self._motor.inc_rpm(delta)
