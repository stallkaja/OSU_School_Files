;***********************************************************
;*
;*	Enter Name of file here
;*
;*	Enter the description of the program here
;*
;*	This is the RECEIVE skeleton file for Lab 8 of ECE 375
;*
;***********************************************************
;*
;*	 Author: Enter your name
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
.def 	data = r20
.def 	command = r21
.def 	accept = r22


.equ 	waitTime = 100
.equ	WskrR = 0				; Right Whisker Input Bit
.equ	WskrL = 1				; Left Whisker Input Bit
.equ	EngEnR = 4				; Right Engine Enable Bit
.equ	EngEnL = 7				; Left Engine Enable Bit
.equ	EngDirR = 5				; Right Engine Direction Bit
.equ	EngDirL = 6				; Left Engine Direction Bit

.equ	BotAddress = 0b101111			; 47

;/////////////////////////////////////////////////////////////
;These macros are the values to make the TekBot Move.
;/////////////////////////////////////////////////////////////
.equ	MovFwd =  (1<<EngDirR|1<<EngDirL)	;0b01100000 Move Forward Action Code
.equ	MovBck =  $00						;0b00000000 Move Backward Action Code
.equ	turnRight =   (1<<EngDirL)				;0b01000000 Turn Right Action Code
.equ	turnLeft =   (1<<EngDirR)				;0b00100000 Turn Left Action Code
.equ	Halt =    (1<<EngEnR|1<<EngEnL)		;0b10010000 Halt Action Code

;***********************************************************
;*	Start of Code Segment
;***********************************************************
.cseg							; Beginning of code segment

;***********************************************************
;*	Interrupt Vectors
;***********************************************************
.org    $0000                   ; Beginning of IVs
        rjmp    INIT            ; Reset interrupt
.org    $0002
        rcall   detectRight
        reti
.org    $0004
        rcall   detectLeft
        reti
.org    $003C
        rcall   USART_Receive
        reti

.org    $0046                   ; End of Interrupt Vectors


;***********************************************************
;*	Program Initialization
;***********************************************************
INIT:
	; Initialize registers
    clr     accept
    clr     command

    ; ;Stack Pointer (VERY IMPORTANT!!!!)
    ldi     mpr, high(RAMEND)
    out     SPH, mpr
    ldi     mpr, low(RAMEND)
    out     SPL, mpr

	;I/O Ports
	; Set Port D pin 2 (TXD0) for input and pins 1-0 for whisker input
    ldi mpr, (1<<PD2)|(0<<WskrR)|(0<<WskrL)
    out DDRD, mpr

    ; Set pullup resistors
    ldi mpr, (1<<PD2)|(0<<WskrR)|(0<<WskrL)
    out PORTD, mpr

    ; Initialize Port B for output
    ldi mpr, (1<<EngEnL)|(1<<EngEnR)|(1<<EngDirR)|(1<<EngDirL)
    out DDRB, mpr ; Set the DDR register for Port B
    ldi mpr, $00
    out PORTB, mpr ; Set the default output for Port B

	;USART1
	ldi     mpr, (1<<U2X1) ; Set double data rate
    sts     UCSR1A, mpr

	;Set baudrate at 2400bps
	ldi     mpr, high(832) ; Load high byte of 0x0340
    sts     UBRR1H, mpr ; UBRR1H in extended I/O space
    ldi     mpr, low(832) ; Load low byte of 0x0340
    sts     UBRR1L, mpr

	;Enable receiver and enable receive interrupts
	ldi     mpr, (1<<RXEN1 | 1<<RXCIE1)
    sts     UCSR1B, mpr
	
	;Set frame format: 8 data bits, 2 stop bits
	ldi     mpr, (0<<UMSEL1 | 1<<USBS1 | 1<<UCSZ11 | 1<<UCSZ10)
    sts     UCSR1C, mpr ; UCSR0C in extended I/O space

	; Initialize external interrupts
    ldi mpr, (0<<ISC21)|(0<<ISC20)|(0<<ISC11)|(0<<ISC10)|(0<<ISC01)|(0<<ISC00) ; Set the Interrupt Sense Control to level low
    sts EICRA, mpr ; Use sts, EICRA in extended I/O space
    ldi mpr, (1<<INT2)|(1<<INT1)|(1<<INT0) ; Set the External Interrupt Mask
    out EIMSK, mpr
    
	
    sei ; Turn on interrupts

	;Other

