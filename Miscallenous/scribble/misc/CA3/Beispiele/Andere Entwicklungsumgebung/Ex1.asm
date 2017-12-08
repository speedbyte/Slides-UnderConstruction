;
; Ex1.asm  ---- Example program 1 for DRAGON12 board Rev E. (c)2004, EVBplus.com
;		Written by Wayne Chu
;
;     Function:	Reads the DIP switch via port H and displays its status
;		on port B LEDs PB0-PB7.
	
;
#include        reg9s12.h
REGBLK:	equ	$0000
STACK:	equ	$2000

        org     $2000		; program code starts here
start:
	lds	#STACK
	ldaa	#$ff

	staa	ddrb+REGBLK	; make port B an output port
	staa	ddrj+REGBLK	; make port J an output port
        staa 	ddrp+REGBLK	; make port P an output port
	staa	ptp+REGBLK	; turn off 7-segment LED display

	ldaa	#$00
	staa    ptj+REGBLK      ; make PJ1 low to enable LEDs
	staa	ddrh+REGBLK	; make port H an input port
back:	ldaa	ptih+REGBLK	; read from DIP sw.
	staa 	portb+REGBLK	; output it to LEDs PB0-PB7
	jmp	back

  	end

