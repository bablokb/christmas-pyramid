# ----------------------------------------------------------------------------
# Class Player controls the DFPlayer.
#
# Needs the library http://github.com/bablokb/circuitpython-dfplayer
#
# Author: Bernhard Bablok
# License: GPL3
#
# Website: https://github.com/bablokb/christmas-pyramid
# ----------------------------------------------------------------------------

import asyncio
import busio
from DFPlayer import DFPlayer

from base import Base

class Player(Base):
  """ Audio-Controller """

  # --- constructor   --------------------------------------------------------

  def __init__(self, pins_uart, volume, debug=False):
    """ constructor """

    super().__init__(debug)
    self._uart = busio.UART(*pins_uart, baudrate=9600)
    self._dfplayer = DFPlayer(self._uart,volume=volume)
    self._playing = False
    self._muted = False
    self._volume = volume
    self._msg(f"volume is {self._dfplayer.get_volume()}")

  # --- music task   -----------------------------------------------------------

  async def run(self, delay, stop_event):
    """ create music task """

    self._msg("start playing music")
    await asyncio.sleep(delay)
    self._playing = True
    self._dfplayer.random()
    self._msg("player: waiting for stop")
    await stop_event.wait()
    self._msg("stop playing music")
    self.stop()

  # --- stop   ---------------------------------------------------------------

  def stop(self):
    """ explicitly stop player """
    self._dfplayer.stop()
    self._uart.deinit()

  # --- pause audio   --------------------------------------------------------

  def pause(self):
    """ toggle pause of audio """
    if self._playing:
      self._msg("pause: on")
      self._dfplayer.pause()
    else:
      self._msg("pause: off")
      self._dfplayer.play()

  # --- mute   ---------------------------------------------------------------

  def mute(self):
    """ toggle mute (unused) """
    if self._muted:
      self._dfplayer.set_volume(self._volume)
    else:
      self._volume = self._dfplayer.get_volume()
      self._dfplayer.set_volume(0)
    self._msg(f"mute: {'off' if self._volume else 'on'}")
