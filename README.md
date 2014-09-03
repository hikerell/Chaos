# Chaos - New OS Plan #

God don't ban it!

## WHAT IS CHAOS ##

Chaos is a new Operating System expected to be defferent from others.

I have no idea in fact! However they may be:

* Implemented by NASM and Golang
* Geek style.
* Highest security, etc..MAC
* Drivers won't run on Ring0.

## HOW TO COMPILE ##

* Git the project in your Linux
* Install bochs 2.6.x
* Install NASM
* Generate "hd image" under bin/ path using bximage and rename it "vmchaos".  bximage tool is a part of  bochs tools.
* run compile.h to compile sources and rewrite vmchaos.
* Run vmlinux within bochs:
    bochs -f bochsrc.bxrc
  bochsrc.bxrc is default config file for bochs.

## TODO ##

* Add goalng runtime init routine before main() execute...

Sorry for some faults and curtness :-( I'm rather rushed for time today.

I will update Chaos tomorrow and tomorrow's tomorrow!

