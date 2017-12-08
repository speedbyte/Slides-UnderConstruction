;
; Test.asm ---  Test program for DRAGON12 board (c)2002, EVBplus.com
;		Written By Wayne Chu
;
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
;
;	4. Adjust the trimmer pot, the 7 segment LED display's brightness 
;	   should change. If you press any key on the keypad, the 7 segment
;	   display will display the key number that you pressed.
;		LCD display shows:	"TESTING IR LIGHT"
;                                       "NO OBJECT NEARBY"
;
;	5. Place your hand 6" from the IR transceiver, and to allow the IR
;	   light reflect. Both the RX LED and TX LED should be on, then observe
;	   the message on the LCD display. See IR_sen.asm for details.
;		LCD display shows:	"TESTING IR LIGHT"
;                                       " OBJECT DETECTED"
;
;
;   clock.asm -- An alarm clock example
;   registers.inc -- include register equates and memory map
;   Author - Tom Almy
;   Date - February 2003
;
;   NOTE - DIP Switches must be up (open)
;    Switch SW2 -- toggles alarm arming (indicated by right decimal point LED), also
;    stops the alarm (without disarming) if it is sounding. Also used to view alarm
;    time and (when held down) will allow setting the alarm time.
;    Switch SW3 -- Depress and hold while setting the time.
;    Switch SW4 -- In combination with SW2 sets the alarm hour and with SW3 sets 
;                  the time hour
;    Switch SW5 -- In combination with SW2 sets the alarm minute and with SW3 sets
;                  the alarm hour
; Setting the time minutes or hours will also reset the internal seconds counter to zero.
; The buttons are debounced and the hour/minute setting have auto-repeat every half second.
; The Left decimal point LED indicates "pm". The center decimal point LEDs flash once per
; second.
; The right decimal point LED indicates the alarm is armed.
;
;
; Kpad4X4.asm  keypad demo program for DRAGON12 board (c)2004, EVBplus.com
;		Written by Wayne Chu
;      Function: 	It scans a keypad and outputs the key number in binary
;		format on the PB0-PB4 LEDs
;
;     Instructions:
;     If you have a 4 x 4 keypad, connect it to the keypad header J29.
;
;	   If you press any key on the keypad, the LEDs should show
;	   the key number that you pressed in binary format. Key number 00
;	   is shown as $10.

; 500Hz.asm --- Square wave generator for DRAGON12 board (c)2002, EVBplus.com
;		Written by Wayne Chu
;
;     Function:	500 Hz square wave routine using output comparator 6
;		It generates a 500Hz square wave on PB0 LED (pin 24 of the MCU) and
;               a 2Hz square wave on PB7 LED (pin 31 of the MCU).
;
;
;
; 5s_delay.asm  5 second delay timer for DRAGON12 board (c)2002, EVBplus.com
;		Written by Wayne Chu
;
;     Function:	5 second delay routine using output comparator 6
;		The PB0 LED will be turned on immediately after running
;		this program. It will be turned off after 5 second delay.
;		Change the DELAY_TIME to 36000 will delay 3 minutes.
;
;
;
; Ex1.asm  ---- Example program 1 for DRAGON12 board (c)2002, EVBplus.com
;		Written by Wayne Chu
;
;     Function:	Reads the DIP switch via port H and displays its status
;		on port B LEDs PB0-PB7.
;
;	
; Ex2.asm  ---- Example program 2 for DRAGON12 board (c)2002, EVBplus.com
;		Written by Wayne Chu
;
;     Function:	Makes port B as a binary counter.
;
;
;
; Ex3.asm ----  Example program 3 for DRAGON12 board (c)2002, EVBplus.com
;		Written by Wayne Chu
;
;     Function:	Displays the word 'HELP' on the 7-segment LED display,
;		the 7-segment is multiplexed at 1ms per digit fresh rate,
;		250Hz fresh rate for 4 digits.
;
;
;
; Ex4.asm  ---- Example program 4 for DRAGON12 board (c)2002, EVBplus.com
;		Written by Wayne Chu
;
;     Function:	It displays the word 'SCAn" on the 7-segment LED display,
;   		scans a keypad and displays the key number on the
;		7-segment LED display if a key is down.
;
;
;
; Ex5.asm ----  Example program 5 for DRAGON12 board (c)2002, EVBplus.com
;		Written by Wayne Chu
;
;     Function:	User can adjust the trimmer pot VR2 to vary the voltage on 
;	 	the AN07 of ADC and to change brightness of the 7 segment
;		LED display
;
;
;
; Ex6.asm ----  Example program 6 for DRAGON12 board (c)2002, EVBplus.com
;		Written by Wayne Chu
;
;     Function:	Plays a song via timer5 (PT5)
;
;
;
;  IR_sen.asm - An IR proximity sensor for DRAGON12 board (c)2002, EVBplus.com
;		Written by Wayne Chu
;
;     Function:	A robot application by using IR light beam to detect
;		an object in its vicinity.
;		
;     Instruction: The PS3 will be set low to enable the IR transmitter.
;		   The IR light beam will be bounced back by an object, 
;		   so the IR receiver will receive the IR light via PS2 and 
;		   display the result on the LCD display module.
;		   
;		   Sometime the table surface can reflect the light.
;		   For the best result, place the board near the edge of the
;		   table to reduce the reflection by the table surface.
;		   Two small red LEDs near the IR transmitter and receiver
;		   will indicate their status.
;		   After running the program, make sure that
;		   the TX LED is on and the RX LED is off without an object
;		   in the front of them.  If your body is too close to them,
;		   it also will reflect the IR light, so stay 1 foot away 
;		   from them. When the RX LED is off, then put your hand
;		   in the front of them and read the message on the LCD display.
;
;		   The range is about 6-10 inches and can be increased by
;		   reducing the resister R11's value, but it should not be
;		   lower than 100 Ohm.
;
;
;
; LCD.asm ----- LCD sample program for DRAGON12 board (c)2002, EVBplus.com
;		written by Wayne Chu
;
;     Function:	This is the simplest way to displays a message on the
;		16X2 LCD display module. The cursor is off.
;
;     Instruction: Connect a 4 x 4 keypad to the keypad header J29.
;