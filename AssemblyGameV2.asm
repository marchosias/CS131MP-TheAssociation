title AssemblyGame
;author TheAssociation

.model small
.data
	startMsg db "PRESS ANY KEY TO START", '$'
	instructionsPart1 db "Place your character under the small box whose", '$'
	instructionsPart2 db "color is the same as the bigger box.", '$'
	corresKeys db "Corresponding keys for each box: A, S, D, J, K, L", '$'
	currentRow db 12 ;for start display
	currentCol db 30 ;for start display
	;box coordinates and colors
	bigBoxRow db 3
	bigBoxCol db 36
	bigBoxColor db 04h
	boxARow db 12
	boxACol db 8
	boxAColor db 01h
	boxSRow db 12
	boxSCol db 20
	boxSColor db 02h
	boxDRow db 12
	boxDCol db 32
	boxDColor db 03h
	boxJRow db 12
	boxJCol db 44
	boxJColor db 04h
	boxKRow db 12
	boxKCol db 56
	boxKColor db 05h
	boxLRow db 12
	boxLCol db 68
	boxLColor db 06h
	counterR db 0
	counterC db 0
	square db 254
	;score
	scoreMsg db "Score: ", '$'
	scOnes db 48 ;ones digit
	scTens db 48 ;tens digit
	
