.386
.MODEL FLAT
.STACK 4096
 
.DATA
	CNST	DQ 	0.5
	PREV	DQ	0.0
	CURR	DQ	2.0
	EPS	DQ	?
 
.CODE
 
LN PROC
 
	FLD1
	FXCH	ST(1)
	FYL2X
	FLDL2E
	FDIVP
 
RET
LN ENDP
 
FUNC PROC
 
LNX:
	FST	ST(1)
	FADD	CNST
	CALL	LN
 
FX:
	FADD	ST, ST(1)
	FSUB	CNST
 
RET
FUNC ENDP
 
X_K1 PROC
	FINIT
 
FXCURR:
	FLD		PREV
	CALL	FUNC; f(prev) -> ST(0) prev -> ST(1)
 
FXPREV:
	FLDZ
	FLD		CURR
	CALL	FUNC; f(prev) -> ST(2) curr -> ST(1) f(curr) -> ST(0)
  
_F_SUB:
	FSUB	ST(2), ST; (f(prev) - f(curr)) -> ST(2)
 
_SUB:
	FLD		PREV
	FSUB	ST, ST(2); (prev - curr) -> ST(0)
 
_DIV:
	FDIV	ST, ST(3); (prev - curr)/(f(prev) - f(curr)) -> ST(0)
 
_MUL:
	FMUL	ST, ST(1)
 
_RES:
	FSUBR	ST, ST(2); next -> ST(0)
 
RET
X_K1 ENDP
 
ERROR PROC
 
	FINIT
	FLD		CURR
	FLD		PREV
	FSUB	ST, ST(1)
	FABS
 
RET
ERROR ENDP
 
PUBLIC _SolveByChord@12
_SolveByChord@12 PROC
 
PREP:
	FINIT
	PUSH	EBP
	MOV	EBP, ESP
	MOV	ECX, [EBP + 8]
	FLD	QWORD PTR [EBP + 12]
	FSTP	EPS
 

MAINLOOP:
	CALL	X_K1
	FLD	CURR
  FSTP	PREV
	FST	CURR
 
	INC	DWORD PTR [ECX]
 
	CALL	ERROR
	FCOM	EPS
	FSTSW	AX
	SAHF
	JNC		MAINLOOP
 
	FLD	CURR
	POP	EBP
 
RET 12
_SolveByChord@12 ENDP
 
END
