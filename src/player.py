# ----------------------------------------------------------------------------
# Class Player controls the I2S peripheral.
#
# Author: Bernhard Bablok
# License: GPL3
#
# Website: https://github.com/bablokb/christmas-pyramid
# ----------------------------------------------------------------------------

import asyncio
import audiobusio
import audiomp3
import busio
import digitalio
import os
import sdcardio
import storage

from base import Base

class Player(Base):
  """ Audio-Controller """

  # --- constructor   --------------------------------------------------------

  def __init__(self, pins_i2s, pins_sd, debug=False):
    """ constructor """

    super().__init__(debug)
    self._files = []
    self._current = 0
    self._audio = audiobusio.I2SOut(*pins_i2s[:3])

    if len(pins_i2s) == 4 and pins_i2s[3]:
      # create mute-pin and start unmuted
      self._mute = digitalio.DigitalInOut(pins_i2s[3])
      self._mute.switch_to_output(value=True)
    else:
      self._mute = None

    self._mount_sd(*pins_sd)
    self._file_list()

  # --- mount SD-card   --------------------------------------------------------

  def _mount_sd(self, pin_rx, pin_tx, pin_clk, pin_cs):
    """ mount SD-card """

    spi = None
    try:
      spi    = busio.SPI(pin_clk,pin_tx,pin_rx)
      sdcard = sdcardio.SDCard(spi,pin_cs,1_000_000)
      vfs    = storage.VfsFat(sdcard)
      storage.mount(vfs, "/sd")
    except Exception as ex:
      if spi:
        spi.deinit()
      raise

  # --- read list of music-files   ---------------------------------------------

  def _file_list(self):
    """ read list of mp3-files """

    try:
      files = os.listdir("/sd")
      self._files = ["/sd/"+f for f in files if f[-3:] == "mp3"]
      self._files.sort()
      self._msg(f"{self._files=}")
    except Exception as ex:
      self._msg(f"failed reading SD-card: {ex}")
      self._files = []

  # --- music task   -----------------------------------------------------------

  async def run(self, delay, stop_event):
    """ create music task """

    self._msg("start playing music")
    await asyncio.sleep(delay)
    while True:
      try:
        current = self._current
        f = self._files[self._current]
        fstream = open(f,"rb")
        mp3 = audiomp3.MP3Decoder(fstream)
        self._msg(f"starting {f}")
        self._audio.play(mp3)
        while self._audio.playing or self._audio.paused:
          await asyncio.sleep(0.5)
          if stop_event.is_set():
            self._audio.stop()
            fstream.close()
            mp3.deinit()
            return
          elif current != self._current:
            break
        if self._audio.playing or self._audio.paused:
          self._msg(f"interrupted {f}")
        else:
          self._msg(f"finished {f}")
          self.next()
      except Exception as ex:
        print(f"could not play {f}: {ex}")
      fstream.close()
      mp3.deinit()
      await asyncio.sleep(0.5)

  # --- pause audio   --------------------------------------------------------

  def pause(self):
    """ toggle pause of audio """
    if self._audio.paused:
      self._msg("pause: off")
      self._audio.resume()
    else:
      self._msg("pause: on")
      self._audio.pause()

  # --- next song   ----------------------------------------------------------

  def next(self):
    """ switch to next song """
    self._current = (self._current + 1) % len(self._files)
    self._msg(f"switching to next song ({self._files[self._current]})")

  # --- previous song   ------------------------------------------------------

  def prev(self):
    """ switch to prev song """
    if self._current == 0:
      self._current = len(self._files) - 1
    else:
      self._current = (self._current - 1)
    self._msg(f"switching to previous song ({self._files[self._current]})")

  # --- mute   ---------------------------------------------------------------

  def mute(self,value):
    """ drive mute-pin """
    if self._mute:
      self._mute.value = not value # active low, so change
      self._msg(f"mute: {'off' if value else 'on'}")
