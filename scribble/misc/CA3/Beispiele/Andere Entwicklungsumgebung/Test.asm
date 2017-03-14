;
; Test.asm ---  Test program for DRAGON12 Rev. E board, (c)2004, EVBplus.com
;		Written By Wayne Chu

;     Function: This is the factory test program for checking on-board
;		hardware. It checks the DIP switch of port H, 8 LEDs of
;		port B, the pushbuttons SW2(PH3)-SW5(PH0), and the LCD display.
;		It scans the keypad and displays the key number on the 7 
;		segment LED display while playing a song. It allows to 
;		adjust the trimmer pot to change LED display's brightness.
;
;     Instructions:
;	   If you have a 4 x 4 keypad, connect it to the keypad header J29.
;	   Before running the test program, place all individual DIP
;	   switches at upper positions.
;
;	1. After running the test program, test each individual switch and
;	   see the corresponding LED status on the PB0-PB7.
;		LCD display shows:	"PRESS SW2 & SW5 "
;                                       "WHEN 8DIP-SWs UP"
;
;	2. Test the pushbutton switches PH0-PH3 only when all
;	   PH0-PH3 switches on the DIP switch are in the upper positions.
;		LCD display shows:	"PRESS SW2 & SW5 "
;                                       "WHEN 8DIP-SWs UP"
;
;	3. Set all individual DIP switches at the upper postions.
;	   Press the pushbutton switches SW2 and SW5 simultaneously, and the
;	   music should come out. The hex number 0 to F should be
;	   shifting out on the 7 segment LED display. The RX LED should be off
;	   and the TX LED should be on.
;		LCD display shows:	"TESTING IR LIGHT"
;                                       "NO OBJECT NEARBY"

;	4. Adjust the trimmer pot, the 7 segment LED display's brightness 
;	   should change. If you press any key on the keypad, the 7 segment
;	   display will display the key number that you pressed.
;		LCD display shows:	"TESTING IR LIGHT"
;                                       "NO OBJECT NEARBY"

;	5. Place your hand 6" from the IR transceiver, and to allow the IR
;	   light reflect. Both the RX LED and TX LED should be on, then observe
;	   the message on the LCD display. See IR_sen.asm for details.
;		LCD display shows:	"TESTING IR LIGHT"
;                                       " OBJECT DETECTED"
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



MULTI_MODE:	equ	$10
SINGLE_MODE:	equ	0
SCAN_MODE:	equ	$20
NO_SCAN_MODE:	equ	0
CHANNEL_NUM:	equ	7		; reading input from AN07

DIG0:		equ	8		; PP3
DIG1:		equ	4		; PP2
DIG2:		equ	2		; PP1
DIG3:		equ	1		; PP0

DB0:		equ	1
DB1:		equ	2
DB2:		equ   	4
DB3:		equ   	8
DB4:		equ	$10
DB5:		equ	$20
DB6:		equ	$40
DB7:		equ	$80

OL5:		equ	DB2
OM5:		equ	DB3

ONE_MS:		equ	4000		; 4000 x 250ns = 1 ms at 24 MHz bus speed
FIVE_MS:	equ	20000
TEN_MS:		equ	40000
FIFTY_US:	equ	200

REG_SEL:	equ	DB0		; 0=reg, 1=data
NOT_REG_SEL:	equ	$FE
ENABLE:		equ     DB1
NOT_ENABLE:	equ     $FD

LCD:		equ	portk
LCD_RS:		equ	portk
LCD_EN:		equ	portk

TB1MS:		equ	24000		; 1ms time base of 24,000 instruction cycles
;					; 24,000 x 1/24MHz = 1ms at 24 MHz bus speed
F3500HZ:	equ	3429
REGBLK:		equ	$0
#include        reg9s12.h		; include register equates

	org	$1000

ram:		rmb	1
temp:           rmb     1
shift_cnt:	rmb	2
select:		rmb	1
spk_tone:	rmb	2
sound_dur:	rmb	1
xsound_save:	rmb	2
sound_repeat:	rmb	1
xsound_beg:	rmb	2
sound_start:	rmb	1
rest_note:	rmb	1
d1ms_flag:	rmb	1
key_flag:	rmb	1
disptn:		rmb	4
key4:		rmb	4
xsave:		rmb	2
disp_ram:	rmb	3
adctl_image:	rmb	1
brtness:	rmb	1
turn_led_on:	rmb	1
count_5ms:	rmb	1
count10:	rmb	1

pkimg:		rmb	1
reset_seq:	rmb	1
temp1:		rmb	1

