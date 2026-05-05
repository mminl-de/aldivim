# Aldivim
An elegant way to settle differences.

## What is m5?
- A text preprocessor, similar to GNU m4
- See here: https://github.com/hiimsergey/m5

## How does this work?
- This config is build by and for multiple persons, each person has individual needs, features, plugins and settings.
To achieve this we write the config file in the Preprocessor m5, "compile" it for the individual person and make vim use the compiled lua version
- This allows easy customization, easy addition of users while retaining fast performance and a clean lua config

## Usage
- Install m5 by downloading the x86 binary from github or building it by source (see https://github.com/hiimsergey/m5)
- run `make name` for a configuration of your choice written in the `Makefile`
- link or copy the created `lua/` folder to your config folder (e.g. `~/.config/nvim/`)
- install lsp binaries if needed
- enjoy :)
