*
* Kpad4x4.asm - A simple keypad routine for the DRAGON12 Rev. E board
*               (C)2004, written By Wayne Chu
*
*     Function: It scans a keypad and outputs the key number in binary
*		format on the PB0-PB4 LEDs
*
*     Instructions:
*     If you have a 4 x 4 keypad, connect it to the keypad header J29.
*
*	   If you press any key on the keypad, the LEDs should show
*	   the key number that you pressed in binary format. Key number 00
*	   is shown as $10.
*
;
; There are two different keypads have been used with Wytec development boards.
; The following signal definitions only apply to Grayhill 4X4 keypad:

; PA0 connects ROW0 of the keypad via pin 1 of the 8-pin keypad header J29
; PA1 connects ROW1 of the keypad via pin 2 of the 8-pin keypad header J29
; PA2 connects ROW2 of the keypad via pin 3 of the 8-pin keypad header J29
; PA3 connects ROW3 of the keypad via pin 4 of the 8-pin keypad header J29

; PA4 connects COL0 of the keypad via pin 5 of the 8-pin keypad header J29
; PA5 connects COL1 of the keypad via pin 6 of the 8-pin keypad header J29
; PA6 connects COL2 of the keypad via pin 7 of the 8-pin keypad header J29
; PA7 connects COL3 of the keypad via pin 8 of the 8-pin keypad header J29

; The PA0-PA7 has a 100K pull-up resistor in each line.

; The following signal definitions only apply to Wytec 4X4 membrane keypad:

; PA0 connects COL0 of the keypad via pin 1 of the 8-pin keypad header J29
; PA1 connects COL1 of the keypad via pin 2 of the 8-pin keypad header J29
; PA2 connects COL2 of the keypad via pin 3 of the 8-pin keypad header J29
; PA3 connects COL3 of the keypad via pin 4 of the 8-pin keypad header J29

; PA4 connects ROW0 of the keypad via pin 5 of the 8-pin keypad header J29
; PA5 connects ROW1 of the keypad via pin 6 of the 8-pin keypad header J29
; PA6 connects ROW2 of the keypad via pin 7 of the 8-pin keypad header J29
; PA7 connects ROW3 of the keypad via pin 8 of the 8-pin keypad header J29

; The PA0-PA7 has a 100K pull-up resistor in each line.

; To use the Grayhill keypad, remark the label Wytec_keypad and un-remark
; the label Grayhill_keypad

Wytec_keypad:		equ     1       ; use Wytec_keypad
;Grayhill_keypad:        equ     1      ; not to use Grayhill_keypad


#include        reg9s12.h	; include register equates
;
REGBLK:		equ	$0

		org	$1000
;
temp:		rmb	1

STACK:		equ	$2000

	org	$2000
;
	jmp	start
	
	
#ifdef  Wytec_keypad
; keypad scan for Wytec 4X4 membrane keypad (pin 1-4 = col 0-3, pin 5-8 = row 0-3)
; at exit:  if a key is down, the carry bit =1 and the accumulator b
;	    holds the key number
;	    if no key is dwon the carry bit =0

keypad:
;	ldaa 	#00001111b
	ldaa 	#$0F		; pa0-pa3 are outputs, pa4-pa7 are inputs
	staa 	ddra

	ldab	#15
;	ldaa	#11110111b
	ldaa	#$F7		; pa3=low, pa0-pa2=high
	staa	temp		; save it at temp
next_row:
	staa	porta
	ldaa	#10		; add delay before checking key down
k_dly:	deca
	bne	k_dly

	ldaa	porta
	anda	#$F0		; only read 4 MSBs pa4-pa7
	cmpa	#$F0
	bne	keyin		; a key is pressed
	decb
	cmpb	#11
	beq	no_keyin	; after 4 tests, accu B will be 11

 	ror	temp
	ldaa	temp
	jmp	next_row

no_keyin:
	clc
	rts			; no key input

keyin:	rola
 	bcc	key_ok
 	subb    #4
 	jmp     keyin
key_ok:	sec
	rts
#endif
;

#ifdef  Grayhill_keypad
;
; keypad scan for Grayhill 4x4 keypad (pin 1-4 = row 0-3, pin 5-8 = col 0-3)
; at exit:  if a key is down, the carry bit =1 and the accumulator b
;	    holds the key number
;	    if no key is dwon the carry bit =0

keypad:
;	ldaa 	#00001111b
	ldaa 	#$0F		; pa0-pa3 are outputs, pa4-pa7 are inputs
	staa 	ddra

	ldab	#16
;	ldaa	#11110111b
	ldaa	#$F7		; pa3=low, pa0-pa2=high
	staa	temp		; save it at temp
next_row:
	staa	porta
	ldaa	#10		; add delay before checking key down
k_dly:	deca
	bne	k_dly

	ldaa	porta
	anda	#$F0		; only read 4 MSBs pa4-pa7
	cmpa	#$F0
	bne	keyin		; a key is pressed
	subb	#4
	beq	no_keyin	; after 4 tests, accu B will be 0

	ror	temp
	ldaa	temp
	jmp	next_row

no_keyin:
	clc
	rts			; no key input

keyin:	decb
	rola
	bcs	keyin
	sec
	rts
#endif

delay_10ms:
	psha
	ldaa    #10
dly_10ms:
	jsr     delay_1ms
	deca
	bne 	dly_10ms
	pula
	rts
delay_1ms:
	pshy
	ldy     #3000		; 3000 x 8 = 24,000 cycles = 1ms
del1:	dey			; 4 cycles
	nop			; 1 cycle
	bne	del1		; 3 cycles
	puly
       	rts

start:	lds	#STACK
 	ldx	#REGBLK
	ldaa	#$ff		; turn off 7-segment display
	staa	ptp,x		; portp = 11111111

	staa	ddrb,x		; portb = output
	staa	ddrp,x		; portp = output
	staa	ptp,x		; portp = 11111111
;
 	staa	ddrj,x		; make port J an output port
        clr     ptj,x		; make PJ1 low to enable LEDs
begin:
        jsr 	keypad
	bcc	nokey
   	jsr	delay_10ms
	jsr 	keypad
	bcc	nokey
; key down
        tstb
	bne     not_zero
	ldab    #$10
not_zero:
	stab	portb,x
	jmp	begin
;
nokey:  jsr	delay_10ms
        jmp	begin
;
	end
