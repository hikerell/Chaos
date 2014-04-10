#!/bin/sh

cd boot
nasm boot.s -o boot
nasm head.s -o head
cd ../


dd if=boot/boot of=c.img count=1 seek=0 bs=512 conv=notrunc
dd if=boot/head of=c.img count=16 seek=1 bs=512 conv=notrunc

rm boot/boot
rm boot/head
echo 'finished'
