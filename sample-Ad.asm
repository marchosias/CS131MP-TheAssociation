.model small
.data
var1 db 0
ctr db 0
var2 dd 'a'
var3 dw 'putangina!','$'
.stack 100h
.code
	main proc
	
	mov ax, @data
	mov ds, ax
	
	do:
	mov dl, 'shit'
	mov ah, 02h
	int 21h
	
	inc ctr
	
	endDo:
	cmp ctr, 13
	jle do
	
	while:
	mov dl, 'shit'
	mov ah, 02h
	int 21h
	inc ctr
	cmp ctr,13
	jle while
	
	mov dl, 'shit'
	mov ah, 02h
	int 21h
	
	mov ax, 4c00h
	int 21h
	
	main endp
	end main
