;***********************************************************
;*
;*	Lab4
;*
;*	LCD manipulation lab
;*
;*	This is the skeleton file for Lab 4 of ECE 375
;*
;***********************************************************
;*
;*	 Author: James Stallkamp
;*	   Date: 1/3/19
;*
;***********************************************************

.include "m128def.inc"			; Include definition file

;***********************************************************
;*	Internal Register Definitions and Constants
;***********************************************************
.def	mpr = r16				; Multipurpose register is
								; required for LCD Driver
.equ top = $0100
.equ bottom = $0110

;***********************************************************
;*	Start of Code Segment
;***********************************************************
.cseg							; Beginning of code segment

;***********************************************************
;*	Interrupt Vectors
;***********************************************************
.org	$0000					; Beginning of IVs
		rjmp INIT				; Reset interrupt

.org	$0046					; End of Interrupt Vectors

;***********************************************************
;*	Program Initialization
;***********************************************************
INIT:							; The initialization routine
		; Initialize Stack Pointer
		ldi mpr, low(RAMEND)
		out spl, mpr
		ldi mpr, high(RAMEND)
		out sph, mpr
		; Initialize LCD Display
		rcall LCDInit
		; Top Line Load
		ldi zl, low(STRING_BEG<<1)
		ldi zh, high(STRING_BEG<<1)

		ldi yl, low(top)
		ldi yh, high(top)


topLineLoop:
		lpm mpr, z+
		st y+, mpr
		cpi zl, low(STRING_END<<1)
		brne topLineLoop

		cpi zh, high(STRING_END<<1)
		brne topLineLoop

botLineLoad:
		ldi zl, low(STRING2_BEG<<1)
		ldi zh, high(STRING2_BEG<<1)

		ldi xl, low(bottom)
		ldi xh, high(bottom)
botLineLoop:
		lpm mpr, z+
		st x+, mpr

		cpi zl, low(STRING2_END<<1)
		brne botLineLoop
		
		cpi zh, high(STRING2_END<<1)
		brne botLineLoop

		; NOTE that there is no RET or RJMP from INIT, this
		; is because the next instruction executed is the
		; first instruction of the main program

;***********************************************************
;*	Main Program
;***********************************************************
MAIN:							; The Main program
		; Display the strings on the LCD Display
		rcall LCDWrite
		rjmp	MAIN			; jump back to main and create an infinite
								; while loop.  Generally, every main program is an
								; infinite while loop, never let the main program
								; just run off
;***********************************************************
;*	Stored Program Data
;***********************************************************

;-----------------------------------------------------------
; An example of storing a string. Note the labels before and
; after the .DB directive; these can help to access the data
;-----------------------------------------------------------
STRING_BEG:
.DB		"Hello World!"		; Declaring data in ProgMem
STRING_END:
STRING2_BEG:
.DB		"James Stallkamp "
STRING2_END:

;***********************************************************
;*	Additional Program Includes
;***********************************************************
.include "LCDDriver.asm"		; Include the LCD Driver
