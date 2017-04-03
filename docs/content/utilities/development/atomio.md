# Setup Atom Editor for MOOSE

!image docs/media/atom_screenshot.png width=300px padding-left=20px float=right caption=Screenshot of Atom in action

[Atom](http://atom.io) is a text editor developed by GitHub with a flexible plugin structure. Several plugins are available to customize Atom for MOOSE development, some specifically developed for MOOSE.

## Setting up Atom
Installation packages can be downloaded for Mac, Linux, and Windows operating systems from the [Atom website](http://atom.io). The editor has an automatic update system for both the core editor as well as the installed plugins.

### First Steps
- **Start Atom** for the first time and select _Atom->Install Shell Commands_. This activates the ```atom``` and ```apm``` shell commands for use from a terminal.
- **Close Atom**. From now on we will only start it from our MOOSE project directories using ```atom .``` ensuring that Atom sees the full MOOSE build environment.

## Important commands

!image docs/media/atom_fuzzyfinder.png width=300px padding-left=20px float=right caption=Opening new files with the fuzzy search (Cmd-T)

* **Cmd-Shift-P** opens the command palette. Every available Atom command can be accessed by typing a few letters here. The dropdown list shows the keyboard shortcuts.
* **Cmd-T** opens a file anywhere in the current project tree (i.e. below the directory in which you issued the `atom .` command. No need to know the precise path or even the precise spelling of the filename!

## Plugins
Tip: To install a plugin, use the "apm" command on your terminal:

```bash
apm install switch-header-source
```

!image docs/media/atom_autocomplete.gif width=300px padding-left=20px float=right caption=Autocompletion for MOOSE input files

The following plugins should be installed to effectively develop MOOSE based codes and edit MOOSE input files using Atom

* [switch-header-source](http://atom.io/packages/switch-header-source) - Use **Ctrl-Alt-S** to switch between corresponding header and source files.
* [language-moose](http://atom.io/packages/language-moose) - Syntax highlighting and automatic indentation for MOOSE input files, C++ [code snippets](./Snippets) for all MOOSE systems, and highlighting of select MOOSE C++ types.
* [autocomplete-moose](http://atom.io/packages/autocomplete-moose) - Context sensitive autocompletion for MOOSE input files.
* [make-runner](http://atom.io/packages/make-runner) - Press **Ctrl-R** to build the current project from within Atom. Features clickable compile error messages to jump straight to the locations with the compile errors.
* [autocomplete-clang](http://atom.io/packages/autocomplete-clang) - Type-aware C++ autocompletion. Use ```make clang_complete``` in your project directory to generate the necessary configuration file.
* [clang-format](http://atom.io/packages/clang-format) - Uses clang-format with the custom MOOSE style rules to format your code. Can be set to reformat automatically when saving or manually by pressing **Cmd-Shift-K**.
* [atomic-rtags](http://atom.io/packages/atomic-rtags) - uses the rtags demon (live indexing of the C++ symbols in your source tree) to provide a _jump to declaration_ feature. See below how to set-up rtags with MOOSE

### Recommended settings
* In the _whitespace_ core package (Settings->Packages search for 'whitespace') deactivate _Ignore Whitespace On Current Line_.

## Source navigation with [rtags](https://github.com/Andersbakken/rtags)

Download and build rtags

```bash
git clone https://github.com/Andersbakken/rtags.git
cd rtags/
git submodule init
git submodule update
mkdir mybuild && cd mybuild
cmake ..
make -j 24
sudo make install
```

Start the rtags demon in a separate terminal

```bash
rdm
```

Leave that terminal open in the background and get back to your old terminal.
Then change into your application directory (or `moose/modules/combined`) and run

```bash
make cleanall
make -n | grep -v bin/libtool | rc -c -
```

This will cause make to transmit a list of all compile commands to the rtags demon. The rtags demon will immediately start indexing all MOOSE sourcecode files (you can observe the process in the rdm terminal window).

You can now press `alt+,` in Atom with the cursor on any symbol (even macros) to jump to its declaration courtesy of the _atomic-rtags_ package.

### Using Atom behind a proxy
To enable update checking and plugin installation proxy information must be entered in a configuration file at ```~/.atom/.apmrc``` (create the file as needed) as

```text
proxy = http://server:port
http-proxy = http://server:port
http_proxy = http://server:port
https_proxy = http://server:port
```
