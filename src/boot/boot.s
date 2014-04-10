	bits 16
	BOOT_SEG equ 0x07C0
	SYSTEM_SEG equ 0x1000
	SYSTEM_LEN equ 0x1000

start:
	jmp BOOT_SEG:go
go:
	mov ax,cs
	mov ds,ax
	mov ss,ax
	mov sp,0x400
	
	;clear the screen
	call clear_screen
	
	;print 'load system...'
	mov si,msgloading
	call puts

load_system:
	mov dx,0x0080	;head 0x0 drive 0x80
	mov cx,0x2
	mov ax,SYSTEM_SEG ;es:bx is buffer address
	mov es,ax
	xor bx,bx
	mov ax,0x200+0x10 ;AH=0x02 AL=0x10(sectors count to read )
	int 0x13
	jnc ok_load
die:
	;fail load system
	mov si,msgfailload
	call puts
	jmp $
	
ok_load:
	cli
	mov ax,SYSTEM_SEG
	mov ds,ax
	xor ax,ax
	mov es,ax
	mov cx,SYSTEM_LEN
	xor di,di
	xor si,si
	rep movsw	;mov from ds:si to es:di
	
	;load system success and reset 8259A
	mov si,msg8259A
	;call puts

	;8259A编程，参考linux0.11 setup.s对中断的重新编程
	;原PC BIOS硬件中断号为0x08-0x0F，现在放到Intel保留
	;中断之后，即0x20开始。
	;比如时钟中断原来为0x08，现在为0x20
	;这里重新编程以后，还要在IDT中设置处理时钟中断的程序
	;是第0x20项（即如果这里不对中断重新编程，IDT的时钟中断
	;依然是第0x08项）。
	mov al,0x11
	out 0x20,al
	dw 0x00eb,0x00eb
	out 0xA0,al
	dw 0x00eb,0x00eb
	
	mov al,0x20
	out 0x21,al
	dw 0x00eb,0x00eb
	mov al,0x28
	out 0xA1,al
	dw 0x00eb,0x00eb
	mov al,0x04
	out 0x21,al
	dw 0x00eb,0x00eb
	mov al,0x02
	out 0xA1,al
	dw 0x00eb,0x00eb
	mov al,0x03		;AEOI,x8086
	out 0x21,al
	dw 0x00eb,0x00eb
	out 0xA1,al
	dw 0x00eb,0x00eb
	mov al,0xff  ;I don't want to mask any interrupt
	out 0x21,al
	dw 0x00eb,0x00eb
	out 0xA1,al
	
	;begin exec system module
	;mov si,msgexecsystem
	;call puts
	mov ax, BOOT_SEG
	mov ds,ax
	lidt [idt_48]
	lgdt [gdt_48]

	;open A20
	;in al, 92h
	;or al,00000010b
	;out 92h,al
	;start protect mode
	mov ax,0x1
	lmsw ax
	jmp 0x8:0
	
gdt:
	dw 0,0,0,0
	
	dw 0x07FF
	dw 0x0000
	dw 0x9A00
	dw 0x00C0
	
	dw 0x07FF
	dw 0x0000
	dw 0x9200
	dw 0x00C0
	
idt_48:
	dw 0
	dw 0,0
	
gdt_48:
	dw 0x7ff
	dw 0x7c00+gdt,0
	

;clear_screen()
;description: clear the screen & set the cursor at top,left
clear_screen:
	pusha
	mov ax, 0x0600
	xor cx, cx
	xor bh, 0x0f                          ; white
	mov dh, 24
	mov dl, 79
	int 0x10
        
	mov ah, 02
	mov bh, 0
	mov dx, 0
	int 0x10        
	popa
	ret

;putc()
;description: print one character
;input: 
;	SI - input char
;	BL - background color & front color
putc:
	push bx
	xor bh,bh
	mov ax,si
	mov ah,0x0e
	int 0x10
	pop bx
	ret

;putln()
;description: put cursor at the begin of next line	
putln:
	mov si,13
	call putc
	mov si,10
	call putc
	ret
	
;puts()
;description: print one string
;input: 
;	SI - string
;	BL - background color & front color
puts:
	pusha
	mov ah,0x0e
	xor bh,bh
puts_while:
	lodsb
	test al,al
	jz puts_end
	int 0x10
	jmp puts_while
puts_end:
	popa
	ret

msgloading: db 'loading system...',13,10,0
msgfailload: db 'loading system failed...',13,10,0
msg8259A: db 'reset 8259A',13,10,0
msgexecsystem: db 'begin exec system module',13,10,0
msgtest: db 'test 8259A',13,10,0

	times 510-($-$$) db 0
	dw 0xAA55