LCDimg:		equ	pkimg
LCD_RSimg:	equ	pkimg
LCD_ENimg:	equ	pkimg

ramend:		rmb	1
ALLRAM:		equ 	ramend-ram          ;total ram used

STACK:	equ	$2000
;
; Segment conversion table:

; Binary number:	 	0,1,2,3,4,5,6,7,8,9,A,B,C,D,E,F
; Converted to 7-segment char: 	0,1,2,3,4,5,6,7,8,9,A,B,C,D,E,F
;
; Binary number:		$10,$11,$12,$13,$14,$15,$16,$17
; Converted to 7-segment char:   G   H   h   J   L   n   o   o
;
; Binary number:  		$18,$19,$1A,$1B,$1C,$1D,$1E,$1F,$20
; Converted to 7-segment char:   P   r   t   U   u   y   _  --  Blank


; for 24 MHz bus speed
; 1200000 / 261.63 Hz = note count
;
c3	equ	45866		; 261.63 Hz at 24 MHz
c3s	equ	43293		; 277.18 Hz at 24 MHz
d3	equ	40864		; 293.66 Hz at 24 MHz
d3s	equ	38569		; 311.13 Hz at 24 MHz
e3	equ	36404		; 329.63 Hz at 24 MHz
f3	equ	34361		; 349.23 Hz at 24 MHz
f3s	equ	32433		; 369.99 Hz at 24 MHz
g3	equ	30613		; 391.99 Hz at 24 MHz
g3s	equ	28894		; 415.31 Hz at 24 MHz
a3	equ	27273		; 440.00 Hz at 24 MHz
a3s	equ	25742		; 466.16 Hz at 24 MHz
b3	equ	24297		; 493.88 Hz at 24 MHz

c4	equ	22934		; 523.25 Hz at 24 MHz
c4s	equ	21646		; 554.37 Hz at 24 MHz
d4	equ	20431		; 587.33 Hz at 24 MHz
d4s	equ	19285		; 622.25 Hz at 24 MHz
e4	equ	18202		; 659.26 Hz at 24 MHz
f4	equ	17181		; 698.46 Hz at 24 MHz
f4s	equ	16216		; 739.99 Hz at 24 MHz
g4	equ	15306		; 783.99 Hz at 24 MHz
g4s	equ	14447		; 830.61 Hz at 24 MHz
a4	equ	13636		; 880.00 Hz at 24 MHz
a4s	equ	12871		; 932.32 Hz at 24 MHz
b4	equ	12149		; 987.77 Hz at 24 MHz

c5	equ	11467		; 1046.50 Hz at 24 MHz
c5s	equ	10823		; 1108.73 Hz at 24 MHz
d5	equ	10216		; 1174.66 Hz at 24 MHz
d5s	equ	9642		; 1244.51 Hz at 24 MHz
e5	equ	9101		; 1318.51 Hz at 24 MHz
f5	equ	8590		; 1396.91 Hz at 24 MHz
f5s	equ	8108		; 1479.98 Hz at 24 MHz
g5	equ	7653		; 1567.98 Hz at 24 MHz
g5s	equ	7225		; 1661.22 Hz at 24 MHz
a5	equ	6818		; 1760.00 Hz at 24 MHz
a5s	equ	6435		; 1864.66 Hz at 24 MHz
b5	equ	6074		; 1975.53 Hz at 24 MHz

c6	equ	5733		; 2093.00 Hz at 24 MHz
c6s	equ	5412		; 2217.46 Hz at 24 MHz
d6	equ	5109		; 2349.32 Hz at 24 MHz
d6s	equ	4821		; 2489.02 Hz at 24 MHz
e6	equ	4551		; 2637.02 Hz at 24 MHz
f6	equ	4295		; 2793.83 Hz at 24 MHz
f6s	equ	4054		; 2959.96 Hz at 24 MHz
g6	equ	3827		; 3135.97 Hz at 24 MHz
g6s	equ	3612		; 3322.44 Hz at 24 MHz
a6	equ	3409		; 3520.00 Hz at 24 MHz
a6s	equ	3218		; 3729.31 Hz at 24 MHz
b6	equ	3037		; 3951.07 Hz at 24 MHz

