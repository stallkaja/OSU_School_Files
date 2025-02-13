;***********************************************************
;*
;*	Enter Name of file here
;*
;*	Enter the description of the program here
;*
;*	This is the skeleton file for Lab 5 of ECE 375
;*
;***********************************************************
;*
;*	 Author: James Stallkamp
;*	   Date:
;*
;***********************************************************

.include "m128def.inc"			; Include definition file

;***********************************************************
;*	Internal Register Definitions and Constants
;***********************************************************
.def    mpr = r16               ; Multipurpose register 
.def    rlo = r0                ; Low byte of MUL result
.def    rhi = r1                ; High byte of MUL result
.def    zero = r2               ; Zero register, set to zero in INIT, useful for calculations
.def    A = r3                  ; An operand
.def    B = r4                  ; Another operand

.def    oloop = r17             ; Outer Loop Counter
.def    iloop = r18             ; Inner Loop Counter

;.equ    addrA = $0100           ; Beginning Address of Operand A data (input to ADD16)
;.equ    addrB = $0102           ; Beginning Address of Operand B data (input to ADD16)
.equ    addrC = $011D           ; Beginning Address of Operand C data (input to MUL24)
.equ    addrD = $011D           ; Beginning Address of Operand D data (input to MUL24)
.equ    addrE = $0104          ; Beginning Address of Product Result LA
.equ    addrF = $0109          ; End Address of Product Result HA



;***********************************************************
;*	Start of Code Segment
;***********************************************************
.cseg							; Beginning of code segment

;-----------------------------------------------------------
; Interrupt Vectors
;-----------------------------------------------------------
.org	$0000					; Beginning of IVs
		rjmp 	INIT			; Reset interrupt

.org	$0046					; End of Interrupt Vectors

;-----------------------------------------------------------
; Program Initialization
;-----------------------------------------------------------
INIT:							; The initialization routine
		; Initialize Stack Pointer
		; TODO					; Init the 2 stack pointer registers
	LDI	mpr, low(RAMEND)
	OUT	SPL, mpr
	LDI	mpr, high(RAMEND)
	OUT	SPH, mpr	; Initialize Stack Pointer

	clr		zero			; Set the zero register to zero, maintain
	
								; these semantics, meaning, don't load anything
								; to it.

;-----------------------------------------------------------
; Main Program
;-----------------------------------------------------------
MAIN:							; The Main program
		; Setup the ADD16 function direct test
		rcall ADD16
		; Enter values 0xA2FF and 0xF477 into data memory
				; locations where ADD16 will get its inputs from

				; Call ADD16 function to test its correctness
				; (calculate A2FF + F477)

				; Observe result in Memory window

		; Setup the SUB16 function direct test
		rcall SUB16
				; Enter values 0xF08A and 0x4BCD into data memory
				; locations where SUB16 will get its inputs from

				; Call SUB16 function to test its correctness
				; (calculate F08A - 4BCD)

				; Observe result in Memory window

				
	rcall MUL24
				; Observe result in Memory window

		; Call the COMPOUND function
	rcall COMPOUND
				; Observe final result in Memory window

DONE:	rjmp	DONE			; Create an infinite while loop to signify the 
								; end of the program.

;***********************************************************
;*	Functions and Subroutines
;***********************************************************

;-----------------------------------------------------------
; Func: ADD16
; Desc: Adds two 16-bit numbers and generates a 24-bit number
;		where the high byte of the result contains the carry
;		out bit.
;-----------------------------------------------------------
ADD16:
; Save variable by pushing them to the stack
	push A
	push B
	push rhi
	push rlo
	push zero
	push XH
	push XL
	push YH
	push YL
	push ZH
	push ZL
	push oloop
	push iloop
		
	clr zero
		; Execute the function here
	lds r0, $0100
	lds r1, $0101
	lds r2, $0102
	lds r3, $0103

	add r0, r2
	adc r1, r3
	clr r2
	clr r3
	adc r2, r3

	sts $0100, r0
	sts $0101, r1
	sts $0102, r2
		; Restore variable by popping them from the stack in reverse order
	pop iloop
	pop oloop
	pop ZL
	pop ZH
	pop YL
	pop YH
	pop XL
	pop XH
	pop zero
	pop rlo
	pop rhi
	pop B
	pop A 
		
		
		
	ret		; End a function with RET

