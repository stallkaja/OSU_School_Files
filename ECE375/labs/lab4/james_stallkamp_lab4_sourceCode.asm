;***********************************************************
;*
;*	lab4
;*
;*	LCD manipulation
;*
;*	This is the skeleton file for Lab 4 of ECE 375
;*
;***********************************************************
;*
;*	 Author: James Stallkamp	
;*	   Date: 10/11/1993
;*
;***********************************************************

.include "m128def.inc"			; Include definition file
.equ top = $0100 ;top line
.equ bottom = $0110 ;bottom line
;***********************************************************
;*	Internal Register Definitions and Constants
;***********************************************************
.def	mpr = r16				; Multipurpose register is
								; required for LCD Driver

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
		; Move strings from Program Memory to Data Memory
		
		ldi zl, low(STRING_BEG<<1)
		ldi zh, high(STRING_BEG<<1)
		ldi xl, low(top)
		ldi xh, high(top)

LINE1:		
		LPM mpr, z+
		st x+, mpr

		cpi zl, low(STRING_END<<1)
		brne LINE1

		cpi zh, high(STRING_END<<1)
		brne LINE1

LINE2INIT:
		ldi zl, low(STRING2_BEG<<1)
		ldi zh, high(STRING2_BEG<<1)

LINE2:
		LPM mpr, z+
		st x+, mpr

		cpi zl, low(STRING2_END<<1)
		brne LINE2

		cpi zh, high(STRING2_END<<1)
		brne LINE2
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
;*	Functions and Subroutines
;***********************************************************

;-----------------------------------------------------------
; Func: Template function header
; Desc: Cut and paste this and fill in the info at the 
;		beginning of your functions
;-----------------------------------------------------------
FUNC:							; Begin a function with a label
		; Save variables by pushing them to the stack

		; Execute the function here
		
		; Restore variables by popping them from the stack,
		; in reverse order

		ret						; End a function with RET

;***********************************************************
;*	Stored Program Data
;***********************************************************

;-----------------------------------------------------------
; An example of storing a string. Note the labels before and
; after the .DB directive; these can help to access the data
;-----------------------------------------------------------
STRING_BEG:
.DB		"James Stallkamp   "		; Declaring data in ProgMem

STRING_END:

STRING2_BEG:
.DB		"Hello, World!   "

STRING2_END:
;STRING_BEG:
;.DB		"James Stallkamp"		; Declaring data in ProgMem
;
;STRING_END:
;
;STRING2_BEG:
;.DB		"Hello World"
;
;STRING2_END:
;***********************************************************
;*	Additional Program Includes
;***********************************************************
.include "LCDDriver.asm"		; Include the LCD Driver
