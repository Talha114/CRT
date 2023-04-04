INCLUDE CANDY.INC
.MODEL SMALL
.STACK 0100H
;.286

.DATA
	GAME_TITLE DB 'TITLE', 0
	PLAYER DB 5 DUP(0), 0
	LEN DW LENGTHOF PLAYER
	CTR DW 0

	TXT DB 'ENTER NAME: ', 0

	HOWTO DB 'The game is played by swiping candies, in any direction (so long as it is not blocked),' 
	;to create sets of 3 or more matching candies. When matched, the candies will crush and shift the candies above them. Match more than 3 candies to create combos', 0
		
	ARRAY CANDY <1,0>,<4,0>,<3,0>,<2,0>,<5,0>,<3,0>,<5,0>,<4,0>,<2,0>,<2,0>,<4,0>,<4,0>,<3,0>,<1,0>,<4,0>,<5,0>,<4,0>,<1,0>,<5,0>,<2,0>,<5,0>,<3,0>,<4,0>,<2,0>,<3,0>,<4,0>,<3,0>,<1,0>,<2,0>,<1,0>,<2,0>,<4,0>,<2,0>,<1,0>,<5,0>,<5,0>,<5,0>,<1,0>,<2,0>,<2,0>,<1,0>,<3,0>,<3,0>,<5,0>,<5,0>,<1,0>,<1,0>,<2,0>;,<5,0>
	
	GRIDCOLOR DB 10
	SQUARE_COLOR DB 1
	RECTANGLE_COLOR DB 4
	TRIANGLE_COLOR DB 5
	DIAMOND_COLOR DB 6
	PENTAGON_COLOR DB 11
	
	X DW 0
	Y DW 0
	
	STR2 DB 'X-COORDINATES: ', 0
	STR3 DB 'Y-COORDINATES: ', 0
	
	CELL DB 'CELL 0,0', 0
	OUTOFBOUNDS DB 'OUT OF BOUNDS', 0
	
	TEMP DW 0
	S1 DW 0
	S2 DW 0
	
	T DW 0
	U DW 0
	D DW 0
	L DW 0
	R DW 0
	
	N1 DW 0
	N2 DW 0

.CODE
MOV AX, @DATA
MOV DS, AX
MOV AX, 0
MOV CX, 0

	;mov ax, 4
	;mov cx, 180 ; X-position
	;mov dx, 30 ; Y-position
	;int 33h
	
	;CALL TITLESCREEN
	
	;CALL CLICK
	;CALL DELAY

	;CALL HOWTOPLAY

	;CALL CLICK
	;CALL DELAY
		
	MOV DI, 0		
			
	CALL MAKEGRID	
		
	;CALL GAME
	MOV SI, 0
	MOV BP, 0
	; BP < NUMBER OF TURNS
	.WHILE BP < 15
		.WHILE DI < 2
			CALL INPUT				
			CALL DELAY			
			
			MOV DX, TEMP
			MOV S1[SI], DX		
			
			INC DI
			ADD SI, 2
		.ENDW					
		
		CALL SWAP		
		CALL CHECKCOMBO
		
		CALL MAKEGRID
		
		MOV SI, 0
		MOV DI, 0
		INC BP
	.ENDW

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
EXIT:
MOV AH, 4CH	;END
INT 21H
;;;;;;;;;;;;;;;;;;;;;;;;;;

SETINDEX PROC
; AX HOLDS ID OF SELECTED	

	MOV AX, S2
	MOV BX, 2
	MUL BX
	MOV SI, AX
	SUB SI, 2
	
	MOV AX, 0
	MOV AL, ARRAY[SI].ID
	RET
SETINDEX ENDP


