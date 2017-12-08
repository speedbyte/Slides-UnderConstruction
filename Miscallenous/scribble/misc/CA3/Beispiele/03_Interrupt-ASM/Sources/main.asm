;****************************************************************
;* Dies ist ein kleines Beispielprogramm, um zu demonstrieren,  *
;* wie man in Assembler eine Interrupt-Serviceroutine schreibt. *
;*  																											      *
;* Autor: Joerg Friedrich                                       *
;* Copyright: FHT Esslingen                                     *
;* Letzte Aenderung: 25.9.2005                                  *
;****************************************************************

; Exportierte Symbole
            XDEF main, rtiISR
            ; wir benutzen 'Entry' als externes Symbol. Damit koennen
            ; wir in der Linker-Kommando-Datei "(Monitor_linker.prm fuer
            ; das Board, Simulator_linker.prm fuer den Simulator) den
            ; Reset-Vektor auf diese Stelle lenken oder dieses kleine
            ; Programm von einem C/C++-Programm aus aufrufen.

; wir lesen die speziellen Register-Definitionen und Makros
; fuer unseren Prozessortyp ein. Sie liegen im Include-Verzeichnis
; der Entwicklungsumgebung.

         INCLUDE 'mc9s12dp256.inc'

; wir schieben das Programm ins RAM, da wir genuegend Platz haben
; und das FLASH schonen wollen
PRSTART  EQU $2000

; -----------------------------------------------------------------------
; hier beginnt der Bereich für Variable und Konstanten
         ORG RAMStart  ; im Include definiert
			
zaehler: DS  2         ; Platz fuer einen Zaehler


; -----------------------------------------------------------------------
; hier beginnt das Hauptprogramm

       ORG PRSTART
main:									   ; Symbol ist auch in Monitor_linker.prm als
                         ; Reset-Vektor definiert
       LDS  #RAMEnd			 ; initialisiere Stack, Symbol ist in Include definiert
       MOVW #0, zaehler

       LDAA #$ff
       STAA DDRB         ; Data Direction Register B auf Ausgabe stellen
       STAA DDRP         ; Data Direction Register P auf Ausgabe stellen
       MOVB #$0f, PTP    ; alle LEDs ausschalten
       
       BSET DDRJ, #2
       BCLR PTJ, #2
       
       LDAA #1
       STAA PORTB

       MOVB #$7f, RTICTL ; setze RTI-Rate, wir haben einen 4 MHz-Oszillator
       BSET CRGINT, #$80 ; gib RTI frei
       CLI               ; Interrupt-Maskierung abschalten
       
mainLoop:
       WAI
       BRA  mainLoop

; ----------------------------------------------------------------------
; hier beginnt die Interrupt-Serviceroutine 
      
rtiISR:              
       BSET CRGFLG, #$80 ; setze das RTI Interrupt Flag zurueck
       NOP               ; kleiner Bug bei manchen HCS12 ?
       CLI               ; gib fuer andere Interrupts wieder frei
       LDAA PORTB        ; lade Port B
       EORA #1           ; negiere Bit 0  von Port B
       STAA PORTB				 ; schreibe zurueck
       
       ADDD #1           ; nur so zum Spass ein Zaehler
       STD  zaehler
       
       RTI               ; das war es auch schon
       

  