.stack 100h
.code

	clrscr  proc ;clears screen
		mov ax, 0600h
		mov bh, 07h
		xor cx, cx
		mov dx, 184fh
		int 10h
		ret
	clrscr endp
	
	checkScore proc ;if score is a multiple of ten, scOnes = 0 & scTens++
		cmp scOnes, 58
		je incTens
		jne return
		incTens:
			mov scOnes, 0
			inc scTens
		return:
			ret
	checkScore endp
	
	displayScore proc
	
		call checkScore
		
		mov dh, 0
		mov dl, 0
		xor bh, bh
		mov ah, 02h
		int 10h
		
		lea dx, scoreMsg
		mov ah, 09h
		int 21h
		
		mov dh, 0
		mov dl, 7
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, scTens
		mov bh, 0
		mov bl, 0Fh
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 0
		mov dl, 8
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, scOnes
		mov bh, 0
		mov bl, 0Fh
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		ret
	displayScore endp
	
	displayBigBox proc
		bigboxr: ;displays rows
			mov dh, bigBoxRow
			mov dl, bigBoxCol
			xor bh, bh
			mov ah, 02h
			int 10h
			mov al, square
			mov bh, 0
			mov bl, bigBoxColor
			xor cx, cx
			mov cx, 1
			mov ah, 09h
			int 10h
			bigboxc: ;displays columns
				mov dh, bigBoxRow
				mov dl, bigBoxCol
				xor bh, bh
				mov ah, 02h
				int 10h
				mov al, square
				mov bh, 0
				mov bl, bigBoxColor
				xor cx, cx
				mov cx, 1
				mov ah, 09h
				int 10h
				inc counterC
				inc bigBoxCol
				cmp counterC, 8
				jl bigboxc
			inc counterR
			inc bigBoxRow
			mov counterC, 0
			mov bigBoxCol, 36
			cmp counterR, 5
			jl bigboxr
		mov counterC, 0
		mov counterR, 0
		ret
	displayBigBox endp
	
	displayBoxA proc
		boxAr:
			mov dh, boxARow
			mov dl, boxACol
			xor bh, bh
			mov ah, 02h
			int 10h
			mov al, square
			mov bh, 0
			mov bl, boxAColor
			xor cx, cx
			mov cx, 1
			mov ah, 09h
			int 10h
			boxAc:
				mov dh, boxARow
				mov dl, boxACol
				xor bh, bh
				mov ah, 02h
				int 10h
				mov al, square
				mov bh, 0
				mov bl, boxAColor
				xor cx, cx
				mov cx, 1
				mov ah, 09h
				int 10h
				inc counterC
				inc boxACol
				cmp counterC, 4
				jl boxAc
			inc counterR
			inc boxARow
			mov counterC, 0
			mov boxACol, 8
			cmp counterR, 3
			jl boxAr
		mov counterC, 0
		mov counterR, 0
		ret
	displayBoxA endp
	
	displayBoxS proc
		boxSr:
			mov dh, boxSRow
			mov dl, boxSCol
			xor bh, bh
			mov ah, 02h
			int 10h
			mov al, square
			mov bh, 0
			mov bl, boxSColor
			xor cx, cx
			mov cx, 1
			mov ah, 09h
			int 10h
			boxSc:
				mov dh, boxSRow
				mov dl, boxSCol
				xor bh, bh
				mov ah, 02h
				int 10h
				mov al, square
				mov bh, 0
				mov bl, boxSColor
				xor cx, cx
				mov cx, 1
				mov ah, 09h
				int 10h
				inc counterC
				inc boxSCol
				cmp counterC, 4
				jl boxSc
			inc counterR
			inc boxSRow
			mov counterC, 0
			mov boxSCol, 20
			cmp counterR, 3
			jl boxSr
		mov counterC, 0
		mov counterR, 0
		ret
	displayBoxS endp
	
	displayBoxD proc
		boxDr:
			mov dh, boxDRow
			mov dl, boxDCol
			xor bh, bh
			mov ah, 02h
			int 10h
			mov al, square
			mov bh, 0
			mov bl, boxDColor
			xor cx, cx
			mov cx, 1
			mov ah, 09h
			int 10h
			boxDc:
				mov dh, boxDRow
				mov dl, boxDCol
				xor bh, bh
				mov ah, 02h
				int 10h
				mov al, square
				mov bh, 0
				mov bl, boxDColor
				xor cx, cx
				mov cx, 1
				mov ah, 09h
				int 10h
				inc counterC
				inc boxDCol
				cmp counterC, 4
				jl boxDc
			inc counterR
			inc boxDRow
			mov counterC, 0
			mov boxDCol, 32
			cmp counterR, 3
			jl boxDr
		mov counterC, 0
		mov counterR, 0
		ret
	displayBoxD endp
		
	displayBoxJ proc
		boxJr:
			mov dh, boxJRow
			mov dl, boxJCol
			xor bh, bh
			mov ah, 02h
			int 10h
			mov al, square
			mov bh, 0
			mov bl, boxJColor
			xor cx, cx
			mov cx, 1
			mov ah, 09h
			int 10h
			boxJc:
				mov dh, boxJRow
				mov dl, boxJCol
				xor bh, bh
				mov ah, 02h
				int 10h
				mov al, square
				mov bh, 0
				mov bl, boxJColor
				xor cx, cx
				mov cx, 1
				mov ah, 09h
				int 10h
				inc counterC
				inc boxJCol
				cmp counterC, 4
				jl boxJc
			inc counterR
			inc boxJRow
			mov counterC, 0
			mov boxJCol, 44
			cmp counterR, 3
			jl boxJr
		mov counterC, 0
		mov counterR, 0
		ret
	displayBoxJ endp
	
	displayBoxK proc
		boxKr:
			mov dh, boxKRow
			mov dl, boxKCol
			xor bh, bh
			mov ah, 02h
			int 10h
			mov al, square
			mov bh, 0
			mov bl, boxKColor
			xor cx, cx
			mov cx, 1
			mov ah, 09h
			int 10h
			boxKc:
				mov dh, boxKRow
				mov dl, boxKCol
				xor bh, bh
				mov ah, 02h
				int 10h
				mov al, square
				mov bh, 0
				mov bl, boxKColor
				xor cx, cx
				mov cx, 1
				mov ah, 09h
				int 10h
				inc counterC
				inc boxKCol
				cmp counterC, 4
				jl boxKc
			inc counterR
			inc boxKRow
			mov counterC, 0
			mov boxKCol, 56
			cmp counterR, 3
			jl boxKr
		mov counterC, 0
		mov counterR, 0
		ret
	displayBoxK endp
	
	displayBoxL proc
		boxLr:
			mov dh, boxLRow
			mov dl, boxLCol
			xor bh, bh
			mov ah, 02h
			int 10h
			mov al, square
			mov bh, 0
			mov bl, boxLColor
			xor cx, cx
			mov cx, 1
			mov ah, 09h
			int 10h
			boxLc:
				mov dh, boxLRow
				mov dl, boxLCol
				xor bh, bh
				mov ah, 02h
				int 10h
				mov al, square
				mov bh, 0
				mov bl, boxLColor
				xor cx, cx
				mov cx, 1
				mov ah, 09h
				int 10h
				inc counterC
				inc boxLCol
				cmp counterC, 4
				jl boxLc
			inc counterR
			inc boxLRow
			mov counterC, 0
			mov boxLCol, 68
			cmp counterR, 3
			jl boxLr
		mov counterC, 0
		mov counterR, 0
		ret
	displayBoxL endp

	displayCursor proc
		mov dh, currentRow
		mov dl, currentCol
		xor bh, bh
		mov ah, 02h
		int 10h
	displayCursor endp
	
	newline proc
		mov dl, 0Ah
		mov ah, 02h
		int 21h
		ret
	newline endp
	
	gameFrame proc
		call displayScore
		call displayBigBox
		call displayBoxA
		call displayBoxS
		call displayboxD
		call displayboxJ
		call displayboxK
		call displayboxL
		ret
	gameFrame endp
	
	displayTitle proc
		;C
		mov dh, 3
		mov dl, 4
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 3
		mov dl, 5
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 3
		mov dl, 6
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 3
		mov dl, 7
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 8
		mov dl, 4
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 8
		mov dl, 5
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 8
		mov dl, 6
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 8
		mov dl, 7
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 4
		mov dl, 3
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 5
		mov dl, 3
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 6
		mov dl, 3
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 7
		mov dl, 3
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		;O
		mov dh, 3
		mov dl, 12
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 3
		mov dl, 13
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 3
		mov dl, 14
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 3
		mov dl, 15
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 8
		mov dl, 12
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 8
		mov dl, 13
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 8
		mov dl, 14
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 8
		mov dl, 15
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 4
		mov dl, 11
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 5
		mov dl, 11
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 6
		mov dl, 11
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 7
		mov dl, 11
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 4
		mov dl, 16
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 5
		mov dl, 16
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 6
		mov dl, 16
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 7
		mov dl, 16
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		;L
		mov dh, 3
		mov dl, 20
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 4
		mov dl, 20
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 5
		mov dl, 20
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 6
		mov dl, 20
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 7
		mov dl, 20
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 8
		mov dl, 20
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 8
		mov dl, 21
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 8
		mov dl, 22
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 8
		mov dl, 23
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 8
		mov dl, 24
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		;O
		mov dh, 3
		mov dl, 29
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 3
		mov dl, 30
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 3
		mov dl, 31
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 3
		mov dl, 32
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 8
		mov dl, 29
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 8
		mov dl, 30
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 8
		mov dl, 31
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 8
		mov dl, 32
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 4
		mov dl, 28
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 5
		mov dl, 28
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 6
		mov dl, 28
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 7
		mov dl, 28
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 4
		mov dl, 33
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 5
		mov dl, 33
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 6
		mov dl, 33
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 7
		mov dl, 33
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		;R		
		mov dh, 3
		mov dl, 37
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 4
		mov dl, 37
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 5
		mov dl, 37
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 6
		mov dl, 37
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 7
		mov dl, 37
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 8
		mov dl, 37
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 3
		mov dl, 38
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 3
		mov dl, 39
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 3
		mov dl, 40
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 3
		mov dl, 41
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 4
		mov dl, 42
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 5
		mov dl, 42
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 6
		mov dl, 38
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 6
		mov dl, 39
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 6
		mov dl, 40
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 6
		mov dl, 41
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 7
		mov dl, 42
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 8
		mov dl, 42
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		;J
		mov dh, 6
		mov dl, 49
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 7
		mov dl, 49
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 8
		mov dl, 50
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 8
		mov dl, 50
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 8
		mov dl, 51
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 8
		mov dl, 52
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 8
		mov dl, 53
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 3
		mov dl, 54
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 4
		mov dl, 54
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 5
		mov dl, 54
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 6
		mov dl, 54
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 7
		mov dl, 54
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		;A
		mov dh, 4
		mov dl, 58
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 5
		mov dl, 58
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 6
		mov dl, 58
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 7
		mov dl, 58
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 8
		mov dl, 58
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 3
		mov dl, 59
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 3
		mov dl, 60
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 3
		mov dl, 61
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 3
		mov dl, 62
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 4
		mov dl, 63
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 5
		mov dl, 63
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 6
		mov dl, 63
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 7
		mov dl, 63
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 8
		mov dl, 63
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 6
		mov dl, 59
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 6
		mov dl, 60
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 6
		mov dl, 61
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 6
		mov dl, 62
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		;M		
		mov dh, 4
		mov dl, 67
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 5
		mov dl, 67
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 6
		mov dl, 67
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 7
		mov dl, 67
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 8
		mov dl, 67
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 3
		mov dl, 68
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 3
		mov dl, 69
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 3
		mov dl, 70
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 4
		mov dl, 71
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 5
		mov dl, 71
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 6
		mov dl, 71
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 7
		mov dl, 71
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 8
		mov dl, 71
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 3
		mov dl, 72
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 3
		mov dl, 73
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 3
		mov dl, 74
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 4
		mov dl, 75
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 5
		mov dl, 75
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 6
		mov dl, 75
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 7
		mov dl, 75
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 8
		mov dl, 75
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, square
		mov bh, 0
		mov bl, 01h
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		ret
	displayTitle endp
	
	startFrame proc
		call displayTitle
		
		call displayCursor
		
		lea dx, startMsg
		mov ah, 9
		int 21h
		
		call newline
		inc currentRow
		inc currentRow
		mov currentCol, 17
		call displayCursor
		
		lea dx, instructionsPart1
		mov ah, 9
		int 21h
		
		call newline
		inc currentRow
		mov currentCol, 23
		call displayCursor
		
		lea dx, instructionsPart2
		mov ah, 9
		int 21h
		
		call newline
		inc currentRow
		inc currentRow
		mov currentCol, 15
		call displayCursor
		
		lea dx, corresKeys
		mov ah, 9
		int 21h
		
		mov ah, 01h
		int 21h
		ret
	startFrame endp
	main	proc
	
	mov ax, @data
	mov ds, ax
	;start
	
	;video mode
	mov al, 03h
	mov ah, 00h
	int 10h
	
	;set cursor
	mov cx, 3200h
	mov ah, 01h
	int 10h
	
	call displayCursor
	
	call startFrame
	call clrscr
	call gameFrame
	
	;end
	mov ax, 4c00h
	int 21h
	
	main endp
	end main