CHECKCOMBO PROC 
	
	CALL SETINDEX	
		
	;;;;;;;CHECK LEFT COMBO;;;;;;;; 
	MOV CX, 0	
	.WHILE CX < 3				
		.IF ARRAY[SI].ID == AL
			INC AH
		.ENDIF
		ADD SI, 2
		INC CX
	.ENDW	
	
	;;;;;;COMBO EXISTS;;;;;
	.IF AH >= 3
		MOV AL, 1
		CALL COMBO
		RET
	.ENDIF
	
	CALL SETINDEX
	
	;;;;;;;CHECK MIDDLE COMBO;;;;;;;;
				
	.IF ARRAY[SI+2].ID == AL
		INC AH
	.ENDIF
	.IF ARRAY[SI-2].ID == AL
		INC AH
	.ENDIF		
	
	;;;;;;COMBO EXISTS;;;;;
	.IF AH >= 2
		MOV AL, 2
		CALL COMBO
		RET
	.ENDIF		
	
	CALL SETINDEX
	
	;;;;;;;CHECK RIGHT COMBO;;;;;;;;
	MOV CX, 0	
	.WHILE CX < 3				
		.IF ARRAY[SI].ID == AL
			INC AH
		.ENDIF
		SUB SI, 2
		INC CX
	.ENDW	
	
	;;;;;;COMBO EXISTS;;;;;
	.IF AH >= 3
		MOV AL, 3
		CALL COMBO
		RET
	.ENDIF	
	
	CALL SETINDEX
	
	;;;;;;;CHECK UP COMBO;;;;;;;;
	MOV CX, 0	
	.WHILE CX < 3				
		.IF ARRAY[SI].ID == AL
			INC AH
		.ENDIF
		SUB SI, 14
		INC CX
	.ENDW	
	
	;;;;;;COMBO EXISTS;;;;;
	.IF AH >= 3
		MOV AL, 4
		CALL COMBO
		RET
	.ENDIF	
	
	CALL SETINDEX
	
	;;;;;;;CHECK MIDDLE-UP COMBO;;;;;;;;
	.IF ARRAY[SI+14].ID == AL
		INC AH
	.ENDIF
	.IF ARRAY[SI-14].ID == AL
		INC AH
	.ENDIF		
	
	;;;;;;COMBO EXISTS;;;;;
	.IF AH >= 2
		MOV AL, 5
		CALL COMBO
		RET
	.ENDIF	
	
	CALL SETINDEX
	
	;;;;;;;CHECK DOWN COMBO;;;;;;;;
	MOV CX, 0	
	.WHILE CX < 3				
		.IF ARRAY[SI].ID == AL
			INC AH
		.ENDIF
		ADD SI, 14
		INC CX
	.ENDW	
	
	;;;;;;COMBO EXISTS;;;;;
	.IF AH >= 3
		MOV AL, 6
		CALL COMBO
		RET
	.ENDIF	
	
	RET
CHECKCOMBO ENDP

COMBO PROC 
	PUSH AX

	CALL SETINDEX

	POP AX
	
	.IF AL == 1
		;;;;;;;CHECK LEFT COMBO;;;;;;;;
		MOV CX, 0	
		.WHILE CX < 3				
			MOV ARRAY[SI].ID, 0					
			ADD SI, 2
			INC CX
		.ENDW		
	.ELSEIF AL == 2
		;;;;;;;CHECK MIDDLE COMBO;;;;;;;;
		MOV CX, 0	
		SUB SI, 2
		.WHILE CX < 3				
			MOV ARRAY[SI].ID, 0					
			ADD SI, 2
			INC CX
		.ENDW	
	.ELSEIF AL == 3
		;;;;;;;CHECK RIGHT COMBO;;;;;;;;
		MOV CX, 0	
		.WHILE CX < 3				
			MOV ARRAY[SI].ID, 0					
			SUB SI, 2
			INC CX
		.ENDW
	.ELSEIF AL == 4
		;;;;;;;CHECK UP COMBO;;;;;;;;
		MOV CX, 0	
		.WHILE CX < 3				
			MOV ARRAY[SI].ID, 0					
			SUB SI, 14
			INC CX
		.ENDW	
	.ELSEIF AL == 5
		;;;;;;;CHECK MIDDLE-UP COMBO;;;;;;;;
		MOV CX, 0	
		SUB SI, 14
		.WHILE CX < 3				
			MOV ARRAY[SI].ID, 0					
			ADD SI, 14
			INC CX
		.ENDW	
	.ELSEIF AL == 6
		;;;;;;;CHECK DOWN COMBO;;;;;;;;
		MOV CX, 0	
		.WHILE CX < 3				
			MOV ARRAY[SI].ID, 0					
			ADD SI, 14
			INC CX
		.ENDW	
	.ENDIF
	
	RET
COMBO ENDP
	
