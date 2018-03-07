.DEF COUNTER = R25	; define Register 25 to LED_STATE
.DEF ACC = R24


.ORG 0x00		; start of the program
RJMP MAIN		; jump to main

.ORG INT0addr		; this is called when INT0 goes low
RJMP INT_ADD	    	; jmp to interrupt handler

.ORG INT1addr		; this is called when INT1 goes low
RJMP INT_SUB		; jmp to interrupt handler

; MAIN
; -----------------
; Entry point for the program
MAIN:
	CALL INIT		; initialize variables
LOOP:
	OUT PORTB, COUNTER	; send counter to portb
	JMP LOOP		; Loop forever

; INIT
; ---------------
; Initalizes ports and sets flags
INIT:
	CBI DDRD, 2		; clear DDRD bit 2 as an input
	CBI DDRD, 3		; clear DDRD bit 3 as an input
	LDI COUNTER, 0		; initialize counter to 0
	LDI R16, 0xFF		; load register 16 to 0xFF (255)
	OUT DDRB, R16		; set DDRB as an output
	SBI EIMSK, INT0		; Enable INT0 (Interrupt Pin 0)
	SBI EIMSK, INT1 	; Enable INT1 (Interrupt Pin 1)
	LDI R16, 0x0A		; Set INT0 and INT1 pin to falling edge
	STS EICRA, R16	
	SEI			; Enable global interrupt
	RET


; INT_HANDLER
; ---------------
; Interrupt handler
; Called when INT0 goes low
INT_ADD:
	LDI ACC, 1
	ADD COUNTER, ACC
	RETI

INT_SUB:
	SUBI COUNTER, 1
	RETI
