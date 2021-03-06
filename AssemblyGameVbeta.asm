title AssemblyGame
;author TheAssociation

.model small
.data
	startMsg db "PRESS ANY KEY TO START", '$'
	gomsg db "GAME OVER :P" , '$'
	instructionsPart1 db "Place your character under the small box whose", '$'
	instructionsPart2 db "color is the same as the bigger box.", '$'
	instructionsPart3 db "Before time runs out :D", '$'
	playerNamemsg db "Enter a 3-charactered player name:", '$'
	highScore db "High Scores:",'$'
	corresKeys db "Corresponding keys for each box: A, S, D, J, K, L", '$'
	currentRow db 12 ;for start display
	currentCol db 30 ;for start display
	;box coordinates and colors
	rank1 db "1. ", '$'
	rank2 db "2. ", '$'
	rank3 db "3. ", '$'
	rank4 db "4. ", '$'
	rank5 db "5. ", '$'
	handle dw ?
	handle2 dw ?
	mes2 db "File not found!", '$'
	buffer db ' ',' ',' ','0','0', 0ah,' ',' ',' ','0','0', 0ah,' ',' ',' ','0','0', 0ah,' ',' ',' ','0','0', 0ah,' ',' ',' ','0','0', 0ah
	filename db "score.txt", 0
	keypressed db 0
	funckey db 0
	delaytime db 6
	colornum db 0
	playerRow db 18
	playerCol db 39
	playerRowprime db 18
	playerColprime db 39
	playerColor db 0fh
	bigBoxRow db 3
	bigBoxCol db 36
	bigBoxRowprime db 3
	bigBoxColprime db 36
	bigBoxColor db 04h
	boxARow db 12
	boxACol db 8
	boxARowprime db 12
	boxAColprime db 8
	boxAColor db 01h
	boxSRow db 12
	boxSCol db 20
	boxSRowprime db 12
	boxSColprime db 20
	boxSColor db 02h
	boxDRow db 12
	boxDCol db 32
	boxDRowprime db 12
	boxDColprime db 32
	boxDColor db 03h
	boxJRow db 12
	boxJCol db 44
	boxJRowprime db 12
	boxJColprime db 44
	boxJColor db 04h
	boxKRow db 12
	boxKCol db 56
	boxKRowprime db 12
	boxKColprime db 56
	boxKColor db 05h
	boxLRow db 12
	boxLCol db 68
	boxLRowprime db 12
	boxLColprime db 68
	boxLColor db 06h
	counterR db 0
	counterC db 0
	square db 254
	;score
	scoreMsg db "Score: ", '$'
	timeMsg db "Timer: ", '$'
	time db 57
	scOnes db 48 ;ones digit
	scTens db 48 ;tens digit
	tempOnes db 48
	tempTens db 48
	tempname1 db 48
	tempname2 db 48
	tempname3 db 48
	bxHolder dw ?
	clHolder db ?
	pname db 3 dup(" "), '$'
	