c7	equ	2867		; 4186.01 Hz at 24 MHz
c7s	equ	2706		; 4434.92 Hz at 24 MHz
d7	equ	2554		; 4698.64 Hz at 24 MHz
d7s	equ	2411		; 4978.03 Hz at 24 MHz
e7	equ	2275		; 5274.04 Hz at 24 MHz
f7	equ	2148		; 5587.66 Hz at 24 MHz
f7s	equ	2027		; 5919.92 Hz at 24 MHz
g7	equ	1913		; 6271.93 Hz at 24 MHz
g7s	equ	1806		; 6644.88 Hz at 24 MHz
a7	equ	1705		; 7040.00 Hz at 24 MHz
a7s	equ	1609		; 7458.63 Hz at 24 MHz
b7	equ	1519		; 7902.13 Hz at 24 MHz
c8	equ	1		; for rest note

note_c	equ	0
note_cs	equ	1
note_d	equ	2
note_ds	equ	3
note_e	equ	4
note_f	equ	5
note_fs	equ	6
note_g	equ	7
note_gs	equ	8
note_a	equ	9
note_as	equ	10
note_b	equ	11

; dur18= 1/8 note,  dur14= 1/4 note,  $fe= rest_note, $ff = end of song
	
dur18	equ	50
dur14	equ	100
	

	org	$2000
	jmp	start
;
NOTE_TABLE:
	fdb	c3,c3s,d3,d3s,e3,f3,f3s,g3,g3s,a3,a3s,b3
	fdb	0,0,0,0		; dummy byte
	fdb	c4,c4s,d4,d4s,e4,f4,f4s,g4,g4s,a4,a4s,b4
	fdb	0,0,0,0		; dummy byte
	fdb	c5,c5s,d5,d5s,e5,f5,f5s,g5,g5s,a5,a5s,b5
	fdb	0,0,0,0		; dummy byte
	fdb	c6,c6s,d6,d6s,e6,f6,f6s,g6,g6s,a6,a6s,b6
	fdb	0,0,0,0		; dummy byte
	fdb	c7,c7s,d7,d7s,e7,f7,f7s,g7,g7s,a7,a7s,b7
	fdb	0,0,0,0		; dummy byte
	fdb	c8
;

segm_ptrn:						; segment pattern
	fcb     $3f,$06,$5b,$4f,$66,$6d,$7d,$07		;0-7
;		 0,  1,  2,  3,  4,  5,  6,  7
        fcb     $7f,$6f,$77,$7c,$39,$5e,$79,$71		;8-$0f
;		 8,  9,  A,  b,  C,  d,  E,  F
       	fcb     $3d,$76,$74,$1e,$38,$54,$63,$5c		;10-17
;		 G,  H,  h,  J   L   n   o   o
       	fcb     $73,$50,$78,$3e,$1c,$6e,$08,$40		;18-1f
;		 P,  r,  t,  U,  u   Y   -   -
       	fcb     $00,$01,$48,$41,$09,$49			;20-23
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

;
;
; this routine will read adc input on the pin AN7 and store 4 consecutive 
; 
adc_conv:
	adda	#SINGLE_MODE+NO_SCAN_MODE
;
; if you want to read multi-channel input, change above statement to
;	adda	#MULTI_MODE+NO_SCAN_MODE
;
	staa	adctl_image
	ldx	#REGBLK
	jsr	conv
	rts
	
conv:	ldaa	adctl_image
	staa	atd0ctl5,x
not_ready:
	brclr	atd0stat,x $80 not_ready
	rts
BLANK_MSG:
	FCC     "                "
MSG1:   FCC     "PRESS SW2 & SW5 "
MSG2:   FCC     "WHEN 8DIP-SWs UP"



TEST_MSG:
	FCC     "TESTING IR LIGHT"
YES_MSG:
	FCC     " OBJECT DETECTED"
NO_MSG: FCC     "NO OBJECT NEARBY"

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
;           
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
	jsr	delay_5ms			; delay for reset sequence
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

disp_data:
	fcb	0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,0,1,2,3,4

clrall:	pshx
	ldx	#ram
clrr	clr	0,x
	inx
	deca
	bne	clrr
	pulx
	rts
;
start:	lds	#STACK
	sei
	ldx	#timer6
	stx	$3E62		; initialize the int vetctor
	ldx	#timer5_spk
	stx	$3E64
	
	ldx	#REGBLK
	ldaa	#$ff		; turn off 7-segment display
	staa	ptp,x		; portp = 11111111