SWAP PROC USES AX BX SI DI
;AX USED FOR HOLDING 1ST SELECTED CELL
;BX USED FOR HOLDING 2ND SELECTED CELL
;SI USED FOR HOLDING 1ST SHAPE
;DI USED FOR HOLDING 2ND SHAPE

	;;;;;;;;; CHECKING FOR SWAPPING CONDITIONS ;;;;;;;;	
	
	;LEFT
	MOV AX, S1
	MOV T, AX
	SUB T, 1
	MOV AX, T
	MOV L, AX
	
	;RIGHT
	MOV AX, S1
	MOV T, AX
	ADD T, 1
	MOV AX, T
	MOV R, AX
	
	;UP
	MOV AX, S1
	MOV T, AX
	SUB T, 7
	MOV AX, T
	MOV U, AX
	
	;DOWN
	MOV AX, S1
	MOV T, AX
	ADD T, 7
	MOV AX, T
	MOV D, AX
	
	MOV AX, S2
	
	.IF AX != U 
		.IF AX != D
			.IF AX != L
				.IF AX != R
					RET
				.ENDIF
			.ENDIF
		.ENDIF
	.ENDIF

	;;;;;;;; IF CONDITIONS ARE MET THEN SWAP ;;;;;;;;

	MOV AX, S1
	MOV BX, 2
	MUL BX
	MOV SI, AX
	SUB SI, 2
	
	MOV AX, S2
	MOV BX, 2
	MUL BX
	MOV DI, AX
	SUB DI, 2
	
	MOV AX, 0
	MOV BX, 0	
	
	MOV AX, ARRAY[SI]	
	MOV BX, ARRAY[DI]
	XCHG AX, BX			;SWAPPING
		
	MOV ARRAY[SI], AX	
	MOV ARRAY[DI], BX	
	
	RET
SWAP ENDP

SELECTED PROC USES AX 
;AX = ROW/COL SELECTED

	MOV TEMP, AX	
	RET
SELECTED ENDP

DELAY PROC USES CX DX
	MOV CX, 250
	
	L1:
		MOV DX, 1000
		L2:
			DEC DX
		CMP DX, 0
		JNE L2
	LOOP L1
	
	RET
DELAY ENDP

INPUTSTR PROC USES AX BX SI
	L1:
		MOV AH, 1
		INT 21H
		
		CMP AL, 13
		JE EXITINPUT
		
		MOV [SI], AL
		INC SI
	JMP L1
		
	EXITINPUT:
		MOV DL, 0
		MOV [SI], DL		
	RET
INPUTSTR ENDP	

DISPLAY PROC USES AX BX CX DX SI DI
	MOV CTR, 0
	.WHILE CTR < DI
		MOV AH, 0AH	;WRITE CHARACTER AT CURSOR POSITION		
		MOV AL, [SI]	;CHARACTER
		INC SI
		;MOV BL, 	;FOR COLOR
		MOV CX, 1	;NUMBER OF TIMES TO PRINT CHARACTER
		INT 10H

		MOV AH, 02H	;SET CURSOR POSITION
		INC DL		;WRITE ONE SPACE/COLUMN AFTER 
		INT 10H

		INC CTR
	.ENDW		
	RET
DISPLAY ENDP

BORDER PROC USES AX BX CX DX SI DI

;BX = CTR
;CX = X
;DX = Y
;SI = X LEN
;DI = Y LEN

	MOV BX, 0

	.WHILE BX < SI
		MOV AH, 0CH
		MOV AL, 15
		INT 10H

		INC CX

		INC BX
	.ENDW

	MOV BX, 0
	.WHILE BX < DI
		MOV AH, 0CH
		MOV AL, 15
		INT 10H

		INC DX

		INC BX
	.ENDW

	MOV BX, 0
	.WHILE BX < SI
		MOV AH, 0CH
		MOV AL, 15
		INT 10H

		DEC CX

		INC BX
	.ENDW

	MOV BX, 0
	.WHILE BX < DI
		MOV AH, 0CH
		MOV AL, 15
		INT 10H

		DEC DX

		INC BX
	.ENDW

	RET
BORDER ENDP

CLICK PROC USES AX BX CX
	MOV AX, 5
	INT 33H

	.WHILE AX == 0
		MOV AX, 5
		INT 33H
	.ENDW
	
	RET
CLICK ENDP