;***********************************************************
;*	Main Program
;***********************************************************
MAIN:
	;TODO: ???
		rjmp	MAIN

;***********************************************************
;*	Functions and Subroutines
;***********************************************************
USART_Receive:
        push    mpr

        lds     data, UDR1 ; Read data from Receive Data Buffer

        ; Check if it's an ID or a command
        ldi     mpr, 0b10000000
        and     mpr, data
        breq    ProcessID ; If the result is all zeroes, it starts with a 0 and is an ID
        rjmp    ProcessCommand; Otherwise, it's a command

ProcessID:
        cpi     data, BotID
        breq    SetAccept ; If the BotID matches, go into accept mode
        clr     accept ; If it doesn't match, make sure we're NOT in accept mode
        rjmp    USART_Receive_End

SetAccept:
        ldi     accept, 1 ; If it does match, go into accept mode
        rjmp    USART_Receive_End

ProcessCommand:
        cpi     accept, 1
        brne    USART_Receive_End ; If we aren't in accept mode, do nothing
        ; If we are in accept mode, run the command
        lsl     data ; Decode command
        out     PORTB, data  ; Send command to port
        mov     command, data ; Save what command we're running in case a whisker interrupt needs to go back to it
        clr     accept ; Leave accept mode since we just accepted

USART_Receive_End:

        pop     mpr
        ret
;----------------------------------------------------------------
; Sub:  detectRight
; Desc: Handles functionality of the TekBot when the right whisker
;       is triggered.
;----------------------------------------------------------------
detectRight:
        push    mpr         ; Save mpr register
        push    waitCount         ; Save wait register
        in      mpr, SREG   ; Save program state
        push    mpr         ;

        ; Move Backwards for a second
        ldi     mpr, MovBck ; Load Move Backwards command
        out     PORTB, mpr  ; Send command to port
        ldi     waitCount, waitTime  ; Wait for 1 second
        rcall   Wait            ; Call wait function

        ; Turn left for a second
        ldi     mpr, turnLeft  ; Load Turn Left Command
        out     PORTB, mpr  ; Send command to port
        ldi     waitCount, waitTime  ; Wait for 1 second
        rcall   Wait            ; Call wait function

        ; Resume previous command
        out     PORTB, command

        pop     mpr     ; Restore program state
        out     SREG, mpr   ;
        pop     waitCount     ; Restore wait register
        pop     mpr     ; Restore mpr
        ret             ; Return from subroutine

;----------------------------------------------------------------
; Sub:  HitLeft
; Desc: Handles functionality of the TekBot when the left whisker
;       is triggered.
;----------------------------------------------------------------
HitLeft:
        push    mpr         ; Save mpr register
        push    waitCount         ; Save wait register
        in      mpr, SREG   ; Save program state
        push    mpr         ;

        ; Move Backwards for a second
        ldi     mpr, MovBck ; Load Move Backwards command
        out     PORTB, mpr  ; Send command to port
        ldi     waitCount, waitTime  ; Wait for 1 second
        rcall   Wait            ; Call wait function

        ; Turn right for a second
        ldi     mpr, turnRight  ; Load Turn Left Command
        out     PORTB, mpr  ; Send command to port
        ldi     waitCount, waitTime  ; Wait for 1 second
        rcall   Wait            ; Call wait function

        ; Resume previous command
        out     PORTB, command

        pop     mpr     ; Restore program state
        out     SREG, mpr   ;
        pop     waitCount     ; Restore wait register
        pop     mpr     ; Restore mpr
        ret             ; Return from subroutine


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