;
	staa	ddrb,x		; portb = output
	staa	ddrp,x		; portp = output
 	staa	ddrj,x		; make port J an output port
        clr     ptj,x		; make PJ1 low to enable LEDs
	clr	ddrh,x		; porth = input

	ldaa	#$80
	staa	tscr,x		; enable timer
	ldaa	#DB5+DB6
	staa	tios,x		; select t6 as an output compare	 
	staa	tmsk1,x

	
	bset 	atd0ctl2,x $80	; enable adc operation
	bset	atd0ctl3,x $40	; 8 conversion needed for an07
	ldaa	#8
	staa	ddrs,x		; PS2=input, PS3=output
	clr	pts,x		; make PS3=0 to xmit IR light
	
	ldx	#F3500HZ	; 3.5kHz
	stx	spk_tone
	jsr	spk_off

	ldaa	#ALLRAM
	jsr	clrall
   	jsr	delay_10ms	; delay 20ms during power up
    	jsr	delay_10ms

    	jsr	lcd_ini		; initialize the LCD 
                      	
	ldx    	#MSG1		; msg1 for line1, x points to msg1
        ldab    #16             ; send out 16 characters
    	jsr	lcd_line1
;
    	ldx    	#MSG2		; msg2 for line2, x points to msg2
        ldab    #16             ; send out 16 characters
     	jsr	lcd_line2
	
;
	ldx	#REGBLK
back2:	ldaa	ptih,x
	staa 	portb,x
	anda	#$9
	bne	back2
	jsr	delay_10ms
	ldaa	ptih,x
	cmpa	#$F6
	bne	back2

; Ph0 and ph3 are down

	ldx    	#TEST_MSG	; test msg for line1
        ldab    #16             ; send out 16 characters
    	jsr	lcd_line1
;
    	ldx    	#BLANK_MSG	; blank msg for line2
        ldab    #16             ; send out 16 characters
     	jsr	lcd_line2

	cli
	jsr	spk_on
	jsr	start_sound	; start sound

	ldx	#disp_data
	stx 	xsave
begin:	
	jsr 	keypad
	bcc	nokey
   	jsr	delay_10ms
	jsr 	keypad
	bcc	nokey
; key down
	tba			; move key number to ACCU A
	jsr	seven_segment	; convert Accu A to segment pattern, bit 7= DP
	oraa	#$80		; to show up DP
	ldx	#REGBLK
	staa	portb,x

	bclr	ptp,x,DIG0	; turn on digit 0
	bclr	ptp,x,DIG1	; turn on digit 0
	bclr	ptp,x,DIG2	; turn on digit 0
	bclr	ptp,x,DIG3	; turn on digit 0

	jmp	begin
	
nokey:  ldaa	#CHANNEL_NUM	; set channel number before calling 
	jsr	adc_conv	
	ldaa	adr07h+REGBLK
	staa	brtness
;	
	ldx	xsave
	jsr	move		; move 4 bytes of 

	ldaa	#1
	staa	turn_led_on	; turn_on_led
	jsr	sel_digit

	ldaa	brtness		; was read from adc
	beq	turn_off	; if =0, turn off display 
back:	ldx	#13		; make approx. 3.25 us delay
;
; approx. 250 ns delay
;
back1:	dex
	inx
	dex			; 1 cycles
	bne	back1		; 3 cycles
	deca
	bne	back

turn_off:
	clr	turn_led_on
	dec	select
	jsr	sel_digit

	ldx	shift_cnt
	inx
	stx	shift_cnt
	cpx	#750		; 500 ms
	bne	wait
	clr	shift_cnt
	clr	shift_cnt
	ldx	xsave
	inx
	cpx	#disp_data+16
	bne	beg1
	ldx	#disp_data
beg1:	stx	xsave
                      	
	ldaa	pts+REGBLK
	rora
	rora
	rora			; rotate Ps2 into carry bit
	bcs	no_IR_light
    	ldx    	#YES_MSG	; yes_msg for line1
        ldab    #16             ; send out 16 characters
     	jsr	lcd_line2
     	jmp	wait
no_IR_light:
    	ldx    	#NO_MSG		; no_msg for line1
        ldab    #16             ; send out 16 characters
    	jsr	lcd_line2
;
;
wait:	tst	d1ms_flag
	beq	wait
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
;
digit0: 
	ldaa	disptn+3
	staa	portb,x
	tst	turn_led_on
	bne	dig0_on
	clr	portb,x
dig0_on:
	bclr	ptp,x,DIG0		; turn on digit 0
	bset	ptp,x,DIG1		; turn off all other digits
	bset	ptp,x,DIG2
	bset	ptp,x,DIG3
	rts
;
digit1: 
	ldaa	disptn+2
	staa	portb,x
	tst	turn_led_on
	bne	dig1_on
	clr	portb,x
