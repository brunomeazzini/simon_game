#include <p16f887.inc>
list p=16f887

	cblock 0x20
		led_cnt
	endc

	org		0x00	; reset vector
	goto 	Start
	
	org		0x04	;interrupt vector
	retfie
	
Start:
	;----- I/O config ------
	bsf 	STATUS, RP0	; change to bank1
	movlw 	B'11110000'
	movwf 	TRISA		; config RA0-R3 as ouput
						; and RA4-RA7 as input
	bsf 	STATUS, RP1	; change to bank3
	clrf	ANSEL		; configure all PORTA,
						; pins as digital I/O
Main:
	call	RotinaInicializacao
	
RotinaInicializacao:
	bcf 	STATUS, RP1
	bcf 	STATUS, RP0 ; change to bank0
	movlw 	0x0F			
	movwf 	PORTA		; set pins RA0-RA3
	call	Delay_1s	; call delay function			
	clrf 	led_cnt		; led_cnt = 0
	
LedCountLoop:
	clrf	PORTA		; clear pins RA0-RA3
	movlw 	.0
	subwf 	led_cnt, W
	btfsc	STATUS, Z	; led_cnt=0?
	bsf 	PORTA, RA0	; yes
	
	movlw 	.1
	subwf 	led_cnt, W
	btfsc	STATUS, Z	; led_cnt=1?
	bsf 	PORTA, RA1	; yes
					
	movlw 	.2
	subwf 	led_cnt, W
	btfsc	STATUS, Z	; led_cnt=1?
	bsf 	PORTA, RA2	; yes
	
	movlw 	.3
	subwf 	led_cnt, W
	btfsc	STATUS, Z	; led_cnt=1?
	bsf 	PORTA, RA3	; yes
	
	call 	Delay_200ms								
	incf	led_cnt, F 	; incrementa led_cnt
	
	movlw	.4
	subwf	led_cnt, W	
	btfss 	STATUS, Z 	; led_cnt=4?
	goto	LedCountLoop		; no
	clrf	PORTA		; yes
	return
	
