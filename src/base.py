# ----------------------------------------------------------------------------
# Base class for all peripherals
#
# Author: Bernhard Bablok
# License: GPL3
#
# Website: https://github.com/bablokb/christmas-pyramid
# ----------------------------------------------------------------------------

class Base:
  """ Base class for controller """

  # --- constructor   --------------------------------------------------------

  def __init__(self, debug=False):
    """ constructor """

    self._debug = debug

  # --- print debug message   ------------------------------------------------

  def _msg(self,txt):
    """ print debug message """

    if self._debug:
      print(txt)
