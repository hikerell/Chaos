#!/bin/sh

#set project path
CHAOS=/home/alan/vmos/Chaos

echo "enter in $CHAOS/src/boot/ ..."
cd $CHAOS/src/boot/
nasm boot.S -o boot
nasm head.S -i $CHAOS/src/ -o head

echo "enter in $CHAOS/bin/ ..."
cd $CHAOS/bin/
dd if=$CHAOS/src/boot/boot of=vmchaos count=1 seek=0 bs=512 conv=notrunc
dd if=$CHAOS/src/boot/head of=vmchaos count=16 seek=1 bs=512 conv=notrunc

echo "clear temp files ..."
rm $CHAOS/src/boot/boot
rm $CHAOS/src/boot/head

echo "vmchaos is the kernel image !"