.stack 100h
.code
	playerNameInput proc
		mov dh, 6
		mov dl, 25
		xor bh, bh
		mov ah, 02h
		int 10h

		mov dx, offset playerNamemsg
		mov ah, 09h
		int 21h
		mov dh, 7
		mov dl, 36
		xor bh, bh
		mov ah, 02h
		int 10h
		
		mov dh, 8
		mov dl, 40
		xor bh, bh
		mov ah, 02h
		int 10h

		mov cx, 0607h
		mov ah, 01h
		int 10h

		mov bx, 0
		inputline:
		mov ah, 1
		int 21h
		mov pname[bx], al
		inc bx
		cmp bx, 3
		jl inputline

		mov cx, 3200h
		mov ah, 01h
		int 10h

		ret
	playerNameInput endp
	highest proc
		mov bxHolder, bx
		mov clHolder, cl
		mov bx, 3
		compare:
		cmp bx, 29
		jge exit1
		mov cl, scTens
		cmp buffer[bx], cl
		jl moveIndex
		je compOnes
		jg moveTens
		
		moveIndex:
		sub bx, 3
		mov cl, buffer[bx]
		mov tempname1, cl
		mov cl, pname[0]
		mov buffer[bx], cl
		inc bx
		mov cl, buffer[bx]
		mov tempname2, cl
		mov cl, pname[1]
		mov buffer[bx], cl
		inc bx
		mov cl, buffer[bx]
		mov tempname3, cl
		mov cl, pname[2]
		mov buffer[bx], cl
		inc bx
		mov cl, buffer[bx]
		mov tempTens, cl
		mov cl, scTens
		mov buffer[bx], cl
		inc bx
		mov cl, buffer[bx]
		mov tempOnes, cl
		mov cl, scOnes
		mov buffer[bx], cl
		inc bx
		inc bx
		inc bx
		inc bx
		inc bx
		mov cl, tempname1
		mov pname[0], cl
		mov cl, tempname2
		mov pname[1], cl
		mov cl, tempname3
		mov pname[2], cl
		mov cl, tempTens
		mov scTens, cl
		mov cl, tempOnes
		mov scOnes, cl	
		cmp bx, 29
		jl moveIndex
		jge exit1
		
		compOnes:
		inc bx
		mov cl, buffer[bx]
		cmp scOnes,cl
		jge moveToTens
		jl moveTensfromOnes
		
		moveToTens:
		dec bx
		jmp moveIndex

		moveTensfromOnes:
		inc bx 
		cmp buffer[bx], 0ah
		je incb
		jne com
		
		moveTens:
		inc bx 
		inc bx
		cmp buffer[bx], 0ah
		je incb
		jne com
		
		incb:
		inc bx
		inc bx 
		inc bx
		inc bx
		
		com:
		jmp compare
		
		exit1:
		mov bx, bxHolder
		mov cl, clHolder
		ret	
	highest endp
	
	
	displayHighScores proc
		mov dh, 9
		mov dl, 36
		xor bh, bh
		mov ah, 02h
		int 10h
		lea dx, highScore
		mov ah, 09h
		int 21h		
		mov dh, 10
		mov dl, 36
		xor bh, bh
		mov ah, 02h
		int 10h
		mov dx, offset rank1
		mov ah, 09h
		int 21h
		mov dh, 10
		mov dl, 39
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, buffer[0]
		mov bh, 0
		mov bl, 0Eh
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		mov dh, 10
		mov dl, 40
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, buffer[1]
		mov bh, 0
		mov bl, 0Eh
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		mov dh, 10
		mov dl, 41
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, buffer[2]
		mov bh, 0
		mov bl, 0Eh
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		mov dh, 10
		mov dl, 43
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, buffer[3]
		mov bh, 0
		mov bl, 0Eh
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		mov dh, 10
		mov dl, 44
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, buffer[4]
		mov bh, 0
		mov bl, 0Eh
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 11
		mov dl, 36
		xor bh, bh
		mov ah, 02h
		int 10h
		mov dx, offset rank2
		mov ah, 09h
		int 21h
		mov dh, 11
		mov dl, 39
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, buffer[6]
		mov bh, 0
		mov bl, 0Eh
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		mov dh, 11
		mov dl, 40
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, buffer[7]
		mov bh, 0
		mov bl, 0Eh
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		mov dh, 11
		mov dl, 41
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, buffer[8]
		mov bh, 0
		mov bl, 0Eh
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		mov dh, 11
		mov dl, 43
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, buffer[9]
		mov bh, 0
		mov bl, 0Eh
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		mov dh, 11
		mov dl, 44
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, buffer[10]
		mov bh, 0
		mov bl, 0Eh
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 12
		mov dl, 36
		xor bh, bh
		mov ah, 02h
		int 10h
		mov dx, offset rank3
		mov ah, 09h
		int 21h
		mov dh, 12
		mov dl, 39
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, buffer[12]
		mov bh, 0
		mov bl, 0Eh
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		mov dh, 12
		mov dl, 40
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, buffer[13]
		mov bh, 0
		mov bl, 0Eh
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		mov dh, 12
		mov dl, 41
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, buffer[14]
		mov bh, 0
		mov bl, 0Eh
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		mov dh, 12
		mov dl, 43
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, buffer[15]
		mov bh, 0
		mov bl, 0Eh
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		mov dh, 12
		mov dl, 44
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, buffer[16]
		mov bh, 0
		mov bl, 0Eh
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 13
		mov dl, 36
		xor bh, bh
		mov ah, 02h
		int 10h
		mov dx, offset rank4
		mov ah, 09h
		int 21h
		mov dh, 13
		mov dl, 39
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, buffer[18]
		mov bh, 0
		mov bl, 0Eh
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		mov dh, 13
		mov dl, 40
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, buffer[19]
		mov bh, 0
		mov bl, 0Eh
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		mov dh, 13
		mov dl, 41
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, buffer[20]
		mov bh, 0
		mov bl, 0Eh
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		mov dh, 13
		mov dl, 43
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, buffer[21]
		mov bh, 0
		mov bl, 0Eh
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		mov dh, 13
		mov dl, 44
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, buffer[22]
		mov bh, 0
		mov bl, 0Eh
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		mov dh, 14
		mov dl, 36
		xor bh, bh
		mov ah, 02h
		int 10h
		mov dx, offset rank5
		mov ah, 09h
		int 21h
		mov dh, 14
		mov dl, 39
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, buffer[24]
		mov bh, 0
		mov bl, 0Eh
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		mov dh, 14
		mov dl, 40
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, buffer[25]
		mov bh, 0
		mov bl, 0Eh
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		mov dh, 14
		mov dl, 41
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, buffer[26]
		mov bh, 0
		mov bl, 0Eh
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		mov dh, 14
		mov dl, 43
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, buffer[27]
		mov bh, 0
		mov bl, 0Eh
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		mov dh, 14
		mov dl, 44
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, buffer[28]
		mov bh, 0
		mov bl, 0Eh
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		
		ret
	
	displayHighScores endp
	
	fileProcessingScore proc	
		mov dx, offset filename   ; put address of filename in dx
		mov al,0                 ; access mode - read and write
		mov ah,3dh               ; function 3DH - open a file
		int 21h 
		
		mov handle,ax            ; save file handle for later
		jc erroropening          ; jump if carry flag set - error!
		
		mov dx, offset buffer   ; put address of filename in dx
		mov bx, handle
		mov cx, 29
		mov al,0                 ; access mode - read and write
		mov ah,3fh               ; function 3DH - open a file
		int 21h                  ; call dos service
		jmp continue
		
		erroropening:
		mov dx,offset filename   ; put offset of filename in dx
		xor cx,cx               	 ; clear cx - make ordinary file
		mov ah,3ch              	 ; function 3ch - create a file
		int 21h                 	 ; call dos service	
		
		mov dx, offset filename   ; put address of filename in dx
		mov al,1             	 ; access mode - read and write
		mov ah,3dh              	 ; function 3DH - open a file
		int 21h                 	 ; call dos service
		
		mov handle2, ax
		
		mov cl, pname[0]
		mov buffer[0], cl
		mov cl, pname[1]
		mov buffer[1], cl
		mov cl, pname[2]
		mov buffer[2], cl
		mov cl, scTens
		mov buffer[3], cl
		mov cl, scOnes
		mov buffer[4], cl
		
		mov dx, offset buffer    ; address of information to write
		mov bx, handle2            ; file handle for file
		mov cx,1000                ; 38 bytes to be written
		mov ah,40h               ; function 40h - write to file
		int 21h                  ; call dos service
		
		mov bx, handle2
		mov ah,3eh               ; function 3eh - close a file
		int 21h   
		
		jmp exit2
		
		continue:	
		mov bx, handle
		mov ah,3eh               ; function 3eh - close a file
		int 21h                  ; call dos service	
	
	call highest
	
	mov dx, offset filename   ; put address of filename in dx
	mov al,1             	 ; access mode - read and write
	mov ah,3dh              	 ; function 3DH - open a file
	int 21h                 	 ; call dos service
	
	mov handle2, ax
	
	mov dx, offset buffer    ; address of information to write
	mov bx, handle2            ; file handle for file
	mov cx,1000                ; 38 bytes to be written
	mov ah,40h               ; function 40h - write to file
	int 21h                  ; call dos service
	
	mov bx, handle2
	mov ah,3eh               ; function 3eh - close a file
	int 21h  
	
	jmp exit2
	exit2:
	call displayHighScores	
	
	ret
	fileProcessingScore endp
	
	randomColor proc

	randomizeColor:
	mov colornum, 0

	mov ah, 2ch
	int 21h
	mov ax, dx
	and ax, 0fh
	mov colornum, al

	mov cl, colornum
	cmp cl, 1 
	jl randomizeColor
	cmp cl, 6
	jg randomizeColor
	cmp cl, bigBoxColor
	je randomizeColor
	mov al, colornum
	mov bigBoxColor, al
	cmp al, 2
	je set2
	cmp al, 3
	je set3
	cmp al, 4
	je set4
	cmp al, 5
	je set5
	cmp al, 6
	je set6
	jmp set

	set2:
	mov boxAColor, 6
	mov boxSColor, 5
	mov boxDColor, 4
	mov boxJColor, 3
	mov boxKColor, 2
	mov boxLColor, 1
	jmp set

	set3:
	mov boxAColor, 5
	mov boxSColor, 3
	mov boxDColor, 1
	mov boxJColor, 2
	mov boxKColor, 4
	mov boxLColor, 6
	jmp set

	set4:
	mov boxAColor, 4
	mov boxSColor, 5
	mov boxDColor, 6
	mov boxJColor, 1
	mov boxKColor, 2
	mov boxLColor, 3
	jmp set

	set5:
	mov boxAColor, 4
	mov boxSColor, 3
	mov boxDColor, 5
	mov boxJColor, 2
	mov boxKColor, 6
	mov boxLColor, 1
	jmp set

	set6:
	mov boxAColor, 1
	mov boxSColor, 5
	mov boxDColor, 2
	mov boxJColor, 6
	mov boxKColor, 3
	mov boxLColor, 4
	jmp set

	set:
	ret
	randomColor endp

	clrscr  proc ;clears screen
		mov ax, 0600h
		mov bh, 07h
		xor cx, cx
		mov dx, 184fh
		int 10h
		ret
	clrscr endp

	delay proc
    mov ah, 00
    int 1Ah
    mov bx, dx

	jmp_delay:
    int 1Ah
    sub dx, bx
    cmp dl, delaytime
    jl jmp_delay
    ret

	delay endp
	
	checkScore proc ;if score is a multiple of ten, scOnes = 0 & scTens++
		cmp scOnes, 57
		je incTens
		jne return
		incTens:
			mov scOnes, 48
			inc scTens
			cmp scTens, 53
			je speedUpbwahahaha
			jmp samespeed
			speedUpbwahahaha:
			mov delaytime, 4
			samespeed:
			ret
		return:
			inc scOnes
			mov time, 57
			ret
	checkScore endp

	displayTime proc

		mov dh, 0
		mov dl, 70
		xor bh, bh
		mov ah, 02h
		int 10h
		
		lea dx, timeMsg
		mov ah, 09h
		int 21h
		
		mov dh, 0
		mov dl, 76
		xor bh, bh
		mov ah, 02h
		int 10h
		mov al, time
		mov bh, 0
		mov bl, 0Fh
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h

		ret
	displayTime endp
	
	displayScore proc
		
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
		mov al, bigBoxRowprime
		mov ah, bigBoxColprime
		mov bigBoxRow , al
		mov bigBoxCol, ah
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
		mov al, boxARowprime
		mov ah, boxAColprime
		mov boxARow , al
		mov boxACol, ah
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
		mov al, boxSRowprime
		mov ah, boxSColprime
		mov boxSRow , al
		mov boxSCol, ah
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
		mov al, boxDRowprime
		mov ah, boxDColprime
		mov boxDRow , al
		mov boxDCol, ah
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
		mov al, boxJRowprime
		mov ah, boxJColprime
		mov boxJRow , al
		mov boxJCol, ah
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
		mov al, boxKRowprime
		mov ah, boxKColprime
		mov boxKRow , al
		mov boxKCol, ah
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
		mov al, boxLRowprime
		mov ah, boxLColprime
		mov boxLRow , al
		mov boxLCol, ah
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
		call displayTime
		call displayBigBox
		call displayBoxA
		call displayBoxS
		call displayboxD
		call displayboxJ
		call displayboxK
		call displayboxL
		call displayPlayer
		ret
	gameFrame endp

	displayPlayer proc
		playerr:
			mov dh, playerRow
			mov dl, playerCol
			xor bh, bh
			mov ah, 02h
			int 10h
			mov al, square
			mov bh, 0
			mov bl, playerColor
			xor cx, cx
			mov cx, 1
			mov ah, 09h
			int 10h
			playerc:
				mov dh, playerRow
				mov dl, playerCol
				xor bh, bh
				mov ah, 02h
				int 10h
				mov al, square
				mov bh, 0
				mov bl, playerColor
				xor cx, cx
				mov cx, 1
				mov ah, 09h
				int 10h
				inc counterC
				inc playerCol
				cmp counterC, 2
				jl playerc
			inc counterR
			inc playerRow
			mov counterC, 0
			mov al, playerColprime
			mov playerCol, al
			cmp counterR, 2
			jl playerr
		mov counterC, 0
		mov counterR, 0
		mov al, playerRowprime
		mov ah, playerColprime
		mov playerRow , al
		mov playerCol, ah
		ret
	displayPlayer endp
	
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

		mov dh, 12
		mov dl, 29
		xor bh, bh
		mov ah, 02h
		int 10h
		
		lea dx, startMsg
		mov ah, 9
		int 21h
		
		call newline
		inc currentRow
		inc currentRow
		mov currentCol, 17
		call displayCursor

		mov dh, 14
		mov dl, 16
		xor bh, bh
		mov ah, 02h
		int 10h
		
		lea dx, instructionsPart1
		mov ah, 9
		int 21h
		
		call newline
		inc currentRow
		mov currentCol, 23
		call displayCursor

		mov dh, 15
		mov dl, 21
		xor bh, bh
		mov ah, 02h
		int 10h
		
		lea dx, instructionsPart2
		mov ah, 9
		int 21h
		
		call newline
		inc currentRow
		inc currentRow
		mov currentCol, 15
		call displayCursor

		mov dh, 16
		mov dl, 29
		xor bh, bh
		mov ah, 02h
		int 10h
		
		lea dx, instructionsPart3
		mov ah, 9
		int 21h

		call newline
		inc currentRow
		inc currentRow
		mov currentCol, 15
		call displayCursor

		mov dh, 17
		mov dl, 16
		xor bh, bh
		mov ah, 02h
		int 10h
		
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
	call randomColor
	
	call startFrame
	call clrscr
	call playerNameInput
	call clrscr
	call gameFrame

	mov ah, 00
	int 16h
	mov keypressed, al
	mov funckey, ah

	mov ah, 03h
	int 10h

	mov bl, funckey
	cmp bl, 27
	je finale
	mov bl, keypressed
	cmp bl, "a"
	je aBox
	cmp bl, "s"
	je sBox
	cmp bl, "d"
	je dBox
	cmp bl, "j"
	je jBox
	cmp bl, "k"
	je kBox
	cmp bl, "l"
	je lBox
	jmp finale

	start:
	cmp time, 48
	je gameOver
	dec time
  	
	mov ah, 01
	int 16h
	jz dispT

	mov ah, 00
	int 16h
	mov keypressed, al
	mov funckey, ah

	mov ah, 03h
	int 10h

	mov bl, funckey
	cmp bl, 27
	je finale
	mov bl, keypressed
	cmp bl, "a"
	je aBox
	cmp bl, "s"
	je sBox
	cmp bl, "d"
	je dBox
	cmp bl, "j"
	je jBox
	cmp bl, "k"
	je kBox
	cmp bl, "l"
	je lBox
	jmp finale

	dispT:
	call delay
	call clrscr
	call gameFrame
	jmp start
	
	aBox:
	mov al, bigBoxColor
	cmp boxAColor, al
	je scoreAup
	jmp gameOver
	scoreAup:
	call checkScore
	call randomColor
	call clrscr
	call displayCursor
	mov playerCol, 9
	mov playerColprime, 9
	mov al, boxAColor
	mov playerColor, al
	call gameFrame
	jmp start

	sBox:
	mov al, bigBoxColor
	cmp boxSColor, al
	je scoreSup
	jmp gameOver
	scoreSup:
	call checkScore
	call randomColor
	call clrscr
	call displayCursor
	mov playerCol, 21
	mov playerColprime, 21
	mov al, boxSColor
	mov playerColor, al
	call gameFrame
	jmp start

	dBox:
	mov al, bigBoxColor
	cmp boxDColor, al
	je scoreDup
	jmp gameOver
	scoreDup:
	call checkScore
	call randomColor
	call clrscr
	call displayCursor
	mov playerCol, 33
	mov playerColprime, 33
	mov al, boxDColor
	mov playerColor, al
	call gameFrame
	jmp start

	jBox:
	mov al, bigBoxColor
	cmp boxJColor, al
	je scoreJup
	jmp gameOver
	scoreJup:
	call checkScore
	call randomColor
	call clrscr
	call displayCursor
	mov playerCol, 45
	mov playerColprime, 45
	mov al, boxJColor
	mov playerColor, al
	call gameFrame
	jmp start

	kBox:
	mov al, bigBoxColor
	cmp boxKColor, al
	je scoreKup
	jmp gameOver
	scoreKup:
	call checkScore
	call randomColor
	call clrscr
	call displayCursor
	mov playerCol, 57
	mov playerColprime, 57
	mov al, boxKColor
	mov playerColor, al
	call gameFrame
	jmp start

	lBox:
	mov al, bigBoxColor
	cmp boxLColor, al
	je scoreLup
	jmp gameOver
	scoreLup:
	call checkScore
	call randomColor
	call clrscr
	call displayCursor
	mov playerCol, 69
	mov playerColprime, 69
	mov al, boxLColor
	mov playerColor, al
	call gameFrame
	jmp start

	gameOver:
	call clrscr
	mov dh, 6
	mov dl, 36
	xor bh, bh
	mov ah, 02h
	int 10h

	mov dx, offset gomsg
	mov ah, 09h
	int 21h
	mov dh, 7
	mov dl, 36
	xor bh, bh
	mov ah, 02h
	int 10h
	lea dx, scoreMsg
	mov ah, 09h
	int 21h
		
	mov dh, 7
	mov dl, 45
	xor bh, bh
	mov ah, 02h
	int 10h
	mov al, scTens
	mov bh, 0
	mov bl, 0Eh
	xor cx, cx
	mov cx, 1
	mov ah, 09h
	int 10h
		
	mov dh, 7
	mov dl, 46
	xor bh, bh
	mov ah, 02h
	int 10h
	mov al, scOnes
	mov bh, 0
	mov bl, 0Eh
	xor cx, cx
	mov cx, 1
	mov ah, 09h
	int 10h
	call fileProcessingScore
	call newline
	call newline
	call newline
	call newline
	call newline
	call newline
	call newline
	call newline
	call newline
	call newline


	finale:
	;end
	mov ax, 4c00h
	int 21h
	
	main endp
	end main
