bits 32

cursor_pos_x	db 0
cursor_pos_y	db 1

; write function
; output one character to current cursor position
; input :
;		al	:	character would be printed
write:
	push edi
	push eax

	;mov edi,(80 * cursor_pos_x + cursor_pos_y) * 2
    mov eax,80
	mul byte [cursor_pos_y]
	add byte al, [cursor_pos_x]
	mov edi,2
	mul edi
	mov edi,eax
	
	pop eax
	mov ah,0Ch
	mov [gs:edi],ax

	add byte [cursor_pos_x],1
	cmp byte [cursor_pos_x],80
	jle .end
	mov byte [cursor_pos_x],0
	add byte [cursor_pos_y],1
.end:
	pop edi
	ret