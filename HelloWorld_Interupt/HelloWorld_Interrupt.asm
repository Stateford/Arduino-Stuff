.DEF LED_STATE = R25	; define Register 25 to LED_STATE

.ORG 0x00		; start of the program
RJMP MAIN		; jump to main

.ORG INT0addr		; this is called when INT0 goes
RJMP INT_HANDLER	; jmp to interrupt handler

; MAIN
; -----------------
; Entry point for the program
MAIN:
	CALL INIT		; initialize variables
LOOP:
	SBI PORTB, 0	; SET BIT PB0
	CALL DELAY		; Delay
	CBI PORTB, 0	; clear bit PB0
	CALL DELAY		; Delay
	JMP LOOP		; Loop forever

; INIT
; ---------------
; Initalizes ports and sets flags
INIT:
	SBI DDRB, 0		; configure PB0 as an output
	SBI DDRB, 1		; configure PB1 as an output
	SBI EIMSK, INT0	; Enable INT0 (Interrupt Pin 0)
	SBI PORTD, 2
	LDI R16, 0x03	; Set INT0 to react to pin to rising edge
	STS EICRA, R16	; Send to pin
	SEI				; Enable global interrupt
	RET

; INT_HANDLER
; ---------------
; Interrupt handler
; Called when INT0 goes low
INT_HANDLER:
	CPI LED_STATE, 1	; Compare immediate register LED_STATE and 1
	BREQ OFF			; If they are equal turn the light off
ON:						; If not turn the light on
	SBI PORTB, 1		; Set bit 1 of PORTB on
	LDI LED_STATE, 1	; Set register LED_STATE to 1
	RETI				; End interrupt
OFF:
	CBI PORTB, 1		; Clear bit 1 of PORTB
	LDI LED_STATE, 0	; Set register LED_STATE to 0
	RETI

; DELAY
; ---------------------
; Delays for ...
DELAY:
	LDI R16, 20
INNER:
	LDI R17, 255
MIDDL:
	LDI R18, 245
OUTER:
	DEC R18
	BRNE OUTER
	DEC R17
	BRNE MIDDL
	DEC R16
	BRNE INNER
	RET
