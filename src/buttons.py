# ----------------------------------------------------------------------------
# Class Buttons creates a keypad and processes key-events.
#
# Author: Bernhard Bablok
# License: GPL3
#
# Website: https://github.com/bablokb/christmas-pyramid
# ----------------------------------------------------------------------------

import keypad
import asyncio
from base import Base

class Buttons(Base):
  """ Button-Controller """

  # --- constructor   --------------------------------------------------------

  def __init__(self, pins_buttons, motor, player, debug=False):
    """ constructor """

    super().__init__(debug)
    self._motor = motor
    self._player = player
    self._keys = keypad.Keys(pins_buttons,
                             value_when_pressed=False,pull=True,
                             interval=0.1,max_events=4)
    self._key_events = self._keys.events
    self._key_callbacks = [
      self._on_slower,
      self._on_faster,
      self._on_prev,
      self._on_pause,
      self._on_next]

  # --- callbacks   ----------------------------------------------------------

  def _on_slower(self):
    """ decrease RPM of the motor """
    self._msg("on_slower")
    self._motor.inc_rpm(-1)

  def _on_faster(self):
    """ increase RPM of the motor """
    self._msg("on_faster")
    self._motor.inc_rpm(+1)

  def _on_prev(self):
    """ switch to previous song """
    self._msg("on_prev")
    self._player.prev()

  def _on_next(self):
    """ switch to next song """
    self._msg("on_next")
    self._player.next()

  def _on_pause(self):
    """ toggle pause """
    self._msg("on_pause")
    self._player.pause()

  # --- button task   --------------------------------------------------------

  async def run(self, delay, stop_event):
    """ create Button task """

    self._msg("start button processing")
    await asyncio.sleep(delay)
    while True:
      await asyncio.sleep(0.5)
      if stop_event.is_set():
        self._keys.deinit()
        return
      event = self._key_events.get()
      if event and event.pressed:
        self._key_callbacks[event.key_number]()