;-----------------------------------------------------------
; Func: SUB16
; Desc: Subtracts two 16-bit numbers and generates a 16-bit
;		result.
;-----------------------------------------------------------
SUB16:
	; Save variable by pushing them to the stack
	push A
	push B
	push rhi
	push rlo
	push zero
	push XH
	push XL
	push YH
	push YL
	push ZH
	push ZL
	push oloop
	push iloop
		
	clr zero
		

		; Execute the function here
	lds r0, $0100
	lds r1, $0101
	lds r2, $0102
	lds r3, $0103
	sub r0, r2 
	sbc r1, r3

	sts $0100, r0
	sts $0101, r1
	
		
		; Restore variable by popping them from the stack in reverse order
	pop iloop
	pop oloop
	pop ZL
	pop ZH
	pop YL
	pop YH
	pop XL
	pop XH
	pop zero
	pop rlo
	pop rhi
	pop B
	pop A 

	ret						; End a function with RET



;-----------------------------------------------------------
; Func: MUL24
; Desc: Multiplies two 24-bit numbers and generates a 48-bit 
;		result.
;-----------------------------------------------------------
MUL24:
		; Save variable by pushing them to the stack
	push A
	push B
	push rhi
	push rlo
	push zero
	push XH
	push XL
	push YH
	push YL
	push ZH
	push ZL
	push oloop
	push iloop
		
	clr zero
		; Execute the function here
	ldi YL, low(addrD)
	ldi YH, high(addrD)

	ldi ZL, low(addrE)
	ldi ZH, high(addrF)

	ldi oloop, 3

MUL24_OLOOP:
	ldi XL, low(addrC)
	ldi XH, high(addrC)


	ldi iloop, 3
MUL24_ILOOP:
	ld A, X+
	ld B,Y
	mul A,B
	ld A, Z+
	ld B, Z+
	add rlo, A
	adc rhi, B
	ld A,Z
	adc A, zero
	st Z,A
	st -Z,rhi
	st -Z,rlo
	adiw ZH:ZL, 1
	dec iloop
	brne MUL24_ILOOP
	sbiw ZH:ZL, 2
	adiw YH:YL, 1
	dec oloop
	brne MUL24_OLOOP
		
		; Restore variable by popping them from the stack in reverse order
	pop iloop
	pop oloop
	pop ZL
	pop ZH
	pop YL
	pop YH
	pop XL
	pop XH
	pop zero
	pop rlo
	pop rhi
	pop B
	pop A 
	ret						; End a function with RET

;-----------------------------------------------------------
; Func: COMPOUND
; Desc: Computes the compound expression ((D - E) + F)^2
;		by making use of SUB16, ADD16, and MUL24.
;
;		D, B, and F are declared in program memory, and must
;		be moved into data memory for use as input operands
;
;		All result bytes should be cleared before beginning.
;-----------------------------------------------------------
COMPOUND:
	push A
	push B
	push rhi
	push rlo
	push zero
	push XH
	push XL
	push YH
	push YL
	push ZH
	push ZL
	push oloop
	push iloop
		; Save variable by pushing them to the stack

		; Execute the function here
	ldi ZL, low(OperandD<<1)
	ldi ZH, high(OperandD<<1)
	lpm r0, Z+
	lpm r1, Z

	ldi ZL, low(OperandE<<1)
	ldi ZH, high(OperandE<<1)
	lpm r2, Z+
	lpm r3, Z

	sts $0100, r0
	sts $0101, r1
	sts $0102, r2
	sts $0103, r3

	rcall SUB16

	ldi ZL, low(OperandF<<1)
	ldi ZH, high(OperandF<<1)
	lpm r4, Z+
	lpm r5, Z

	
	
	rcall ADD16

	sts $0104, r0
	sts $0105, r1
	sts $0106, r2
	sts $0107, r0
	sts $0108, r1
	sts $0109, r2
	rcall MUL24

		; Restore variable by popping them from the stack in reverse order
	pop iloop
	pop oloop
	pop ZL
	pop ZH
	pop YL
	pop YH
	pop XL
	pop XH
	pop zero
	pop rlo
	pop rhi
	pop B
	pop A 
	ret							; End a function with RET

