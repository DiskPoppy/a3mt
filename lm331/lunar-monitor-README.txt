### Lunar Monitor ###

A tool that lets you automatically export resources (levels, map16, shared palettes, 
overworld/title screen/credits) whenever they are saved to the ROM while using 
Lunar Magic.

This tool is intended for use in combination with Lunar Helper and this guide 
assumes you are familiar with it already. Please use the included version 
of Lunar Helper, the only difference compared to the standard version is that 
it doesn't have a Save function anymore, because Lunar Monitor makes it unnecessary!

Only tested on Windows, may not work on other operating systems.

DISCLAIMER: 

    I cannot guarantee that using this program will not corrupt your ROM data 
    or export corrupted data. I have tested all functionality and used this tool 
    for months and not had any issues but considering I am hijacking a program 
    whose internals I do not fully understand (Lunar Magic) there is always 
    potential for something to go wrong so keep that in mind if you want to use 
    this tool.

NOTE: 

    Currently this tool only works with Lunar Magic 3.30 and 3.31 (there are 
    two separate versions available).


## Source Code ##

The source code for this tool is available at 

    https://github.com/Underrout/lunar-monitor


## Assumptions ##

The rest of this guide will assume you are already familiar with basic SMW hacking 
tools, such as Lunar Magic, FLIPS, GPS, PIXI, Asar, AddmusicK and UberASM Tool as 
well as Lunar Helper. 


## Setup ##

To set this up you will need 

- lunar-monitor-injector.exe
- usertoolbar.txt
- lunar-monitor-config.txt
- lunar-monitor.dll

The first three can just be taken from the same directory as this readme. There are 
two lunar-monitor.dll files included in this zip archive, depending on which Lunar 
Magic version you are using. If you are using Lunar Magic 3.31, please grab the 
one from the LM3.31 directory. Likewise, if you are using Lunar Magic 3.30, take 
the one from the LM3.30 directory. Any other Lunar Magic versions are currently 
unsupported!

To actually start setup, put 

- lunar-monitor-injector.exe
- lunar-monitor.dll
- usertoolbar.txt 

in the same directory as your Lunar Magic executable.

lunar-monitor-config.txt is an example of a configuration file for Lunar Monitor. 
You should put a file with this precise name in the same directory as the ROM(s) 
you want to automatically extract resources from. 

You can put as many of these configuration files in as many locations as you want
if you have multiple projects.

Lunar Monitor will **never** do anything if there is no configuration file in the 
same folder as the ROM you're currently editing!

The contents of the example configuration file lunar-monitor-config.txt are:

level_directory: "Levels"
mwl_file_format: "level #.mwl"
flips_path: "../Tools/FLIPS/flips.exe"
map16_path: "Other/all.map16"
clean_rom_path: "../SMW_clean.smc"
global_data_path: "Other/global_data.bps"
shared_palettes_path: "Other/shared.pal"
log_level: Log
log_path: "Other/lunar-monitor-log.txt"

These should be relatively self explanatory, especially if you have used Lunar 
Helper before.

All paths are relative to the directory the configuration file and your ROM 
are in.

I will briefly explain each configuration variable.


# level_directory

`level_directory` specifies the directory levels will be exported to, this should 
point to the same directory as the `levels` variable from Lunar Helper.


# mwl_file_format

`mwl_file_format` specifies the naming for exported level files. The '#' character 
is a placeholder for the level number. For example, if the `mwl_file_format` is 
"level #.mwl" and we save level 10A it will be exported as "level 10A.mwl". You 
should probably leave this unchanged as it's the exact format Lunar Magic will 
use when exporting levels by default.


# flips_path

`flips_path` specifies the path to your FLIPS executable. This should be the same 
as the `flips_path` variable from Lunar Helper. 

NOTE: 

    Older FLIPS versions have a bug that sometimes results in them returning error 
    codes despite creating/applying .bps patches correctly so be sure to get an 
    up-to-date version.


# map16_path

`map16_path` specifies the path the map16 file should be exported to. This should 
be the same as the `map16` variable from Lunar Helper.


# clean_rom_path

`clean_rom_path` specifies the path to a clean Super Mario World ROM. This should 
be the same as the `clean` variable from Lunar Helper.


# global_data_path

`global_data_path` specifies the path the global data .bps patch should be exported 
to. This patch will contain the overworld, title screen, credits and global 
exanimation data from your ROM. The path should be the same as the `global_data` 
variable from Lunar Helper.


# shared_palettes_path

`shared_palettes_path` specifies the path the shared palette .pal should be 
exported to. This should be the same as the `shared_palette` variable from 
Lunar Helper.


 # log_level

`log_level` specifies the type of logging that's going to be done by the tool. 
There are 3 possible logging levels: Warn, Log and Silent. Warn is the noisiest 
one, which will pop up a message box when a warning/error is issued and log 
everything else to file, Log will just log everything to a file while Silent will 
not log anything.


# human_readable_map16_cli_path

`human_readable_map16_cli_path` specifies the path to a Human Readable 
Map16 Conversion Executable(https://github.com/Underrout/human-readable-map16-cli). 
This value is optional, if it is present, this executable will be used to convert the 
map16 file exported to `map16_path` into a human readable text format. These text files 
will be output into a directory with the same name as the .map16 file, but with 
the .map16 extension stripped. The directory will be in the same location as the 
.map16 file. The .map16 file will **not** automatically be deleted after conversion.


# log_path

`log_path` specifies the path where the logging messages will be written to.


## Limitations ##

The only limitation I am currently aware of is that global exanimation is not 
automatically exported as soon as it is saved, because as far as I know it's saved 
via the same save button as levels. Global exanimation will still be saved whenever 
the overworld, title screen or credits are saved though, so if you change the global 
exanimations and save one of those three right after your changes will be exported 
as expected.

It's possible operating systems and/or antivirus software may flag this as malware 
since DLL injection is sometimes used by malicious software. If you are concerned 
about this, feel free to look through the source code, which is completely public, 
and build the binaries from it yourself instead of using the included binaries 
(which, to be clear, are built from the exact same source code and only provided 
for convenience).

Lunar Monitor will very likely not work with older or future Lunar Magic versions, 
since addresses may move around. The Lunar Magic versions I worked off of and tested 
with are 3.30 and 3.31.


## Finishing Up ##

Make sure you specify all the configuration variables correctly or Lunar Monitor won't 
export resources reliably. 

The last 2 configuration variables (`log_path` and `log_level`) can be omitted. If omitted 
`log_level` will default to Log and `log_path` will default to a file named 
`lunar_monitor_log.txt` in the same folder as your ROM.

That should be it. Open your Lunar Magic executable, save a level, map16, 
shared palettes, etc. and you should see your resources automatically be extracted to 
the specified directories. 

You can use this Lunar Magic executable as you would any other program, you can make 
shortcuts to it, pin it to your taskbar, create a file association for it, etc. and 
Lunar Monitor should still work correctly.

If it doesn't seem to be working, please double check that:
- all the paths in your lunar-monitor-config.txt are correct
- you're actually using the Lunar Magic executable that's in the same folder as 
  lunar-monitor-injector.exe, lunar-monitor.dll and usertoolbar.txt
- you're using Lunar Magic 3.30 or 3.31 and have the correct version of the .dll for your 
  Lunar Magic version
