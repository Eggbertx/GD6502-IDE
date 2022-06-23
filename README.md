# GD6502
A (currently) bare-bones, stripped down 6502 emulator and assembler. Currently, I'm using the 6502asm.com and the [Easy 6502](https://skilldrick.github.io/easy6502/) emulators as goal posts to test GD6502's usefulness. After it's fully compatible with those two emulators, I'll start working on making it compatible with more complex 6502-based systems like the Atari 2600, NES, and others. At that point, I'll start turning it from a standalone project into a library to be integrated into other projects.


## Examples
- The examples in [./examples/6502asm/](./examples/6502asm/) come from http://6502asm.com/ and credit goes to their original authors.
- The examples in [./examples/otherasm/](./examples/otherasm/) are for general assembler testing and may or may not be moved to the unit testing directory.


## Tests
There are unit tests in `./tests/` that can be executed using [Gut](https://github.com/bitwes/Gut). To use it, run `godot --debug-collisions -gexit --path $PWD -d -s addons/gut/gut_cmdln.gd`

`-gexit` is optional here, and will cause GUT to exit after all the tests are complete. As an alternative, you can use `-gexit_on_success` which will cause it to only exit if all of the unit tests succeed.

See https://github.com/bitwes/Gut/wiki/Command-Line for more info on Gut unit tests from the command line.


## Used assets
* The Godot logo in GD6502's icon is owned by the developers of the [Godot game engine](https://godotengine.org/) and licensed under the [Creative Commons Attribution 3.0 Unported](https://github.com/godotengine/godot/blob/master/LOGO_LICENSE.md) license.
* The Noto Sans Monospace font (used for the assembly editor and status log) is developed by the Noto Fonts Project, and is licensed under the [SIL Open Fonts License](https://github.com/notofonts/noto-fonts/blob/main/LICENSE).
