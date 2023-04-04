.model small
.stack 0100h
.data
	gridcolor db 10
.code
	mov AX, @data
	mov DS, AX
	
	;Set video output mode
	mov AH, 0
	mov AL, 14
	int 10h
	
	;Set background color
	mov AH, 0Bh
	mov BH, 00h
	mov BL, 8 ;Color
	int 10h
	
	mov CX, 180
	mov DX, 30
	call Grid
	
	
	mov AH, 4Ch
	int 21h
	
	Grid proc
		push CX
		push DX
		
		mov BX, 0
		.while BX < 8 ;8 rows
			push BX
			push CX
			
			mov BX, 0
			.while BX < 2 ;run 2 times because 2 x-axis pixel = 1 y-axis pixel
				push BX
				
				mov BX, 0
				.while BX < 140
					mov AH, 0Ch
					mov AL, gridcolor
					int 10h
					
					inc CX
					
					inc BX
				.endw
				pop BX
				inc BX
			.endw
			pop CX
			pop BX
			
			inc BX
			add DX, 20
		.endw
		
		pop DX
		pop CX
		
		mov BX, 0
		.while BX < 8 ;8 columns
			push BX
			push DX
			
			mov BX, 0
			.while BX < 140
				mov AH, 0Ch
				mov AL, gridcolor
				int 10h
				
				inc DX
				
				inc BX
			.endw
			
			pop DX
			pop BX
			
			inc BX
			add CX, 40
		.endw
		ret
	Grid endp
	
end