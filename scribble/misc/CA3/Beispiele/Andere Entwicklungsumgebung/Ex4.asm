;
; Ex4.asm  ---- Example program 4 for DRAGON12 board, Rev. E (c)2004, EVBplus.com
;		Written by Wayne Chu
;
;     Function:	It displays the word 'SCAn" on the 7-segment LED display,
;   		scans a keypad and displays the key number on the
;		7-segment LED display if a key is down.
;
;     Instruction: Connect a 4 x 4 keypad to the keypad header J29.
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
DB0	equ	1
DB1	equ	2
DB6	equ	$40

DIG0:	equ	8	; PP3
DIG1:	equ	4	; PP2
DIG2:	equ	2	; PP1
DIG3:	equ	1	; PP0

TB1MS:		equ	24000	; 1ms time base of 24,000 instruction cycles
;				; 24,000 x 1/24MHz = 1ms at 24 MHz bus speed

REGBLK:		equ	$0

	org	$1000
;
select:		rmb	1
d1ms_flag:	rmb	1
disp_data:	rmb	4
disptn:		rmb	4
temp:		rmb	1
key_flag:	rmb	1
count10:	rmb	1

STACK:	equ	$2000
;
; Segment conversion table:
;
; Binary number:	 	0,1,2,3,4,5,6,7,8,9,A,B,C,D,E,F
; Converted to 7-segment char: 	0,1,2,3,4,5,6,7,8,9,A,B,C,D,E,F
;
; Binary number:		$10,$11,$12,$13,$14,$15,$16,$17
; Converted to 7-segment char:   G   H   h   J   L   n   o   o
;
; Binary number:  		$18,$19,$1A,$1B,$1C,$1D,$1E,$1F,$20
; Converted to 7-segment char:   P   r   t   U   u   y   _  --  Blank
;
;

	org	$2000
;
	jmp	start
segm_ptrn:						; segment pattern
	fcb     $3f,$06,$5b,$4f,$66,$6d,$7d,$07		; 0-7
;		 0,  1,  2,  3,  4,  5,  6,  7
        fcb     $7f,$6f,$77,$7c,$39,$5e,$79,$71		; 8-$0f
;		 8,  9,  A,  b,  C,  d,  E,  F
       	fcb     $3d,$76,$74,$1e,$38,$54,$63,$5c		; 10-17
;		 G,  H,  h,  J   L   n   o   o
       	fcb     $73,$50,$78,$3e,$1c,$6e,$08,$40		; 18-1f
;		 P,  r,  t,  U,  u   Y   -   -
       	fcb     $00,$01,$48,$41,$09,$49			; 20-23
;		blk, -,  =,  =,  =,  =
;
seven_segment:
	pshx
	pshb
	ldx	#segm_ptrn
	psha
	anda	#$3f
	tab
	abx
	ldaa	0,x		; get segment
	pulb
	andb	#$80		; add DP
	aba
	pulb
	pulx
	rts

#ifdef  Wytec_keypad
; keypad scan for Wytec 4X4 membrane keypad (pin 1-4 = col 0-3, pin 5-8 = row 0-3)
; at exit:  if a key is down, the carry bit =1 and the accumulator B
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


start:	lds	#STACK
	ldx	#timer6
	stx	$3E62		; initialize the int vetctor

	ldx	#REGBLK
	ldaa	#$ff		; turn off 7-segment display
	staa	ptp,x		; portp = 11111111

	staa	ddrb,x		; portb = output
	staa	ddrp,x		; portp = output
  	staa	ddrj,x		; make port J an output port
       	staa    ptj,x		; make PJ1 high to disable LEDs

	ldaa	#$80
	staa	tscr,x		; enable timer
	ldaa	#DB6
	staa	tios,x		; select t6 as an output compare	 
	staa	tmsk1,x

	ldaa	#5		; letter 'S'
	staa	disp_data
	ldaa	#$0C		; letter 'C'
	staa	disp_data+1
	ldaa	#$0A		; letter 'A'
	staa	disp_data+2
	ldaa	#$15		; letter 'n'
	staa	disp_data+3
	clr	count10

	cli
;
begin:	ldx	#REGBLK
	jsr 	keypad
	bcc	no_key
	brset	key_flag DB0 was_set	; key already down
	bset	key_flag DB0
	jmp	dead_key
was_set:
	brset	key_flag DB1 dead_key	; key already processed

	inc	count10
	ldaa	count10		; check keyboard every 10 loops (10ms)
	cmpa	#10
	bne	no_key
	clr	count10
	bset	key_flag DB1

	stab	disp_data
	stab	disp_data+1
	stab	disp_data+2
	stab	disp_data+3
	jmp	dead_key
	
no_key:	clr	key_flag
dead_key:
	ldx	#disp_data
	jsr	move
	jsr	sel_digit

wait:	tst	d1ms_flag
	beq	wait			; wait for 1ms timeup
	clr	d1ms_flag
	jmp	begin

;
;    this routine moves 4 bytes of data into display
;    pattern and converts the pattern to seven segment code.
;    @ enter, x points the source address
;
move:	ldy	#disptn
mnext: 	ldaa	0,x
	jsr	seven_segment	; convert Accu A to segment pattern, bit 7= DP
	staa	0,y
	inx
	iny
	cpy	#disptn+4
        bne	mnext
	rts
;
; multiplexing display one digit at a time
;
sel_digit:
	ldx	#REGBLK
	inc	select
	ldab	select
	andb	#3
	tstb
	beq	digit3
	decb
	beq	digit2
	decb
	beq	digit1

digit0: 
	ldaa	disptn+3
	staa	portb,x
	bclr	ptp,x,DIG0		; turn on digit 0
	bset	ptp,x,DIG1		; turn off all other digits
	bset	ptp,x,DIG2
	bset	ptp,x,DIG3
	rts
digit1: 
	ldaa	disptn+2
	staa	portb,x

	bset	ptp,x,DIG0		
	bclr	ptp,x,DIG1		; turn on digit 1
	bset	ptp,x,DIG2		; turn off all other digits
	bset	ptp,x,DIG3
	rts
digit2: 
	ldaa	disptn+1
	staa	portb,x

	bset	ptp,x,DIG0		
	bset	ptp,x,DIG1	
	bclr	ptp,x,DIG2		; turn on digit 2
	bset	ptp,x,DIG3		; turn off all other digits
	rts
digit3: 
	ldaa	disptn
	staa	portb,x

	bset	ptp,x,DIG0		
	bset	ptp,x,DIG1	
	bset	ptp,x,DIG2
	bclr	ptp,x,DIG3		; turn on digit 3
	rts

timer6:
	ldx	#REGBLK
; in an interrupt servicing routine the x register will be saved automatically
; the rti instruction will pop the x register off stack.

	inc	d1ms_flag
	ldd	#TB1MS		; reload the count for 1 ms time base
	addd	tc6,x		
	std	tc6,x
	ldaa	#DB6
	staa	tflg1,x		; clear flag
	rti

	org	$3E62
	fdb	timer6
	
	end
