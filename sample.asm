.model small
.data
.stack 100h
.code
	main proc
	mov ax, @data
	mov ds, ax

	mov dl, 'j'
	mov ah, 02h
	int 21h

	mov ax, 4c00h
	int 21h
	main	endp
	end main
