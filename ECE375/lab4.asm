;***********************************************************
;*
;*	LCD Writer
;*
;*	This program will take text and write it to the LCD on the Mega128 board
;*
;*	This was based off the skeleton file for Lab 3 of ECE 375
;*
;***********************************************************
;*
;*	 Author: James Stallkamp
;*	   Date: 2/7/2017
;*
;***********************************************************
 
.include "m128def.inc"			; Include definition file
 
;***********************************************************
;*	Internal Register Definitions and Constants
;***********************************************************
.def	mpr = r16				; Multipurpose register required for LCD Driver
.equ 	topLine = $0100        
.equ	botLine = $0110        
 
 
;***********************************************************
;*	Start of Code Segment
;***********************************************************
.cseg							; Beginning of code segment
 
;-----------------------------------------------------------
; Interrupt Vectors
;-----------------------------------------------------------
.org	$0000					; Beginning of IVs
		rjmp INIT				; Reset interrupt
 
.org	$0046					; End of Interrupt Vectors
 
;-----------------------------------------------------------
; Program Initialization
;-----------------------------------------------------------
INIT:							; The initialization routine
		; Initialize Stack Pointer
		ldi mpr,	low(RAMEND)
		out SPL,	mpr						; Init the 2 stack pointer registers
		ldi mpr,	high(RAMEND)
		out SPH,	mpr
 
		; Initialize LCD Display
		rcall LCDInit			
 
		; Move strings from Program Memory to Data Memory
 
		ldi ZL,		low(stringBeg<<1)     ; Point Z to the first line of text
		ldi ZH,		high(stringBeg<<1)
		ldi YL,		low(topLine)	       ; Point Y to memory where the LCD will be looking
		ldi YH,		high(topLine)
		ldi XH,		high(botLine)	       ; Point X to memory where the LCD will be looking
		ldi XL,		low(botLine)
 
LINE1:
		LPM mpr,	Z+                     ; Load next character
		ST Y+,		mpr
 
		CPI ZL,		low(stringEnd<<1)     ; Repeat if Z not at line end
		BRNE 		LINE1
 
		CPI ZH,		high(stringEnd<<1)
		BRNE 		LINE1
 
LINE2INIT:
		ldi ZL,		low(string2Beg<<1)            ; Point Z register to Line 2
		ldi ZH,		high(string2Beg<<1)
 
LINE2:
		LPM mpr,	Z+                                ; Load next character
		ST X+,		mpr
 
		CPI ZL,		low(string3End<<1)            ; Repeat if Z not at line end
		BRNE 		LINE2
 
		CPI ZH,		high(string3End<<1)
		BRNE 		LINE2
 
		
 
;-----------------------------------------------------------
; Main Program
;-----------------------------------------------------------
MAIN:							; The Main program
		; Display the strings on the LCD Display
		rcall	LCDWrite						; An RCALL statement
 
		rjmp	MAIN			; jump back to main and create an infinite
								; while loop.  Generally, every main program is an
								; infinite while loop, never let the main program
								; just run off
 
;***********************************************************
;*	Stored Program Data
;***********************************************************
 
;----------------------------------------------------------
; An example of storing a string, note the preceeding and
; appending labels, these help to access the data
;----------------------------------------------------------
stringBeg:
.DB		"James Stallkamp   "		; Storing the string in Program Memory
stringEnd:
string2Beg:
.DB		"Hello, World!   "
string3End:
 
 
 
;***********************************************************
;*	Additional Program Includes
;***********************************************************
.include "LCDDriver.asm"		; Include the LCD Driver