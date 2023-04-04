INCLUDE CANDY.INC
.MODEL SMALL
.STACK 0100H
.DATA
	ARRAY CANDY 49 DUP(<4,0>)
	GRIDCOLOR DB 10
	SQUARE_COLOR DB 1
	RECTANGLE_COLOR DB 4
	TRIANGLE_COLOR DB 5
	DIAMOND_COLOR DB 6
	PENTAGON_COLOR DB 11
.CODE
	MOV AX, @DATA
	MOV DS, AX
	
	;SET VIDEO OUTPUT MODE
	MOV AH, 0
	MOV AL, 14
	INT 10H
	
	;SET BACKGROUND COLOR
	MOV AH, 0BH
	MOV BH, 00H
	MOV BL, 0 ;COLOR
	INT 10H
	
	CALL MAKEGRID
	
	MOV AH, 4CH
	INT 21H
	
	GRID PROC USES AX BX CX DX
		PUSH CX
		PUSH DX
		
		MOV BX, 0
		.WHILE BX < 8 ;8 ROWS
			PUSH BX
			PUSH CX
			
			MOV BX, 0
			.WHILE BX < 2 ;RUN 2 TIMES BECAUSE 2 X-AXIS PIXEL = 1 Y-AXIS PIXEL
				PUSH BX
				
				MOV BX, 0
				.WHILE BX < 140
					MOV AH, 0CH
					MOV AL, GRIDCOLOR
					INT 10H
					
					INC CX
					
					INC BX
				.ENDW
				POP BX
				INC BX
			.ENDW
			POP CX
			POP BX
			
			INC BX
			ADD DX, 20
		.ENDW
		
		POP DX
		POP CX
		
		MOV BX, 0
		.WHILE BX < 8 ;8 COLUMNS
			PUSH BX
			PUSH DX
			
			MOV BX, 0
			.WHILE BX < 140
				MOV AH, 0CH
				MOV AL, GRIDCOLOR
				INT 10H
				
				INC DX
				
				INC BX
			.ENDW
			
			POP DX
			POP BX
			
			INC BX
			ADD CX, 40
		.ENDW
		RET
	GRID ENDP
	
	SQUARE PROC USES AX BX CX DX
		MOV BX, 0
		.WHILE BX < 28
			MOV AH, 0CH
			MOV AL, SQUARE_COLOR
			INT 10H
			
			INC CX
			
			INC BX
		.ENDW
		
		MOV BX, 0
		.WHILE BX < 14
			MOV AH, 0CH
			MOV AL, SQUARE_COLOR
			INT 10H
			
			INC DX
			
			INC BX
		.ENDW
		
		MOV BX, 0
		.WHILE BX < 28
			MOV AH, 0CH
			MOV AL, SQUARE_COLOR
			INT 10H
			
			DEC CX
			
			INC BX
		.ENDW
		
		MOV BX, 0
		.WHILE BX < 14
			MOV AH, 0CH
			MOV AL, SQUARE_COLOR
			INT 10H
			
			DEC DX
			
			INC BX
		.ENDW
		RET
	SQUARE ENDP
	
	RECTANGLE PROC USES AX BX CX DX
		ADD DX, 2
		MOV BX, 0
		.WHILE BX < 28
			MOV AH, 0CH
			MOV AL, RECTANGLE_COLOR
			INT 10H
			
			INC CX
			
			INC BX
		.ENDW
		
		MOV BX, 0
		.WHILE BX < 10
			MOV AH, 0CH
			MOV AL, RECTANGLE_COLOR
			INT 10H
			
			INC DX
			
			INC BX
		.ENDW
		
		MOV BX, 0
		.WHILE BX < 28
			MOV AH, 0CH
			MOV AL, RECTANGLE_COLOR
			INT 10H
			
			DEC CX
			
			INC BX
		.ENDW
		
		MOV BX, 0
		.WHILE BX < 10
			MOV AH, 0CH
			MOV AL, RECTANGLE_COLOR
			INT 10H
			
			DEC DX
			
			INC BX
		.ENDW
		RET
	RECTANGLE ENDP
	
	TRIANGLE PROC USES AX BX CX DX
		ADD CX, 15
		MOV BX, 0
		.WHILE BX < 14
			MOV AH, 0CH
			MOV AL, TRIANGLE_COLOR
			INT 10H
			
			INC CX
			INC DX
			
			INC BX
		.ENDW
		
		MOV BX, 0
		.WHILE BX < 28
			MOV AH, 0CH
			MOV AL, TRIANGLE_COLOR
			INT 10H
			
			DEC CX
			
			INC BX
		.ENDW
		
		MOV BX, 0
		.WHILE BX < 14
			MOV AH, 0CH
			MOV AL, TRIANGLE_COLOR
			INT 10H
			
			INC CX
			DEC DX
			
			INC BX
		.ENDW
		RET
	TRIANGLE ENDP
	
	DIAMOND PROC USES AX BX CX DX
		ADD CX, 15
		MOV BX, 0
		.WHILE BX < 7
			MOV AH, 0CH
			MOV AL, DIAMOND_COLOR
			INT 10H
			
			ADD CX, 2
			INC DX
			
			INC BX
		.ENDW
		
		MOV BX, 0
		.WHILE BX < 7
			MOV AH, 0CH
			MOV AL, DIAMOND_COLOR
			INT 10H
			
			SUB CX, 2
			INC DX
			
			INC BX
		.ENDW
		
		MOV BX, 0
		.WHILE BX < 7
			MOV AH, 0CH
			MOV AL, DIAMOND_COLOR
			INT 10H
			
			SUB CX, 2
			DEC DX
			
			INC BX
		.ENDW
		
		MOV BX, 0
		.WHILE BX < 7
			MOV AH, 0CH
			MOV AL, DIAMOND_COLOR
			INT 10H
			
			ADD CX, 2
			DEC DX
			
			INC BX
		.ENDW
		RET
	DIAMOND ENDP
	
	PENTAGON PROC USES AX BX CX DX
		ADD CX, 15
		MOV BX, 0
		.WHILE BX < 7
			MOV AH, 0CH
			MOV AL, PENTAGON_COLOR
			INT 10H
			
			ADD CX, 2
			INC DX
			
			INC BX
		.ENDW
		
		MOV BX, 0
		.WHILE BX < 7
			MOV AH, 0CH
			MOV AL, PENTAGON_COLOR
			INT 10H
			
			DEC CX
			INC DX
			
			INC BX
		.ENDW
		
		MOV BX, 0
		.WHILE BX < 14
			MOV AH, 0CH
			MOV AL, PENTAGON_COLOR
			INT 10H
			
			DEC CX
			
			INC BX
		.ENDW
		
		MOV BX, 0
		.WHILE BX < 7
			MOV AH, 0CH
			MOV AL, PENTAGON_COLOR
			INT 10H
			
			DEC CX
			DEC DX
			
			INC BX
		.ENDW
		
		MOV BX, 0
		.WHILE BX < 7
			MOV AH, 0CH
			MOV AL, PENTAGON_COLOR
			INT 10H
			
			ADD CX, 2
			DEC DX
			
			INC BX
		.ENDW
		RET
	PENTAGON ENDP
	
	SHAPES PROC USES AX BX CX DX SI
		MOV BX, 0
		MOV SI, 0
		.WHILE BX < 7
			PUSH BX
			PUSH CX
			MOV BX, 0
			.WHILE BX < 7
				MOV AL, ARRAY[SI].ID
				.IF AL == 1
					CALL SQUARE
				.ELSEIF AL == 2
					CALL RECTANGLE
				.ELSEIF AL == 3
					CALL TRIANGLE
				.ELSEIF AL == 4
					CALL DIAMOND
				.ELSE
					CALL PENTAGON
				.ENDIF
				ADD CX, 40
				
				ADD SI, 2
				INC BX
			.ENDW
			ADD DX, 20
			
			POP CX
			POP BX
			INC BX
		.ENDW
		RET
	SHAPES ENDP
	
	MAKEGRID PROC
		MOV CX, 180
		MOV DX, 30
		CALL GRID
	
		MOV CX, 186
		MOV DX, 33
		CALL SHAPES
		RET
	MAKEGRID ENDP
END