TITLESCREEN PROC USES AX BX CX DX SI DI

	;;;;;; TAKING USERNAME INPUT ;;;;;;;

	MOV SI, 0
	MOV CX, 12
	T1:
		MOV DL, TXT[SI]
		INC SI
		MOV AH, 02H
		INT 21H
	LOOP T1

	MOV SI, OFFSET PLAYER
	CALL INPUTSTR
	
	MOV AH, 0	;SET VIDEO MODE
	MOV AL, 6	;SCREEN MODE
	INT 10H
	
	;;;;; DISPLAYING TEXT ;;;;;

	MOV AH, 02H	;SET CURSOR POSITION
	MOV BH, 0	;SET PAGE NUMBER
	MOV DH, 8	;ROW
	MOV DL, 37	;COLUMN
	INT 10H

	MOV SI, OFFSET GAME_TITLE
	MOV DI, LENGTHOF GAME_TITLE
	CALL DISPLAY

	MOV AH, 02H	;SET CURSOR POSITION
	MOV BH, 0	;SET PAGE NUMBER
	MOV DH, 15	;ROW
	MOV DL, 37	;COLUMN
	INT 10H

	MOV SI, OFFSET PLAYER
	MOV DI, LENGTHOF PLAYER
	CALL DISPLAY
	
	;;;;;; DRAWING A BOX ;;;;;;;;

	MOV CX, 245	;X-COORDINATE FOR RECTANGLE
	MOV DX, 55	;Y-COORDINATE FOR RECTANGLE
	
	MOV SI, 150
	MOV DI, 20
	CALL BORDER

	MOV CX, 275	;X-COORDINATE FOR RECTANGLE
	MOV DX, 110	;Y-COORDINATE FOR RECTANGLE
	
	MOV SI, 80
	MOV DI, 20
	CALL BORDER
	
	RET
TITLESCREEN ENDP

HOWTOPLAY PROC USES AX BX CX DX SI DI
	;;;;;; SET VIDEO MODE ;;;;;;;
	
	MOV AH, 0	;SET VIDEO MODE
	MOV AL, 6	;SCREEN MODE
	INT 10H
	
	;;;;; DISPLAYING TEXT ;;;;;

	MOV AH, 02H	;SET CURSOR POSITION
	MOV BH, 0	;SET PAGE NUMBER
	MOV DH, 2	;ROW
	MOV DL, 30	;COLUMN
	INT 10H

	MOV SI, OFFSET HOWTO
	;ADD SI, 20
	MOV DI, LENGTHOF HOWTO
	CALL DISPLAY
	
	;;;;;; DRAWING A BOX ;;;;;;;;

	MOV CX, 40	;X-COORDINATE FOR RECTANGLE
	MOV DX, 20	;Y-COORDINATE FOR RECTANGLE
	
	MOV SI, 550
	MOV DI, 150
	CALL BORDER
	
	RET
HOWTOPLAY ENDP

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

