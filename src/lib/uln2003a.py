# -------------------------------------------------------------------------
# uln2003a.py: Driver for ULN2003A.
#
# This code is a heavily modified version of:
#
# Rui Santos & Sara Santos - Random Nerd Tutorials
# Complete project details at
# https://RandomNerdTutorials.com/raspberry-pi-pico-stepper-motor-micropython/
# Forked from:
# https://github.com/larsks/micropython-stepper-motor/blob/master/motor.py
#
# Note that none of these versions have an explicit copyright statement or
# license.
#
# Author: Bernhard Bablok
# License: GPL3
#
# Website: https://github.com/bablokb/circuitpython-uln2003a
#
# -------------------------------------------------------------------------

import time
import digitalio
import asyncio

GEAR_RATIO_16 = int(32*16.128)
GEAR_RATIO_64 = 4*GEAR_RATIO_16
MAX_RPM = 10

class Uln2003a:
  """ base class """

  # --- constructor   --------------------------------------------------------

  def __init__(self, p1, p2, p3, p4,
               states=None, steps360=0, rpm=1, debug=False):
    """ constructor """
    if not debug:
      self._debug = lambda x: None

    self._pins     = self._get_dios([p1, p2, p3, p4])
    self._states   = states
    self._steps360 = steps360
    self.rpm = rpm

    self._state = 0
    self._pos = 0
    self._stop = False

  # --- print debug-message   ------------------------------------------------

  def _debug(self,msg):
    """ print debug message """
    print(msg)

  # --- create digital IOs   -------------------------------------------------

  def _get_dios(self, pins):
    """ create digital IO pins """
    dios = []
    for pin in pins:
      dio = digitalio.DigitalInOut(pin)
      dio.direction = digitalio.Direction.OUTPUT
      dios.append(dio)
    return dios

  # --- low level implementation of stepping   -------------------------------

  def _step(self, dir):
    """ single step in the given direction """
    state = self._states[self._state]
    #self._debug(f"_step: {dir=},{self._state=},{state=}")
    for i, val in enumerate(state):
      self._pins[i].value = val
    self._state = (self._state + dir) % len(self._states)
    self._pos = (self._pos + dir) % self._steps360

  # --- calculate tpstep for given RPM   -------------------------------------

  def _get_tpstep(self,rpm):
    """ query time per step for given rpm """
    if rpm is None:
      return self._tpstep
    else:
      return 60/(rpm*self._steps360)

  # --- set rpm and calculate timings   --------------------------------------

  @property
  def rpm(self):
    """ default RPM """
    return self._rpm

  @rpm.setter
  def rpm(self,value):
    """ set default RPM and calculate timings """
    self._debug(f"setting rpm: {value}")
    self._rpm      = value
    self._spm      = value*self._steps360    # steps per minute for given rpm
    if self._spm:
      self._tpstep = 60/self._spm            # time per step in seconds
    else:
      self._tpstep = None
    self._debug(f"tps: {self._tpstep}")

  def inc_rpm(self,delta):
    """ change RPM by delta """
    self.rpm = min(MAX_RPM,max(0,self._rpm+delta))

  # --- free ressources   ----------------------------------------------------

  def deinit(self):
    """ free ressources """
    for pin in self._pins:
      pin.deinit()

  @property
  def pos(self):
    return self._pos

  @pos.setter
  def pos(self,value):
    self._pos = value

  def stop(self):
    self._stop = True

  def reset(self):
    """ reset state """
    self._pos = 0
    self._state = 0

  @property
  def steps360(self):
    return self._steps360

  # --- turn the number of steps   -------------------------------------------

  def step(self, steps,rpm=None):
    """ turn the number of steps
    This does not allow change of RPM on the fly
    """

    dir = 1 if steps >= 0 else -1
    steps = abs(steps)
    tpstep = self._get_tpstep(rpm)
    self._debug(f"step: {self.pos=}, {steps=}, {tpstep=}")
    for _ in range(0,steps):
      t_start = time.monotonic()
      self._step(dir)
      time.sleep(tpstep - (time.monotonic()-t_start))

  # --- rotate indefinitely   ------------------------------------------------

  async def rotate(self, dir, rpm=None):
    """ rotate. This allows changing RPM on the fly """
    self._stop = False
    if not rpm is None:
      self.rpm = rpm
    self._debug(f"rotate: {self.pos=}, {self._tpstep=}")
    while not self._stop:
      if not self._tpstep:
        await asyncio.sleep(0.1)
        continue
      t_start = time.monotonic()
      self._step(dir)
      await asyncio.sleep(self._tpstep - (time.monotonic()-t_start))

  # --- step to the given target (measured in steps)   -----------------------

  def step_to_target(self, target, dir=None, rpm=None):
    """ step to target position. Use shortest path unless dir is given. """
    target = int(target%self._steps360)
    if dir is None:
      dir = 1 if target > self._pos else -1
      if abs(target - self._pos) > self._steps360/2:
        dir = -dir
    # calculate necessary steps
    steps = target - self._pos
    if dir == 1:
      if steps < 0:
        steps += self._steps360
    else:
      if steps > 0:
        steps = -steps
    # step to target
    self._debug(f"step_to_target: {self.pos=}, {steps=}")
    self.step(steps,rpm)

  # --- step to the given target-angle   -------------------------------------

  def step_to_angle(self, angle, dir=None, rpm=None):
    """ step to target angle. Use shortest path unless dir is given. """
    target = int((angle%360)/360*self._steps360)
    self._debug(f"step_to_angle: {self.pos=}, {target=}")
    self.step_to_target(target, dir=dir, rpm=rpm)
    self._debug(f"step_to_angle: {self.pos=}")

  # --- step the number of degrees   -----------------------------------------

  def step_degrees(self, degrees, rpm=None):
    """ step the number of degrees """
    steps = int(degrees / 360 * self._steps360)
    self._debug(f"step_degrees: {self.pos=}, {steps=}")
    self.step(steps, rpm=rpm)
    self._debug(f"step_degrees: {self.pos=}")

class Uln2003aFullStep(Uln2003a):
  def __init__(self, p1, p2, p3, p4,ratio,rpm=1,debug=False):
    states = [
      [1, 1, 0, 0],
      [0, 1, 1, 0],
      [0, 0, 1, 1],
      [1, 0, 0, 1]
    ]
    super().__init__(p1,p2,p3,p4,states,ratio,rpm,debug)

class Uln2003aHalfStep(Uln2003a):
  def __init__(self, p1, p2, p3, p4,ratio,rpm=1,debug=False):
    states = [
      [1, 0, 0, 0],
      [1, 1, 0, 0],
      [0, 1, 0, 0],
      [0, 1, 1, 0],
      [0, 0, 1, 0],
      [0, 0, 1, 1],
      [0, 0, 0, 1],
      [1, 0, 0, 1],
    ]
    super().__init__(p1,p2,p3,p4,states,ratio,rpm,debug)
