;***********************************************************
;*
;*	Enter Name of file here
;*
;*	Enter the description of the program here
;*
;*	This is the TRANSMIT skeleton file for Lab 8 of ECE 375
;*
;***********************************************************
;*
;*	 Author: James Stallkamp & Mohd Abdulla
;*	   Date: Enter Date
;*
;***********************************************************

.include "m128def.inc"			; Include definition file

;***********************************************************
;*	Internal Register Definitions and Constants
;***********************************************************
.def	mpr = r16				; Multi-Purpose Register
.def 	waitCount = r17			; wait loop
.def 	innerLoopCounter = r18
.def 	outerLoopCounter = r19

.equ 	waitTime = 100
.equ 	rightWhisker = 0		;right input bit
.equ	leftWhisker = 1			;left input bit
.equ	EngEnR = 4				; Right Engine Enable Bit
.equ	EngEnL = 7				; Left Engine Enable Bit
.equ	EngDirR = 5				; Right Engine Direction Bit
.equ	EngDirL = 6				; Left Engine Direction Bit
; Use these action codes between the remote and robot

.equ BotId = 0b101111			; 47 
; MSB = 1 thus:
; control signals are shifted right by one and ORed with 0b10000000 = $80
.equ	MovFwd =  ($80|1<<(EngDirR-1)|1<<(EngDirL-1))	;0b10110000 Move Forward Action Code
.equ	MovBck =  ($80|$00)								;0b10000000 Move Backward Action Code
.equ	TurnR =   ($80|1<<(EngDirL-1))					;0b10100000 Turn Right Action Code
.equ	TurnL =   ($80|1<<(EngDirR-1))					;0b10010000 Turn Left Action Code
.equ	Halt =    ($80|1<<(EngEnR-1)|1<<(EngEnL-1))		;0b11001000 Halt Action Code

;***********************************************************
;*	Start of Code Segment
;***********************************************************
.cseg							; Beginning of code segment

;***********************************************************
;*	Interrupt Vectors
;***********************************************************
.org	$0000					; Beginning of IVs
		rjmp 	INIT			; Reset interrupt

.org	$0046					; End of Interrupt Vectors

;***********************************************************
;*	Program Initialization
;***********************************************************
INIT:
	;Stack Pointer (VERY IMPORTANT!!!!)
	ldi     mpr, high(RAMEND)
    out     SPH, mpr
    ldi     mpr, low(RAMEND)
    out     SPL, mpr
	
	;I/O Ports
	; Set Port D pin 3 (TXD1) for output
    ldi mpr, (1<<PD3)
    out DDRD, mpr

	;USART1 Set baudrate at 2400bps Enable transmitter Set frame format: 8 data bits, 2 stop bits
	; Initialize USART1
    ldi     mpr, (1<<U2X1) ; Set double data rate
    sts     UCSR1A, mpr

    ; Set baud rate at 2400bps (taking into account double data rate)
    ldi     mpr, high(832) ; Load high byte of 0x0340
    sts     UBRR1H, mpr ; UBRR1H in extended I/O space
    ldi     mpr, low(832) ; Load low byte of 0x0340
    sts     UBRR1L, mpr

    ; Set frame format: 8 data, 2 stop bits
    ldi     mpr, (0<<UMSEL1 | 1<<USBS1 | 1<<UCSZ11 | 1<<UCSZ10)
    sts     UCSR1C, mpr ; UCSR0C in extended I/O space

    ; Enable transmitter
    ldi     mpr, (1<<TXEN1)
    sts     UCSR1B, mpr
	;Other

;***********************************************************
;*	Main Program
;***********************************************************
MAIN:
	;TODO: ???
		rcall forward
		rcall wait
		rcall wait
		rcall turnRight
		rcall wait
		
		rjmp	MAIN

;***********************************************************
;*	Functions and Subroutines
;***********************************************************
foward:
        ldi     mpr, BotID
        sts     UDR1, mpr
        ldi     mpr, MovFwd
        sts     UDR1, mpr
        ret

back:
        ldi     mpr, BotID
        sts     UDR1, mpr
        ldi     mpr, MovBck
        sts     UDR1, mpr
        ret

turnRight:
        ldi     mpr, BotID
        sts     UDR1, mpr
        ldi     mpr, TurnR
        sts     UDR1, mpr
        ret

turnLeft:
        ldi     mpr, BotID
        sts     UDR1, mpr
        ldi     mpr, TurnL
        sts     UDR1, mpr
        ret

halt:
        ldi     mpr, BotID
        sts     UDR1, mpr
        ldi     mpr, Halt
        sts     UDR1, mpr
        ret
		
;-----------------------------------------------------------
;Funtion: Wait
;Desc: A wait loop that is 16 + 159975*waitcnt cycles 
;-----------------------------------------------------------
wait:
        ldi     waitCount, waitTime  ; Wait for 1 second

        push    waitCount         			; Save wait register
        push    innerLoopCounter           ; Save outerLoopCounter register
        push    outerLoopCounter           ; Save innerLoopCounter register

Loop:   ldi     outerLoopCounter, 224      		; load outerLoopCounter register
outerLoop:  ldi     innerLoopCounter, 237      ; load innerLoopCounter register
innerLoop:  dec     innerLoopCounter           ; decrement innerLoopCounter
        brne    innerLoop           ; Continue Inner Loop
        dec     outerLoopCounter    ; decrement outerLoopCounter
        brne    outerLoop           ; Continue Outer Loop
        dec     waitCount     		; Decrement wait 
        brne    Loop            	; Continue Wait loop    

        pop     outerLoopCounter    ; Restore outerLoopCounter register
        pop     innerLoopCounter	; Restore innerLoopCounter register
        pop     waitCount     		; Restore waitCount register
        ret             			; Return from subroutine
;***********************************************************
;*	Stored Program Data
;***********************************************************

;***********************************************************
;*	Additional Program Includes
;***********************************************************