INPUT PROC USES AX BX CX DX SI

	MOV AX, 1
	INT 33h

	;;;;;;; GET COORDINATES ;;;;;;
	MOV AX, 5
	INT 33H

	.WHILE AX == 0
		MOV AX, 3
		INT 33H
		MOV X, CX
		MOV Y, DX
	
		MOV AX, 5
		INT 33H
	.ENDW		
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	;;;;;; 1ST ROW ;;;;;;;;
	.IF Y >= 30 && Y <= 50
		.IF X >= 180 && X <= 220  
			MOV SI, OFFSET CELL
			MOV [SI+5], BYTE PTR 49
			MOV [SI+7], BYTE PTR '1'
			MOV CX, LENGTHOF CELL
			CALL PRINTSTR
			
			MOV AX, 1			
			CALL SELECTED
		.ELSEIF X >= 220 && X <= 260  
			MOV SI, OFFSET CELL
			MOV [SI+5], BYTE PTR '1'
			MOV [SI+7], BYTE PTR '2'
			MOV CX, LENGTHOF CELL
			CALL PRINTSTR
			
			MOV AX, 2			
			CALL SELECTED
		.ELSEIF X >= 260 && X <= 300  
			MOV SI, OFFSET CELL
			MOV [SI+5], BYTE PTR '1'
			MOV [SI+7], BYTE PTR '3'
			MOV CX, LENGTHOF CELL
			CALL PRINTSTR
			
			MOV AX, 3			
			CALL SELECTED
		.ELSEIF X >= 300 && X <= 340  
			MOV SI, OFFSET CELL
			MOV [SI+5], BYTE PTR '1'
			MOV [SI+7], BYTE PTR '4'
			MOV CX, LENGTHOF CELL
			CALL PRINTSTR
			
			MOV AX, 4		
			CALL SELECTED
		.ELSEIF X >= 340 && X <= 380  
			MOV SI, OFFSET CELL
			MOV [SI+5], BYTE PTR '1'
			MOV [SI+7], BYTE PTR '5'
			MOV CX, LENGTHOF CELL
			CALL PRINTSTR
			
			MOV AX, 5			
			CALL SELECTED
		.ELSEIF X >= 380 && X <= 420  
			MOV SI, OFFSET CELL
			MOV [SI+5], BYTE PTR '1'
			MOV [SI+7], BYTE PTR '6'
			MOV CX, LENGTHOF CELL
			CALL PRINTSTR
			
			MOV AX, 6			
			CALL SELECTED
		.ELSEIF X >= 420 && X <= 460  
			MOV SI, OFFSET CELL
			MOV [SI+5], BYTE PTR '1'
			MOV [SI+7], BYTE PTR '7'
			MOV CX, LENGTHOF CELL
			CALL PRINTSTR	

			MOV AX, 7			
			CALL SELECTED
		.ENDIF
	;;;;;; 2ND ROW ;;;;;;;;
	.ELSEIF Y >= 50 && Y <= 70
		.IF X >= 180 && X <= 220  
			MOV SI, OFFSET CELL
			MOV [SI+5], BYTE PTR 50
			MOV [SI+7], BYTE PTR '1'
			MOV CX, LENGTHOF CELL
			CALL PRINTSTR
			
			MOV AX, 8			
			CALL SELECTED
		.ELSEIF X >= 220 && X <= 260  
			MOV SI, OFFSET CELL
			MOV [SI+5], BYTE PTR '2'
			MOV [SI+7], BYTE PTR '2'
			MOV CX, LENGTHOF CELL
			CALL PRINTSTR
			
			MOV AX, 9			
			CALL SELECTED
		.ELSEIF X >= 260 && X <= 300  
			MOV SI, OFFSET CELL
			MOV [SI+5], BYTE PTR '2'
			MOV [SI+7], BYTE PTR '3'
			MOV CX, LENGTHOF CELL
			CALL PRINTSTR
			
			MOV AX, 10			
			CALL SELECTED
		.ELSEIF X >= 300 && X <= 340  
			MOV SI, OFFSET CELL
			MOV [SI+5], BYTE PTR '2'
			MOV [SI+7], BYTE PTR '4'
			MOV CX, LENGTHOF CELL
			CALL PRINTSTR
			
			MOV AX, 11			
			CALL SELECTED
		.ELSEIF X >= 340 && X <= 380  
			MOV SI, OFFSET CELL
			MOV [SI+5], BYTE PTR '2'
			MOV [SI+7], BYTE PTR '5'
			MOV CX, LENGTHOF CELL
			CALL PRINTSTR
			
			MOV AX, 12			
			CALL SELECTED
		.ELSEIF X >= 380 && X <= 420  
			MOV SI, OFFSET CELL
			MOV [SI+5], BYTE PTR '2'
			MOV [SI+7], BYTE PTR '6'
			MOV CX, LENGTHOF CELL
			CALL PRINTSTR
			
			MOV AX, 13			
			CALL SELECTED
		.ELSEIF X >= 420 && X <= 460  
			MOV SI, OFFSET CELL
			MOV [SI+5], BYTE PTR '2'
			MOV [SI+7], BYTE PTR '7'
			MOV CX, LENGTHOF CELL
			CALL PRINTSTR	

			MOV AX, 14			
			CALL SELECTED			
		.ENDIF
	;;;;;; 3RD ROW ;;;;;;;;	
	.ELSEIF Y >= 70 && Y <= 90
		.IF X >= 180 && X <= 220  
			MOV SI, OFFSET CELL
			MOV [SI+5], BYTE PTR 51
			MOV [SI+7], BYTE PTR '1'
			MOV CX, LENGTHOF CELL
			CALL PRINTSTR
			
			MOV AX, 15			
			CALL SELECTED	
		.ELSEIF X >= 220 && X <= 260  
			MOV SI, OFFSET CELL
			MOV [SI+5], BYTE PTR '3'
			MOV [SI+7], BYTE PTR '2'
			MOV CX, LENGTHOF CELL
			CALL PRINTSTR
			
			MOV AX, 16			
			CALL SELECTED	
		.ELSEIF X >= 260 && X <= 300  
			MOV SI, OFFSET CELL
			MOV [SI+5], BYTE PTR '3'
			MOV [SI+7], BYTE PTR '3'
			MOV CX, LENGTHOF CELL
			CALL PRINTSTR
			
			MOV AX, 17			
			CALL SELECTED	
		.ELSEIF X >= 300 && X <= 340  
			MOV SI, OFFSET CELL
			MOV [SI+5], BYTE PTR '3'
			MOV [SI+7], BYTE PTR '4'
			MOV CX, LENGTHOF CELL
			CALL PRINTSTR
			
			MOV AX, 18			
			CALL SELECTED	
		.ELSEIF X >= 340 && X <= 380  
			MOV SI, OFFSET CELL
			MOV [SI+5], BYTE PTR '3'
			MOV [SI+7], BYTE PTR '5'
			MOV CX, LENGTHOF CELL
			CALL PRINTSTR
			
			MOV AX, 19			
			CALL SELECTED	
		.ELSEIF X >= 380 && X <= 420  
			MOV SI, OFFSET CELL
			MOV [SI+5], BYTE PTR '3'
			MOV [SI+7], BYTE PTR '6'
			MOV CX, LENGTHOF CELL
			CALL PRINTSTR
			
			MOV AX, 20			
			CALL SELECTED	
		.ELSEIF X >= 420 && X <= 460  
			MOV SI, OFFSET CELL
			MOV [SI+5], BYTE PTR '3'
			MOV [SI+7], BYTE PTR '7'
			MOV CX, LENGTHOF CELL
			CALL PRINTSTR		

			MOV AX, 21			
			CALL SELECTED	
		.ENDIF
	;;;;;; 4TH ROW ;;;;;;;;	
	.ELSEIF Y >= 90 && Y <= 110
		.IF X >= 180 && X <= 220  
			MOV SI, OFFSET CELL
			MOV [SI+5], BYTE PTR 52
			MOV [SI+7], BYTE PTR '1'
			MOV CX, LENGTHOF CELL
			CALL PRINTSTR
			
			MOV AX, 22			
			CALL SELECTED	
		.ELSEIF X >= 220 && X <= 260  
			MOV SI, OFFSET CELL
			MOV [SI+5], BYTE PTR '4'
			MOV [SI+7], BYTE PTR '2'
			MOV CX, LENGTHOF CELL
			CALL PRINTSTR
			
			MOV AX, 23	
			CALL SELECTED
		.ELSEIF X >= 260 && X <= 300  
			MOV SI, OFFSET CELL
			MOV [SI+5], BYTE PTR '4'
			MOV [SI+7], BYTE PTR '3'
			MOV CX, LENGTHOF CELL
			CALL PRINTSTR
			
			MOV AX, 24
			CALL SELECTED
		.ELSEIF X >= 300 && X <= 340  
			MOV SI, OFFSET CELL
			MOV [SI+5], BYTE PTR '4'
			MOV [SI+7], BYTE PTR '4'
			MOV CX, LENGTHOF CELL
			CALL PRINTSTR
			
			MOV AX, 25
			CALL SELECTED
		.ELSEIF X >= 340 && X <= 380  
			MOV SI, OFFSET CELL
			MOV [SI+5], BYTE PTR '4'
			MOV [SI+7], BYTE PTR '5'
			MOV CX, LENGTHOF CELL
			CALL PRINTSTR
			
			MOV AX, 26		
			CALL SELECTED
		.ELSEIF X >= 380 && X <= 420  
			MOV SI, OFFSET CELL
			MOV [SI+5], BYTE PTR '4'
			MOV [SI+7], BYTE PTR '6'
			MOV CX, LENGTHOF CELL
			CALL PRINTSTR
			
			MOV AX, 27		
			CALL SELECTED
		.ELSEIF X >= 420 && X <= 460  
			MOV SI, OFFSET CELL
			MOV [SI+5], BYTE PTR '4'
			MOV [SI+7], BYTE PTR '7'
			MOV CX, LENGTHOF CELL
			CALL PRINTSTR

			MOV AX, 28		
			CALL SELECTED
		.ENDIF
	;;;;;; 5TH ROW ;;;;;;;
	.ELSEIF Y >= 110 && Y <= 130
		.IF X >= 180 && X <= 220  
			MOV SI, OFFSET CELL
			MOV [SI+5], BYTE PTR 53
			MOV [SI+7], BYTE PTR '1'
			MOV CX, LENGTHOF CELL
			CALL PRINTSTR
			
			MOV AX, 29
			CALL SELECTED
		.ELSEIF X >= 220 && X <= 260  
			MOV SI, OFFSET CELL
			MOV [SI+5], BYTE PTR '5'
			MOV [SI+7], BYTE PTR '2'
			MOV CX, LENGTHOF CELL
			CALL PRINTSTR
			
			MOV AX, 30		
			CALL SELECTED
		.ELSEIF X >= 260 && X <= 300  
			MOV SI, OFFSET CELL
			MOV [SI+5], BYTE PTR '5'
			MOV [SI+7], BYTE PTR '3'
			MOV CX, LENGTHOF CELL
			CALL PRINTSTR
			
			MOV AX, 31	
			CALL SELECTED
		.ELSEIF X >= 300 && X <= 340  
			MOV SI, OFFSET CELL
			MOV [SI+5], BYTE PTR '5'
			MOV [SI+7], BYTE PTR '4'
			MOV CX, LENGTHOF CELL
			CALL PRINTSTR
			
			MOV AX, 32	
			CALL SELECTED
		.ELSEIF X >= 340 && X <= 380  
			MOV SI, OFFSET CELL
			MOV [SI+5], BYTE PTR '5'
			MOV [SI+7], BYTE PTR '5'
			MOV CX, LENGTHOF CELL
			CALL PRINTSTR
			
			MOV AX, 33	
			CALL SELECTED
		.ELSEIF X >= 380 && X <= 420  
			MOV SI, OFFSET CELL
			MOV [SI+5], BYTE PTR '5'
			MOV [SI+7], BYTE PTR '6'
			MOV CX, LENGTHOF CELL
			CALL PRINTSTR
			
			MOV AX, 34	
			CALL SELECTED
		.ELSEIF X >= 420 && X <= 460  
			MOV SI, OFFSET CELL
			MOV [SI+5], BYTE PTR '5'
			MOV [SI+7], BYTE PTR '7'
			MOV CX, LENGTHOF CELL
			CALL PRINTSTR			
			
			MOV AX, 35
			CALL SELECTED
		.ENDIF
	;;;;;; 6TH ROW ;;;;;;;
	.ELSEIF Y >= 130 && Y <= 150
		.IF X >= 180 && X <= 220  
			MOV SI, OFFSET CELL
			MOV [SI+5], BYTE PTR 54
			MOV [SI+7], BYTE PTR '1'
			MOV CX, LENGTHOF CELL
			CALL PRINTSTR
			
			MOV AX, 36
			CALL SELECTED
		.ELSEIF X >= 220 && X <= 260  
			MOV SI, OFFSET CELL
			MOV [SI+5], BYTE PTR '6'
			MOV [SI+7], BYTE PTR '2'
			MOV CX, LENGTHOF CELL
			CALL PRINTSTR
			
			MOV AX, 37
			CALL SELECTED
		.ELSEIF X >= 260 && X <= 300  
			MOV SI, OFFSET CELL
			MOV [SI+5], BYTE PTR '6'
			MOV [SI+7], BYTE PTR '3'
			MOV CX, LENGTHOF CELL
			CALL PRINTSTR
			
			MOV AX, 38
			CALL SELECTED
		.ELSEIF X >= 300 && X <= 340  
			MOV SI, OFFSET CELL
			MOV [SI+5], BYTE PTR '6'
			MOV [SI+7], BYTE PTR '4'
			MOV CX, LENGTHOF CELL
			CALL PRINTSTR
			
			MOV AX, 39
			CALL SELECTED
		.ELSEIF X >= 340 && X <= 380  
			MOV SI, OFFSET CELL
			MOV [SI+5], BYTE PTR '6'
			MOV [SI+7], BYTE PTR '5'
			MOV CX, LENGTHOF CELL
			CALL PRINTSTR
			
			MOV AX, 40
			CALL SELECTED
		.ELSEIF X >= 380 && X <= 420  
			MOV SI, OFFSET CELL
			MOV [SI+5], BYTE PTR '6'
			MOV [SI+7], BYTE PTR '6'
			MOV CX, LENGTHOF CELL
			CALL PRINTSTR
			
			MOV AX, 41
			CALL SELECTED
		.ELSEIF X >= 420 && X <= 460  
			MOV SI, OFFSET CELL
			MOV [SI+5], BYTE PTR '6'
			MOV [SI+7], BYTE PTR '7'
			MOV CX, LENGTHOF CELL
			CALL PRINTSTR		

			MOV AX, 42
			CALL SELECTED
		.ENDIF
	;;;;;; 7TH ROW ;;;;;;;
	.ELSEIF Y >= 150 && Y <= 170
		.IF X >= 180 && X <= 220  
			MOV SI, OFFSET CELL
			MOV [SI+5], BYTE PTR 55
			MOV [SI+7], BYTE PTR '1'
			MOV CX, LENGTHOF CELL
			CALL PRINTSTR
			
			MOV AX, 43
			CALL SELECTED
		.ELSEIF X >= 220 && X <= 260  
			MOV SI, OFFSET CELL
			MOV [SI+5], BYTE PTR '7'
			MOV [SI+7], BYTE PTR '2'
			MOV CX, LENGTHOF CELL
			CALL PRINTSTR
			
			MOV AX, 44
			CALL SELECTED
		.ELSEIF X >= 260 && X <= 300  
			MOV SI, OFFSET CELL
			MOV [SI+5], BYTE PTR '7'
			MOV [SI+7], BYTE PTR '3'
			MOV CX, LENGTHOF CELL
			CALL PRINTSTR
			
			MOV AX, 45
			CALL SELECTED
		.ELSEIF X >= 300 && X <= 340  
			MOV SI, OFFSET CELL
			MOV [SI+5], BYTE PTR '7'
			MOV [SI+7], BYTE PTR '4'
			MOV CX, LENGTHOF CELL
			CALL PRINTSTR
			
			MOV AX, 46
			CALL SELECTED
		.ELSEIF X >= 340 && X <= 380  
			MOV SI, OFFSET CELL
			MOV [SI+5], BYTE PTR '7'
			MOV [SI+7], BYTE PTR '5'
			MOV CX, LENGTHOF CELL
			CALL PRINTSTR
			
			MOV AX, 47
			CALL SELECTED
		.ELSEIF X >= 380 && X <= 420  
			MOV SI, OFFSET CELL
			MOV [SI+5], BYTE PTR '7'
			MOV [SI+7], BYTE PTR '6'
			MOV CX, LENGTHOF CELL
			CALL PRINTSTR
			
			MOV AX, 48
			CALL SELECTED
		.ELSEIF X >= 420 && X <= 460  
			MOV SI, OFFSET CELL
			MOV [SI+5], BYTE PTR '7'
			MOV [SI+7], BYTE PTR '7'
			MOV CX, LENGTHOF CELL
			CALL PRINTSTR			
			
			MOV AX, 49
			CALL SELECTED
		.ENDIF
	
	.ELSE
		MOV SI, OFFSET OUTOFBOUNDS
		MOV CX, LENGTHOF OUTOFBOUNDS
		CALL PRINTSTR
	.ENDIF
		
	;;;;;; PRINT COORDINATES ;;;;;
	
	MOV DL, 10
	MOV AH, 02H
	INT 21H

	MOV SI, OFFSET STR2
	MOV CX, LENGTHOF STR2
	;CALL PRINTSTR

	MOV SI, OFFSET X
	;CALL PRINT

	;MOV DL, 10
	;MOV AH, 02H
	;INT 21H

	MOV SI, OFFSET STR3
	MOV CX, LENGTHOF STR3
	;CALL PRINTSTR

	MOV SI, OFFSET Y
	;CALL PRINT

	MOV DL, 10
	MOV AH, 02H
	INT 21H
	
	RET
