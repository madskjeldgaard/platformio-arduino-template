[![PlatformIO CI](https://github.com/madskjeldgaard/platformio-arduino-template/actions/workflows/build.yml/badge.svg)](https://github.com/madskjeldgaard/platformio-arduino-template/actions/workflows/build.yml)

# The ⚡ULTIMATE⚡ Arduino starter template for Platformio 🐩

This template sets up a nice skeleton to create a project for an arduino-supported microcontroller board using [platformio](https://platformio.org/).

It has a lot of common things set up for most common boards used in the art/music/maker world, including a few optimizations and weird fixes. 

It includes suggestions for libraries to use so you don't have to dig around too much for the common stuff. Just uncomment in the platformio.ini file and recompile.

## Features

- 🐩 Platformio-based – easy to compile and upload, gets dependencies automatically, also easy to extend with new boards
- 🐩 Includes a lot of common libraries. Just comment/uncomment in [platformio.ini](platformio.ini) to your project's liking.
- 🐩 Set up for C++17, allowing a lot of modern C++ tricks.
- 🐩 A helper script is included in [.scripts/commands.sh](.scripts/commands.sh) to make tedious processes simpler.
- 🐩 VSCode tasks are included making building easy in VSCode and in NeoVim (using the Overseer plugin)
- 🐩 A Github Action which runs every time you push code to test if your firmware still compiles.

## Supported boards

- ✅ Raspberry Pi Pico
- ✅ Raspberry Pi PicoW
- ✅ Teensy 4.1
- ✅ Teensy 4.0
- ✅ Teensy LC
- ✅ NodeMCUV2 ESP8266 
- ✅ ESP32 dev boards
- ✅ Adafruit Feather ESP32
- ✅ Adafruit Feather ESP32 S2

... And it's very easy to add more boards:

### Adding new boards

The included script has a command to fuzzy search through available boards and automatically insert it into `platformio.ini` and auto update the vscode tasks as well.
 
Add new board using this command:
```bash
.scripts/commands.sh add_board
```

Then open `platformio.ini` and make any additional adjustments.

## Usage

### Compiling and uploading

To compile and upload your sketch, simply run this command, adjusted to one of the supported boards, eg for Teensy 4.0:

```bash
.scripts/commands.sh build teensy40
```

Or to build and then upload in one command:
```bash
.scripts/commands.sh upload teensy40
```

Finally, the project includes vscode tasks, which are the recommended way of running these commands. Either using vscode as an editor, or in neovim using the [overseer.nvim](https://github.com/stevearc/overseer.nvim) for NeoVim.

### Installing dependencies

You need to have platformio installed to make use of this.

Install it on MacOS by running homebrew:

```bash
brew install platformio
```
If you want to use all the helper scripts' features for adding new boards to your project, you also need `fzf` and `jq`:

```bash
brew install fzf jq
```

### Using the helper script

Some additional features are packed into the included helper script, run it without arguments to get a list of commands:

```bash
.scripts/commands.sh
```
