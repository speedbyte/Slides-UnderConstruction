;
; 500Hz.asm --- Square wave generator for DRAGON12 Rev. E board,
;		(c)2002, EVBplus.com, written by Wayne Chu
;
;     Function:	500 Hz square wave routine using output comparator 6
;		It generates a 500Hz square wave on PB0 LED (pin 24 of the MCU)
;		and a 2Hz square wave on PB7 LED (pin 31 of the MCU).
;
PB0:	equ	1
DB6:	equ	$40

TB1MS:		equ	24000	; 1ms time base of 24,000 instruction cycles
;				; 24,000 x 1/24MHz = 1ms at 24 MHz bus speed

REGBLK:		equ	$0
#include        reg9s12.h	; include register equates


STACK:		equ	$2000

		org	$1000
count250:	rmb	1


	org	$2000
start:
	lds	#STACK
	ldx	#timer6
	stx	$3E62		; initialize the int vetctor

	ldx	#REGBLK
	ldaa	#$ff
	staa	ddrb,x		; make port B an output port
	staa 	ddrp,x		; make port P an output port
	staa	ptp,x		; turn off 7-segment LED display

 	staa	ddrj,x		; make port J an output port
        clr     ptj,x		; make PJ1 low to enable LEDs

	ldaa	#$80
	staa	tscr,x		; enable timer
	ldaa	#DB6
	staa	tios,x		; select t6 as an output compare	 
	staa	tmsk1,x

	cli

back:	ldaa	count250
	cmpa	#250
	bne	back
	clr	count250
	ldaa	portb
	eora	#$80		; toggle the PB7 ever 250ms
	staa	portb
	jmp	back
	
timer6:
	ldx	#REGBLK
	inc	count250
	ldd	#TB1MS		; reload the count for 1 ms time base
	addd	tc6,x		
	std	tc6,x

	ldaa	#DB6
	staa	tflg1,x		; clear flag
	ldaa	portb
	eora	#1		; toggle the PB0
	staa	portb
        rti

	org	$3E62
	fdb	timer6
	end
