DELAY MACRO
	DELAY PROC USES CX DX
		MOV CX, 1500
		
		L1:
			MOV DX, 1000
		L2:
			DEC DX
		CMP DX, 0
		JNE L2
		
		LOOP L1
		
		RET
	DELAY ENDP
ENDM