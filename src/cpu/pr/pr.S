bits 32

;Descriptor
; 31 30 29 28 27 26 25 24  23  22  21  20  19 18 17 16  15  14 13 12 11 10 9 8 7 6 5 4 3 2 1 0
;----------------------------------------------------------------------------------------------
;|     Base 31:24        | G |D/B | L| AVL| Limit 19:16| P | DPL | S| TYPE    |  Base 23:16   |     
;----------------------------------------------------------------------------------------------
; 31 30 29 28 27 26 25 24  23  22  21  20  19 18 17 16  15  14 13 12 11 10 9 8 7 6 5 4 3 2 1 0
;----------------------------------------------------------------------------------------------
;|    Base 15:0                                        |           Limit 15:0                 |
;----------------------------------------------------------------------------------------------
;usgae: Descriptor Base, Limit, Attr
;		Base : 	dd
;		Limit:	dd (low 20 bits available)
;		Attr : 	dw (lower 4 bits of higher byte are always 0)
%macro Descriptor 3
		dw	%2 & 0FFFFh			 
		dw	%1 & 0FFFFh
		db	( %1 >> 16 ) & 0FFh 
		dw  ( ( %2 >> 8) & 0F00h ) | ( %3 & 0F0FFh )
		db	( %1 >> 24 ) & 0FFh
%endmacro

;GDT G=0(byte) D/B=1(32-bit) L=0(not 64-bit) AVL=0
%define D_0B00 	0C000h

;Code- and Data-Segment Descriptor Types
%define D_DR	0x0
%define D_DRA	0x1
%define D_DRW	0x2
%define D_DRWA	0x3
%define D_DRE	0x4
%define D_DREA	0x5
%define D_DRWE	0x6
%define D_DRWEA	0x7
%define D_CE	0x8
%define D_CEA	0x9
%define D_CER	0xA
%define D_CERA	0xB
%define D_CEC	0xC
%define D_CECA	0xD
%define D_CERC	0xE
%define D_CERCA	0xF

;System-Segment and Gate-Descriptor Types
;just 32-Bit mode
%define D_16TSSA	0x1
%define D_LDT		0x2
%define D_16TSSB	0x3
%define D_16CG		0x4
%define D_IG		0x5
%define D_16IG		0x6
%define D_16TG		0x7
%define D_TSS		0x9
%define D_TSSB		0xB
%define D_CG		0xC
%define D_IG		0xE
%define D_TG 		0xF