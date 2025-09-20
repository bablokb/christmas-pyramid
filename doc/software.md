The Software
============

The software is implemented in CircuitPython, but porting it to other
languages (especially MicroPython) should be straight forward.

The provided source-code is agnostic about the microprocessor that is
used. Since CircuitPython supports many different processors, you are
free to pick what you want (as long as you have enough IO-pins).

Read the section about configuration below to adapt the software to your
specific setup.


Installation
------------

Just copy everything below `src/` to your device. Note that `src/lib`
contains a number of precompiled libraries (adafruit_ticks and
asyncio). These are CircuitPython version 9 libraries (also compatible
with version 10). You might want to update these libraries if you have
problems.


Configuration
-------------

Use `src/config_pcb.py` or `src/config_breadboard.py` as a template
for your own configuration and change the import in `src/main.py`
accordingly.


Implementation Notes
--------------------

The hardware components (Motor, LEDs, music and buttons) are wrapped
by simple classes and controlled by asynchronous tasks. The main
program does not do much more than instantiating a task for every
hardware component and then starting all of them in parallel.

    motor = Motor(config.PINS_MOTOR,
                  config.GEAR_RATIO,
                  config.DIRECTION,
                  config.RPM,
                  config.DEBUG)
    player = Player(config.PINS_UART, config.VOLUME, config.DEBUG)
    buttons = Buttons(config.PINS_BUTTON, config.PINS_CB,
                      motor, player, config.DEBUG)
    leds = Leds(config.PINS_LED, config.DUTY_LED, config.DEBUG)

    stop_event = asyncio.Event()
    atexit.register(at_exit,stop_event,player)

    # start controller tasks and wait for end
    await asyncio.gather(buttons.run(0,stop_event),
                         motor.run(0,stop_event),
                         player.run(0.2,stop_event),
                         leds.run(0.5,stop_event)
                         )

As you can see, there is a stop-event that is triggered during
exit-processing in case of any exception (like a
keyboard-interrupt). This s useful for software development, sind in a
productive environment, stopping is done simply by pulling the power-plug.

The tasks themselves are also simple. The motor task for example just
starts the motor and then waits for the stop-event:

    async def run(self, delay, stop_event):
      """ create motor task """

      await asyncio.sleep(delay)
      self._motor = uln2003a.Uln2003aFullStep(*self._pins,
                                              self._gear_ratio,
                                              debug=self._debug)
      asyncio.create_task(self._motor.rotate(self._direction,self._rpm))
      await stop_event.wait()
      self._motor.stop()
      self._motor.deinit()

The button class uses the `keypad`-module from core CircuitPython
to catch and process any buttons that are pressed. The other wrapper
classes provide callbacks that are directly executed from the button-task.

The lighting uses a slightly modified version of the LED-animation
library from <https://github.com/jandelgado/jled-circuitpython>.

The libraries for the DFPlayer and the motor are from myself, see
<https://github.com/bablokb/circuitpyton-dfplayer> and
<https://github.com/bablokb/circuitpyton-uln2003a>.


Porting
-------

For MicroPython, porting should be simple. The DFPlayer library of
this project is a port of a MicroPython library. For the uln2003a you
will also find existing MicroPython libs, but AFAIK these do not support
async operations. A suitable LED-animation library should also be
available.

For C (Arduino) the situation should be similar. The original source
code of DFRobot for the DFPlayer was written for Arduino (but there
are others as well). The LED-animation library used in this project is
also available in a C version. And support for the uln2003 is also
available.


Further Reading
---------------

Head on to [3D-Printing](./printing.md) to read about the how the
pyramid is printed and assembled.
