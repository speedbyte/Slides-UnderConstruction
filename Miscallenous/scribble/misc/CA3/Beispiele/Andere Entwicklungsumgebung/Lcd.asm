;
; LCD.asm ----- LCD sample program for DRAGON12 Rev. E board
;		(c)2004, EVBplus.com, written by Wayne Chu
;
;     Function:	This is the simplest way to displays a message on the
;		16X2 LCD display module. The cursor is off.
	
     
ONE_MS:		equ	4000	; 4000 x 250ns = 1 ms at 24 MHz bus speed
FIVE_MS:	equ	20000
TEN_MS:		equ	40000
FIFTY_US:	equ	200


DB0:		equ	1
DB1:		equ	2
REG_SEL:	equ	DB0	; 0=reg, 1=data
NOT_REG_SEL:	equ	$FE
ENABLE:		equ     DB1
NOT_ENABLE:	equ     $FD

LCD:		equ	portk
LCD_RS:		equ	portk
LCD_EN:		equ	portk

REGBLK:		equ	$0
#include        reg9s12.h	; include register equates

STACK:	equ	$2000

	org	$1000

pkimg:		rmb	1
reset_seq:	rmb	1
temp1:		rmb	1

LCDimg:		equ	pkimg
LCD_RSimg:	equ	pkimg
LCD_ENimg:	equ	pkimg

	org	$2000
	jmp	start

lcd_ini:
	ldaa	#$ff
	staa	ddrk		; port K = output
	clra	
	staa	pkimg
	staa	portk

       	ldx	#inidsp1 	; point to init. codes.    
	ldaa	#1
	staa	reset_seq	; need more delay for first reset seq.
       	jsr    	outins1  	; output codes.  

       	ldx	#inidsp2 	; point to init. codes.    
	clr	reset_seq
       	jsr    	outins2  	; output codes.  
	rts
inidsp1:	
	fcb	2		; number of instrutions
	fcb	$33		; reset char  
	fcb	$32		; reste char
inidsp2:	
	fcb	4		; number of instrutions
	fcb	$28   		; 4bit, 2 line, 5X7 dot
	fcb	$06		; cursor increment, disable display shift
	fcb	$0c		; display on, cursor off, no blinking
	fcb	$01		; clear display memory, set cursor to home pos
outins1:
	pshb            	; output instruction command.
       	jsr    	sel_inst
       	ldab   	0,x
       	inx
onext1:	ldaa   	0,x
       	jsr    	wrt_pulse  	; initiate write pulse.
       	inx
	jsr	delay_5ms
       	decb
       	bne    	onext1
       	pulb
       	rts

outins2:
	pshb            		; output instruction command.
       	jsr    	sel_inst
       	ldab   	0,x
       	inx
onext2:	ldaa   	0,x
       	jsr    	wrt_pulse    		; initiate write pulse.
       	inx
       	decb
       	bne    	onext2
	jsr	delay_5ms
       	pulb
       	rts
sel_data:
	psha
;	bset	LCD_RSimg REG_SEL	; select instruction
	ldaa	LCD_RSimg
	oraa	#REG_SEL
	bra	sel_ins
sel_inst:
	psha
;	bclr	LCD_RSimg REG_SEL	; select instruction
	ldaa	LCD_RSimg
	anda	#NOT_REG_SEL
sel_ins:
	staa	LCD_RSimg
	staa	LCD_RS
	pula
        rts

lcd_line1:
	jsr    	sel_inst		; select instruction
       	ldaa   	#$80     		; starting address for the line1
	bra	line3
lcd_line2:
	jsr    	sel_inst
       	ldaa   	#$C0     		; starting address for the line2
line3: 	jsr    	wrt_pulse

       	jsr    	sel_data
	jsr	msg_out
	rts	
;
; at entry, x must point to the begining of the message,
;           b = number of the character to be sent out
           
msg_out:
	ldaa   	0,x
       	jsr    	wrt_pulse
       	inx
       	decb
       	bne    	msg_out
	rts
;
;       @ enter, a=data to output 
;
wrt_pulse:
	pshx
       	psha        			; save it tomporarily.
       	anda   #$f0     		; mask out 4 low bits.           
	lsra
	lsra				; 4 MSB bits go to pk2-pk5				
       	staa   temp1 			; save nibble value.
       	ldaa   LCDimg    		; get LCD port image.
       	anda   #$03     		; need low 2 bits.
       	oraa   temp1    		; add in low 4 bits. 
       	staa   LCDimg    		; save it
       	staa   LCD    			; output data          
;
	bsr	enable_pulse
	ldaa	reset_seq
	beq	wrtpls
	jsr	delay_5ms		; delay for reset sequence
;
wrtpls:	pula
 	asla            		; move low bits over.
	asla
       	staa   	temp1			; store temporarily.
;
       	ldaa   	LCDimg 			; get LCD port image.
       	anda   	#$03   			; need low 2 bits.
       	oraa   	temp1  			; add in loiw 4 bits. 
       	staa   	LCDimg    		; save it
       	staa   	LCD    			; output data          
;
	bsr	enable_pulse
	pulx
       	rts
;
enable_pulse:
;	bset	LCD_ENimg ENABLE	; ENABLE=high
	ldaa	LCD_ENimg
	oraa	#ENABLE
	staa	LCD_ENimg
	staa	LCD_EN
	
;	bclr	LCD_ENimg ENABLE	; ENABLE=low
	ldaa	LCD_ENimg
	anda	#NOT_ENABLE
	staa	LCD_ENimg
	staa	LCD_EN
	
	jsr	delay_50us
	rts

delay_10ms:  
	pshx
	ldx     #TEN_MS
  	bsr	del1
	pulx
	rts
delay_5ms:
	pshx
	ldx     #FIVE_MS
  	bsr	del1
	pulx
	rts
delay_50us:
	pshx
	ldx     #FIFTY_US
  	bsr	del1
	pulx
	rts
;
; 250ns delay at 24MHz bus speed
;
del1:	dex				; 1 cycle
	inx				; 1 cycle
	dex				; 1 cycle
	bne	del1			; 3 cylce
	rts

start:
	lds	#STACK
   	jsr	delay_10ms		; delay 20ms during power up
    	jsr	delay_10ms

    	jsr	lcd_ini			; initialize the LCD 
                      	
back:	ldx    	#MSG1			; MSG1 for line1, x points to MSG1
        ldab    #16                     ; send out 16 characters
    	jsr	lcd_line1

    	ldx    	#MSG2			; MSG2 for line2, x points to MSG2
        ldab    #16                     ; send out 16 characters
     	jsr	lcd_line2
     	jsr	delay_10ms
     	jsr	delay_10ms
     	jmp	back
                       
MSG1:   FCC     " YOU DESERVE A  "
MSG2:   FCC     "  BREAK TODAY   "
       	end
