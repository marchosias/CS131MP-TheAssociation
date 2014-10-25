title echo
;author Jesh
.model small
.data
	var db ?
.stack 100h
.code
	main	proc
	
	mov ax, @data
	mov ds, ax
	
	;humihingi ng input
	mov ah, 01h
	int 21h ;gagawin kung ano yung laman ni ah
	
	mov var, al
	
	mov dl, 0Ah
	mov ah, 02h
	int 21h
	
	mov dl, var
	mov bl, 09h
	mov ah, 02h
	int 21h
	
	mov ax, 4c00h
	int 21h
	
	main endp
	end main