dig1_on:
	bset	ptp,x,DIG0		
	bclr	ptp,x,DIG1		; turn on digi1
	bset	ptp,x,DIG2		; turn off all other digits
	bset	ptp,x,DIG3
	rts
;
digit2: 
	ldaa	disptn+1
	staa	portb,x
	tst	turn_led_on
	bne	dig2_on
	clr	portb,x
dig2_on:
	bset	ptp,x,DIG0		
	bset	ptp,x,DIG1	
	bclr	ptp,x,DIG2		; turn on digit 2
	bset	ptp,x,DIG3		; turn off all other digits
	rts
;
digit3: 
	ldaa	disptn
	staa	portb,x
	tst	turn_led_on
	bne	dig3_on
	clr	portb,x
dig3_on:
	bset	ptp,x,DIG0		
	bset	ptp,x,DIG1	
	bset	ptp,x,DIG2
	bclr	ptp,x,DIG3		; turn on digi3
	rts

spk_on:	
	pshx
	ldx	#REGBLK
	bclr 	tctl1,x OM5
	bset 	tctl1,x OL5		; toggle speaker
	pulx
	rts
spk_off:
	pshx
	ldx	#REGBLK
	bset 	tctl1,x OM5
	bclr 	tctl1,x OL5		; turn off speaker
	pulx
	rts

timer6:
	inc	count_5ms
	ldaa	count_5ms
	cmpa	#5
	bne	tmr3
	clr	count_5ms
;
; processing every 5ms
	ldaa	sound_start
	beq	tmr3
	ldaa	sound_dur		; duration
	deca
	staa	sound_dur
	bne	tmr3
	ldx	xsound_save
repeat:	ldab	0,x
	cmpb	#255
	beq	sound_end
	ldaa	1,x
	cmpa	#255
	beq	sound_end
	staa	sound_dur
	inx
	inx
	stx	xsound_save
	cmpb	#$fe
	bne	not_rest
	ldaa	#1
	staa	rest_note
	jsr	spk_off
	jmp	tmr3
not_rest:
	clr	rest_note
	jsr	spk_on
	ldx	#NOTE_TABLE
	aslb
	abx
	ldx	0,x
	stx	spk_tone
	jmp	tmr3	
sound_end:
	ldaa	sound_repeat
	beq	no_rep
	ldx	xsound_beg
	jmp	repeat

no_rep:	ldx	#F3500HZ	; 3.5kHz
	stx	spk_tone
	jsr	spk_off
	clr	sound_start

tmr3:	ldx	#REGBLK		; in interrupt servicing routine
	inc	d1ms_flag
	ldd	#TB1MS		; 1 ms time base
	addd	tc6,x
	std	tc6,x
	ldaa	#DB6
	staa	tflg1,x		; clear flag
	rti

timer5_spk:
	ldx	#REGBLK		; in interrupt servicing routine
	ldd	spk_tone
	addd	tc5,x
	std	tc5,x
	ldaa	#DB5
	staa	tflg1,x		; clear flag
	rti

start_sound:
	ldx	#SONG
	stx	xsound_beg
	ldaa	#1
	staa	sound_repeat
	ldab	0,x
	ldaa	1,x
	staa	sound_dur
	inx
	inx
	stx	xsound_save

	ldx	#NOTE_TABLE
	aslb
	abx
	ldx	0,x
	stx	spk_tone
	ldaa	#1
	staa	sound_start
	rts

SONG:	fcb	$20+note_e,dur18
	fcb	$20+note_ds,dur18
	fcb	$20+note_e,dur18
	fcb	$20+note_ds,dur18
	fcb	$20+note_e,dur18
	fcb	$10+note_b,dur18
	fcb	$20+note_d,dur18
	fcb	$20+note_c,dur18
	fcb	$10+note_a,dur14
;	fcb	$fe,dur18
;	fcb	255,255

	fcb	$00+note_e,dur18
	fcb	$00+note_a,dur18
	fcb	$10+note_c,dur18
	fcb	$10+note_e,dur18
	fcb	$10+note_a,dur18
	fcb	$10+note_b,dur14
	fcb	$00+note_gs,dur18
	fcb	$10+note_d,dur18
	fcb	$10+note_e,dur18
	fcb	$10+note_gs,dur18
	fcb	$10+note_b,dur18
	fcb	$20+note_c,dur14

	fcb	$00+note_e,dur18
	fcb	$00+note_a,dur18
	fcb	$10+note_e,dur18
	fcb	$fe,dur14
	fcb	255,255

	org	$3e62
	fdb	timer6
	org	$3e64
	fdb	timer5_spk

	end