INPUT ENDP

PRINT PROC USES AX BX CX DX

	MOV AX, [SI]
	MOV BL, 10
	L1:
		CMP AL, 0
		JE L2
		
		DIV BL
		MOV CL, AH
		MOV CH, 0
		PUSH CX
		INC CTR
		MOV AH, 0
		JMP L1
			
	L2:
		CMP CTR, 0
		JE PRINTEXIT
		POP DX
		ADD DX, 48
		MOV AH, 2
		INT 21H
		DEC CTR
		JMP L2
		
	PRINTEXIT:	
		MOV CTR, 0
	RET
PRINT ENDP

PRINTSTR PROC USES AX BX CX DX				
	L1:
		MOV AX, [SI]				
		MOV DX, AX
		MOV AH, 02H
		INT 21H
		INC SI
	LOOP L1
		
	PRINTSTREXIT:									
	RET
PRINTSTR ENDP

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
			.IF AL == 0
				;NO SHAPE
			.ELSEIF AL == 1
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
	
MAKEGRID PROC ;USES AX CX DX
	;SET VIDEO OUTPUT MODE
	MOV AH, 0
	MOV AL, 14
	INT 10H
	
	;SET BACKGROUND COLOR
	MOV AH, 0BH
	MOV BH, 00H
	MOV BL, 0 ;COLOR
	INT 10H

	MOV CX, 180
	MOV DX, 30
	CALL GRID

	MOV CX, 186
	MOV DX, 33
	CALL SHAPES
	
	MOV AX, 0
	MOV CX, 0
	MOV DX, 0	
	
	RET
MAKEGRID ENDP

END