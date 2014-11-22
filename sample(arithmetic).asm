title Hello World
;@author: Jeshurun C. Orquina
;@editor: Nathan Dela Rosa
;@editor: Adriel Arevalo

.model small
.data
	message db "Hello World", '$'
	var dw 0
	var1 dw 5
.stack 100h
.code
	main	proc
	
	mov ax, @data ;initializes segment registers
	mov ds, ax    ;DS and ES
	
	lea dx, message 
	mov ah, 09h
	int 21h

	do:
	lea dx, message 
	mov ah, 09h
	int 21h
	inc ctr
	cmp ctr, 13
	jl do
	
	while:
	inc ctr
	cmp ctr, 13
	jg endwhile
	mov dl, 'j'
	mov ah, 02h
	int 21h
	jmp while
	endwhile:
	
	cmp ctr, 13
	jle if
	jmp else

	if:
	mov dl, 'k'
	mov ah, 02h
	int 21h

	else:
	mov dl, 'j'
	mov ah, 02h
	int 21h
	
	mov al, var1
	add var0, al
	
	mov bl, var1
	sub var0, bl
	
	mov al, var1
	mov bl, 1
	mul bl
	mov var0, ax
	
	mov ax, 4c00h ;return 0
	int 21h       ;return 0
	
	main endp     ;}
	end main
