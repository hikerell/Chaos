;times 512*16 db 0xcc
bits 32
db 090h
db 090h
db 090h
db 090h
%include "inc32/protect.s"

;LATCH equ 0xffff

;extern main
startup_32:
		jmp gdtCodeSelector:update
update:
		mov eax,gdtDataSelector
		mov ds,ax
		lss esp,[init_stack]
		
		call setup_idt
		call setup_gdt
		mov eax,gdtDataSelector
		mov ds,ax
		;mov es,ax
		;mov fs,ax
		mov eax,gdtVideoSelector
		mov gs,ax
		lss esp,[init_stack]

				

		;8253
		;mov al,0x36
		;mov edx,0x43
		;out dx,al
		;mov eax,LATCH
		;mov edx,0x40
		;out dx,al
		;mov al,ah
		;out dx,al
		
		mov edi, (80 * 11 +79)*2
		mov ah,0Ch
		mov al,'X'
		mov [gs:edi],ax
		;reset IDT 0x8 and 0x80
		;mov eax,0x00080000
		;mov ax,timer_interrupt	;
		;mov dx,0x8e00
		;mov ecx,0x08
		;mov ecx,0x20
		;lea esi,[idt+ecx*8]		;
		;mov [esi],eax
		;mov [esi+4],edx
		;mov ax,system_interrupt
		;mov dx,0xef00
		;mov ecx,0x80
		;lea esi,[idt+ecx*8]
		;mov [esi],eax
		;mov [esi+4],edx
		
		jmp $
		;pushfd
		;and dword [esp],0xffffbfff
		;popfd
		;mov eax,SEL_TSS0	;can?
		;ltr ax
		;mov eax,SEL_LDT0
		;lldt ax
		;mov dword [current],0
		;sti
		;push 0x17			;?
		;push init_stack		;?
		;pushfd
		;push 0x0f			;?
		;push task0			;?
		;iret
		
setup_gdt:
		lgdt [lgdt_opcode]
		ret
		
setup_idt:
		lea edx,[ignore_int] ;?
		mov eax,0x00080000
		mov ax,dx
		mov dx,0x8e00
		lea edi,[idt]		;?
		mov ecx,256
rp_idt:	mov [edi],eax
		mov [edi+4],edx
		add edi,8
		dec ecx
		jne rp_idt
		lidt [lidt_opcode]
		ret
	
		align 4
ignore_int:
		push ds
		push eax
		mov eax,0x10
		mov ds,ax
		mov eax,0x43
		call write_char
		pop eax
		pop ds
		iret
		
write_char:	
	    mov edi, (80 * 12 +79)*2
		mov ah,0Ch
		mov al,'I'
		mov [gs:edi],ax


;IDT
align 8
idt:	times 256*8 db 0
;GDT 
gdt:
G_NULL_E 	: Descriptor 0,0,0 	; GDT NULL ENTRY
G_CODE_E 	: Descriptor 0,07ffh, D_0B00 | D_CERA | 090h
G_DATA_E 	: Descriptor 0,07ffh, D_0B00 | D_DRW | 090h
G_VIDEO_E 	: Descriptor 0B8000h,07fFFFFh, D_0B00 | D_DRW | 090h
end_gdt:
		
align 4
lidt_opcode:
		dw 256*8-1
		dd idt
lgdt_opcode:
		dw (end_gdt-gdt)-1
		dd gdt

		times 128*4 db 0
init_stack:
		dd init_stack
		dw 0x10

;GDT Selector
gdtCodeSelector		equ G_CODE_E  - gdt
gdtDataSelector		equ G_DATA_E  - gdt
gdtVideoSelector	equ G_VIDEO_E - gdt
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
