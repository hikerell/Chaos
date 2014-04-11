# Chaos - New OS Plan #

God don't ban it!

## WHAT IS CHAOS ##

Chaos is a new Operating System expected to be defferent from others. How defferent it is, I don't know. Maybe you know, maybe the God love it !

## WHAT ARE BESIC BELIEFS ##

I have no idea in fact, so waiting for your sharings! However they may be:

* Geek style.
* Highest security.

## DO I HVAE THINKINGS ON ARCHITECTURE ##

Yeah, but a little.

* Drivers shouldn't belong to OS Kernel, namely they won't run on Ring0.
* Implented using NASM and Golang.

## WHAT ARE WE LACKING ##

God, or YOU!

## HOW TO COMPILE ##

* Git the project in your Linux
* Install bochs 2.6.x
* Install NASM
* Generate "hd image" under bin/ path using bximage and rename it "vmchaos".  bximage tool is a part of  bochs tools.
* run compile.h to compile sources and rewrite vmlinuz.
* Run vmlinux within bochs:
    bochs -f bochsrc.bxrc
  bochsrc.bxrc is default config file for bochs.

## Next ... ##

* Hack Chaos and debug it.
* Rewrite the REAMME.md and so on.

Sorry for some faults and curtness :-( I'm rather rushed for time today.

I will update all tomorrow and tomorrow's tomorrow, see you!

(Oops!Poor English!You may is not an pig!)
