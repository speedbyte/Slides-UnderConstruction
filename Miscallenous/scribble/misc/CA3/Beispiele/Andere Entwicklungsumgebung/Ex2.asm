;
; Ex2.asm  ---- Example program 2 for DRAGON12 board Rev. E (c)2004, EVBplus.com
;		Written by Wayne Chu
;
;     Function:	Makes port B as a binary counter.
;
;
#include        reg9s12.h
REGBLK:		equ	$0000
SPEED:		equ	$FFFF	; change this number to change counting speed
;
STACK:	equ	$2000
;
        org     $2000		; program code
start:
	lds	#STACK
	ldx	#REGBLK

       	ldaa	#$ff
       	staa	ddrj,x		; make port J an output port
 	staa	ddrb,x		; make port B an output port
	staa 	ddrp,x		; make port P an output port
	staa	ptp,x		; turn off 7-segment LED display
	
        ldaa	#$00
	staa    ptj,x		; make PJ1 low to enable LEDs
back:	inca
	staa 	portb,x
	jsr	d_10ms
	jmp	back
*
d_10ms:	ldab	#10		; delay 10 ms
	jmp	dly1

delay:	ldab	#1		; delay 1 ms
dly1:	ldy	#6000		; 6000 x 4 = 24,000 cycles = 1ms
dly:	dey			; 1 cycle
	bne	dly		; 3 cycles
	decb
	bne	dly1
	rts
  	end