;-----------------------------------------------------------
; Func: MUL16
; Desc: An example function that multiplies two 16-bit numbers
;			A - Operand A is gathered from address $0101:$0100
;			B - Operand B is gathered from address $0103:$0102
;			Res - Result is stored in address 
;					$0107:$0106:$0105:$0104
;		You will need to make sure that Res is cleared before
;		calling this function.
;-----------------------------------------------------------
MUL16:
		push 	A				; Save A register
		push	B				; Save B register
		push	rhi				; Save rhi register
		push	rlo				; Save rlo register
		push	zero			; Save zero register
		push	XH				; Save X-ptr
		push	XL
		push	YH				; Save Y-ptr
		push	YL				
		push	ZH				; Save Z-ptr
	push	ZL
		push	oloop			; Save counters
		push	iloop				

		clr		zero			; Maintain zero semantics

		; Set Y to beginning address of B
		ldi		YL, low(addrB)	; Load low byte
		ldi		YH, high(addrB)	; Load high byte

		; Set Z to begginning address of resulting Product
		ldi		ZL, low(addrE)	; Load low byte
		ldi		ZH, high(addrF); Load high byte

		; Begin outer for loop
		ldi		oloop, 2		; Load counter
MUL16_OLOOP:
		; Set X to beginning address of A
		ldi		XL, low(addrA)	; Load low byte
		ldi		XH, high(addrA)	; Load high byte

		; Begin inner for loop
		ldi		iloop, 2		; Load counter
MUL16_ILOOP:
		ld		A, X+			; Get byte of A operand
		ld		B, Y			; Get byte of B operand
		mul		A,B				; Multiply A and B
		ld		A, Z+			; Get a result byte from memory
		ld		B, Z+			; Get the next result byte from memory
		add		rlo, A			; rlo <= rlo + A
		adc		rhi, B			; rhi <= rhi + B + carry
		ld		A, Z			; Get a third byte from the result
		adc		A, zero			; Add carry to A
		st		Z, A			; Store third byte to memory
		st		-Z, rhi			; Store second byte to memory
		st		-Z, rlo			; Store third byte to memory
		adiw	ZH:ZL, 1		; Z <= Z + 1			
		dec		iloop			; Decrement counter
		brne	MUL16_ILOOP		; Loop if iLoop != 0
		; End inner for loop
		sbiw	ZH:ZL, 1		; Z <= Z - 1
		adiw	YH:YL, 1		; Y <= Y + 1
		dec		oloop			; Decrement counter
		brne	MUL16_OLOOP		; Loop if oLoop != 0
		; End outer for loop
		 		
		pop		iloop			; Restore all registers in reverves order
		pop		oloop
		pop		ZL				
		pop		ZH
		pop		YL
		pop		YH
		pop		XL
		pop		XH
		pop		zero
		pop		rlo
		pop		rhi
		pop		B
		pop		A
		ret						; End a function with RET

;-----------------------------------------------------------
; Func: Template function header
; Desc: Cut and paste this and fill in the info at the 
;		beginning of your functions
;-----------------------------------------------------------
;FUNC:							; Begin a function with a label
		; Save variable by pushing them to the stack

		; Execute the function here
		
		; Restore variable by popping them from the stack in reverse order\
		;ret						; End a function with RET


;***********************************************************
;*	Stored Program Data
;***********************************************************
; Enter any stored data you might need here

OperandD:
	.DB	0x51, 0xFD			; test value for operand D
OperandE:
	.DB	0xFF, 0x1E			; test value for operand E
OperandF:
	.DB	0xFF, 0xFF			; test value for operand F

.dseg
.org	$0100
addrA:	.byte 2
addrB:	.byte 2
;LAddrP:	.byte 4