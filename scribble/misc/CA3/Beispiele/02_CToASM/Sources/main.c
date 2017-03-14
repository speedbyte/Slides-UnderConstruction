/*
Ein einfaches C-Programm, um zwei Zahlen zu addieren

Autor: Joerg Friedrich
Copyright: FHT Esslingen
Letzte Aenderung: 5.9.2005 
*/

#include <hidef.h>           /* Einige Makros und Defines */
#include <mc9s12dp256.h>     /* Prozessorspezifischen Defin. */

#pragma LINK_INFO DERIVATIVE "mc9s12dp256b"

int main(void) {

  unsigned char register a, b, c;

  #define Bit0 (0x1)
  #define Bit1 (0x2)
  #define Bit2 (0x4)
  #define Bit3 (0x8)

  #define var1 *((unsigned char *) 0x3000)
  unsigned char var2;
  
  EnableInterrupts;  // Das brauchen wir fuer den Debugger
  


  var1 |= Bit2;  /* setze Bit 2 von var1 auf 1 */
  var1 &= ~Bit0; /* setze Bit 0 von var1 auf 0 */ 
  var1 ^= Bit1;  /* Toggle Bit 1 von var 1 */

  if (var1 & Bit3) {
    var2 = var1; /* nur wenn Bit 3 in var1 gesetzt ist */
  }

  /* extrahiere Bit 3 bis 6 von var1 und speicher in var2 */
  var2 = (var1 >> 3) & 0xff;
 
  return var2;
}

unsigned char minmax (unsigned char a, unsigned char b) {
 
 unsigned char c;
  if ( a < b ) {
    c = a;
  } 
  else {
    c = b;
  }
   
  return c; 
}

int factorial(n) {
  int factor = -1;
  if (n == 0) n = 1;
  if (n > 0 && n <= 8) {
    factor = 1;
    do {
	  factor = factor * n;
      n = n - 1; 
    } while ( n > 1 );
  }
  return factor;
}

int factorial2(n) {
  if (n == 0) return 1;
  if (n >= 1) {
	return (n * factorial2(n-1));
  }
}




