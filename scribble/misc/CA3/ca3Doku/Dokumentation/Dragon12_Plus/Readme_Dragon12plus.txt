Die Dateien im Verzeichnis Dragon12_Plus beziehen sich auf das Dragon12 Plus Board. 
Dieses Board hat ein anderes Platinenlayout und eine unterschiedliche 
Platinenbestückung.

Der Hauptunterschied besteht in der Taktfrequenz. Das Dragon12 Plus Board 
arbeitet mit einer Quarzfrequenz f_OSCCLK=8MHz, während das "alte" Dragon12- 
Board f_OSCCLK=4MHz verwendet. Daher muss das Board mit einem angepassten Serial 
Monitor betrieben werden (siehe Datei S12SerMon2r0_8MHzHE.s19 und Anleitung in 
PatchDragonToSerialMonitor.pdf im Unterverzeichnis ./SerialMonitor).

Bei den Boards im Hochschullabor ist der korrekte Serial Monitor bereits 
geladen. 

--------------------------------------------------------------------------

Auf dem Board befindet sich ein HCS12 des Typs 9S12DG256, der sich in Details 
bei den Peripheriekomponenten von dem auf dem "alten" Dragon12-Board 
befindlichen Typ 9S12DP256B unterscheidet. Für die Vorlesung CA3 spielen diese 
Details KEINE Rolle.

Zimmermann
18 Feb. 2008

