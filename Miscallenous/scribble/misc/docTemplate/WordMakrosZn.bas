Attribute VB_Name = "WordMakrosZn"
' Word Makros Zimmermann
' Stand 27.05.2007

'#########################################################################
' Formeln mit Feldfunktionen
'#########################################################################
Public Sub FormelEinfügen()
'
' Formel einfügen (Voraussetzung für alle folgenden Makros
' Tastatur STRG-Umschalten-F
'
    WordBasic.ViewFieldCodes 1
    WordBasic.InsertFieldChars
    WordBasic.WW2_Insert "EQ "
End Sub
Public Sub FormelBruch()
'Bruchstrich in vorhandene Formel einfügen
' Tastatur STRG-Umschalten-B
    WordBasic.WW2_Insert "\f(;)"
End Sub
Public Sub FormelIntegral()
'Integral in vorhandene Formel einfügen
' Tastatur STRG-Umschalten-I
    WordBasic.WW2_Insert "\i(;;)"
End Sub
Public Sub FormelWurzel()
'Wurzel in vorhandene Formel einfügen
' Tastatur STRG-Umschalten-W
    WordBasic.WW2_Insert "\r()"
End Sub
Public Sub FormelSummenzeichen()
'Summenzeichen in vorhandene Formel einfügen
' Tastatur STRG-Umschalten-S
    WordBasic.WW2_Insert "\i\su(;;)"
End Sub
Public Sub FormelRahmen()
'Rahmen in vorhandene Formel einfügen
' Tastatur STRG-Umschalten-R
    WordBasic.WW2_Insert "\x()"
End Sub
Public Sub HöherStellen()
'Manueller Exponent
' Tastatur STRG-Umschalten-H
    WordBasic.FormatFont _
        Superscript:=1, Subscript:=0, Position:=Round(Selection.Font.Size * 0.25)      ' bei 16pt -> "+2 pt"

End Sub
Public Sub TieferStellen()
'Manuell Index
' Tastatur STRG-Umschalten-T
    WordBasic.FormatFont _
        Superscript:=0, Subscript:=1, Position:=-Round(Selection.Font.Size * 0.25) 'bei 16pt -> "-2 pt"
End Sub
Public Sub NormalStellen()
'Manuell Normalschrift
' Tastatur STRG-N
    WordBasic.FormatFont _
        Superscript:=0, Subscript:=0, Position:=0
End Sub

'#########################################################################
' Drucker
'#########################################################################
Sub HP()
' Drucker HP LJ 2100
    WordBasic.FilePrintSetup Printer:="HP LaserJet 2100 PCL6"
End Sub
Sub PDF()
' Drucker Adobe PDF
    WordBasic.FilePrintSetup Printer:="Adobe PDF"
End Sub
Sub postscript()
' Drucker HP Postcript
    WordBasic.FilePrintSetup Printer:="HP LaserJet 4/4M Plus PS"
End Sub
'#########################################################################
' Diverses
'#########################################################################
Sub EinfügenDesigner9Objekt()
' Einfügen Designer 9 Zeichnung als Embedded OLE Objekt
  Selection.InlineShapes.AddOLEObject ClassType:="Designer.Drawing.8", FileName:="", LinkToFile:=False, DisplayAsIcon:=False
End Sub
Sub EinfügenDesigner41Objekt()
' Einfügen Designer 4.1 Zeichnung als Embedded OLE Objekt
    WordBasic.InsertObject IconNumber:=0, FileName:="", Link:=0, DisplayIcon:=0, Tab:="0", Class:="MgxDesigner", IconFileName:="", Caption:="Designer 4.1 Zeichnung"
End Sub
Sub ZweiSeiten()
' Einstellen der Bildschirmdarstellung auf zwei Seiten nebeneinander
    With ActiveWindow.ActivePane.View.Zoom
        .PageColumns = 2
        .PageRows = 1
    End With
End Sub
'#########################################################################
' Zeilenabstand
'#########################################################################
Sub Zeile12pt()
' Zeilenabstand 12pt, 0pt vor, 0pt nach
    WordBasic.FormatParagraph Before:="0 pt", After:="0 pt", LineSpacingRule:=wdLineSpaceExactly, LineSpacing:="12 pt"
End Sub
Sub Zeile9pt()
' Zeilenabstand 9pt, 0pt vor, 0pt nach
    WordBasic.FormatParagraph Before:="0 pt", After:="0 pt", LineSpacingRule:=wdLineSpaceExactly, LineSpacing:="9 pt"
End Sub
Sub Zeile6pt()
' Zeilenabstand 6pt, 0pt vor, 0pt nach
    WordBasic.FormatParagraph Before:="0 pt", After:="0 pt", LineSpacingRule:=wdLineSpaceExactly, LineSpacing:="6 pt"
End Sub
'#########################################################################
' Schriftart
'#########################################################################
Sub Courier()
'Setze Schriftart Courier
' Tastatur STRG-Umschalten-C
    WordBasic.Font "Courier New"
End Sub
Sub GriechischesZeichen()
'Setze Schriftart Symbol
' Tastatur STRG-Umschalten-G
    WordBasic.Font "Symbol"
End Sub
Sub LateinischeZeichen()
'Setze Schriftart Univers
' Tastatur STRG-Umschalten-N
    WordBasic.Font "Univers"
End Sub
'#########################################################################
' Schriftfarben
'#########################################################################
Sub Auto()
' Setzt markierten Text auf automatische Farbe (d.h. Schwarz)
    WordBasic.FormatFont color:=0
End Sub
Sub Rot()
' Setzt markierten Text auf Farbe Rot
    WordBasic.FormatFont color:=6
End Sub
Sub Blau()
' Setzt markierten Text auf Farbe Blau
    WordBasic.FormatFont color:=2
End Sub
Sub Grün()
' Setzt markierten Text auf Farbe Grün
    WordBasic.FormatFont color:=11
End Sub
Sub Magenta()
' Setzt markierten Text auf Farbe Magenta
    WordBasic.FormatFont color:=5
End Sub
Sub ShadeIt(shadeColor)
    For Each w In ActiveDocument.Words
        If w.Font.color = wdColorWhite Then
'           w.Font.Shading.BackgroundPatternColorIndex = shadeColor
            w.Select
            Selection.Range.HighlightColorIndex = shadeColor
        End If
    Next
End Sub

'#########################################################################
' Automatisches Entfernen (=Umwandeln in weiss) von farbigem Text und umgekehrt
'#########################################################################
Public Sub Rot2Weiss()
' Umwandeln von farbigem Text (rot, blau, grün, magenta) in weiss
    
    rc = MsgBox("Alle Farben (Yes) oder nur rot (No)", vbYesNo)
    ' weiß/strichpunktiert unterstrichen <- rot/beliebig unterstrichen
    Selection.Find.ClearFormatting
    Selection.Find.Replacement.ClearFormatting
    With Selection.Find
        .ClearFormatting
        .Text = ""
        .Font.color = wdColorRed
        .Replacement.Text = ""
        .Replacement.Font.color = wdColorWhite
        .Replacement.Font.Underline = wdUnderlineDotDash
        .Replacement.Font.UnderlineColor = wdColorWhite
        .Replacement.Font.DoubleStrikeThrough = True
        .Format = True
        .MatchCase = False
        .MatchWholeWord = False
        .MatchWildcards = False
        .MatchSoundsLike = False
        .MatchAllWordForms = False
        .Forward = True
        .Wrap = wdFindContinue
    End With
    Selection.Find.Execute Replace:=wdReplaceAll
    '
    '  weiß/gestrichelt unterstrichen   <- blau/beliebig unterstrichen
    If (rc = vbYes) Then
        Selection.Find.ClearFormatting
        Selection.Find.Replacement.ClearFormatting
        With Selection.Find
            .ClearFormatting
            .Text = ""
            .Font.color = wdColorBlue
            .Replacement.Text = ""
            .Replacement.Font.color = wdColorWhite
            .Replacement.Font.Underline = wdUnderlineDashed
            .Replacement.Font.UnderlineColor = wdColorWhite
            .Replacement.Font.DoubleStrikeThrough = True
            .Format = True
            .MatchCase = False
            .MatchWholeWord = False
            .MatchWildcards = False
            .MatchSoundsLike = False
            .MatchAllWordForms = False
            .Forward = True
            .Wrap = wdFindContinue
        End With
        Selection.Find.Execute Replace:=wdReplaceAll
    End If
    '
    '  weiß/doppelt unterstrichen   <- gruen/beliebig unterstrichen
    If (rc = vbYes) Then
        Selection.Find.ClearFormatting
        Selection.Find.Replacement.ClearFormatting
        With Selection.Find
            .ClearFormatting
            .Text = ""
            .Font.color = wdColorGreen
            .Replacement.Text = ""
            .Replacement.Font.color = wdColorWhite
            .Replacement.Font.Underline = wdUnderlineDouble
            .Replacement.Font.UnderlineColor = wdColorWhite
            .Replacement.Font.DoubleStrikeThrough = True
           .Format = True
           .MatchCase = False
           .MatchWholeWord = False
           .MatchWildcards = False
           .MatchSoundsLike = False
           .MatchAllWordForms = False
           .Forward = True
           .Wrap = wdFindContinue
        End With
        Selection.Find.Execute Replace:=wdReplaceAll
    End If
    '
    '  weiß/punktiert unterstrichen <- magenta/beliebig unterstrichen
    If (rc = vbYes) Then
        Selection.Find.ClearFormatting
        Selection.Find.Replacement.ClearFormatting
       With Selection.Find
            .ClearFormatting
            .Text = ""
           .Font.color = wdColorPink
            .Replacement.Text = ""
            .Replacement.Font.color = wdColorWhite
            .Replacement.Font.Underline = wdUnderlineDotted
            .Replacement.Font.UnderlineColor = wdColorWhite
            .Replacement.Font.DoubleStrikeThrough = True
           .Format = True
           .MatchCase = False
           .MatchWholeWord = False
          .MatchWildcards = False
           .MatchSoundsLike = False
           .MatchAllWordForms = False
           .Forward = True
           .Wrap = wdFindContinue
       End With
       Selection.Find.Execute Replace:=wdReplaceAll
    End If
    
    'Weissen Text mit weissem Hintergrund versehen
    rc = MsgBox("Hintergrund weiss machen?", vbYesNo)
    If (rc = vbYes) Then
        ShadeIt (wdWhite)
'       ActiveDocument.Range.Shading.ForegroundPatternColor = wdColorWhite
    End If
    MsgBox ("Done Rot2Weiss")
End Sub
Public Sub Weiss2Rot()
' Umwandeln von weissem Text (mit verschiedenen Unterstreichungsattributen in farbigem Text
    
    'Weissen Text mit transparentem Hintergrund versehen
    rc = MsgBox("Hintergrund transparent machen?", vbYesNo)
    If (rc = vbYes) Then
        ShadeIt (wdNoHighlight)
    End If
    
    ' weiß/strichpunktiert unterstrichen -> rot/beliebig unterstrichen
    Selection.Find.ClearFormatting
    Selection.Find.Replacement.ClearFormatting
    With Selection.Find
        .ClearFormatting
        .Text = ""
        .Font.Underline = wdUnderlineDotDash
        .Font.color = wdColorWhite
        .Replacement.Text = ""
        .Replacement.Font.color = wdColorRed
        .Replacement.Font.Underline = wdUnderlineNone
        .Replacement.Font.DoubleStrikeThrough = False
        .Format = True
        .MatchCase = False
        .MatchWholeWord = False
        .MatchWildcards = False
        .MatchSoundsLike = False
        .MatchAllWordForms = False
        .Forward = True
        .Wrap = wdFindContinue
    End With
    Selection.Find.Execute Replace:=wdReplaceAll
    '
    '  weiß/gestrichelt unterstrichen   -> blau/beliebig unterstrichen
    Selection.Find.ClearFormatting
    Selection.Find.Replacement.ClearFormatting
    With Selection.Find
        .ClearFormatting
        .Text = ""
        .Font.color = wdColorWhite
        .Font.Underline = wdUnderlineDashed
        .Replacement.Text = ""
        .Replacement.Font.color = wdColorBlue
        .Replacement.Font.Underline = wdUnderlineNone
        .Replacement.Font.DoubleStrikeThrough = False
        .Format = True
        .MatchCase = False
        .MatchWholeWord = False
        .MatchWildcards = False
        .MatchSoundsLike = False
        .MatchAllWordForms = False
        .Forward = True
        .Wrap = wdFindContinue
    End With
    Selection.Find.Execute Replace:=wdReplaceAll
    '
    '  weiß/doppelt unterstrichen   -> gruen/beliebig unterstrichen
    Selection.Find.ClearFormatting
    Selection.Find.Replacement.ClearFormatting
    With Selection.Find
        .ClearFormatting
        .Text = ""
        .Font.color = wdColorWhite
        .Font.Underline = wdUnderlineDouble
        .Replacement.Text = ""
        .Replacement.Font.color = wdColorGreen
        .Replacement.Font.Underline = wdUnderlineNone
        .Replacement.Font.DoubleStrikeThrough = False
        .Format = True
        .MatchCase = False
        .MatchWholeWord = False
        .MatchWildcards = False
        .MatchSoundsLike = False
        .MatchAllWordForms = False
        .Forward = True
        .Wrap = wdFindContinue
    End With
    Selection.Find.Execute Replace:=wdReplaceAll
    '
    '  weiß/punktiert unterstrichen -> magenta/beliebig unterstrichen
    Selection.Find.ClearFormatting
    Selection.Find.Replacement.ClearFormatting
    With Selection.Find
        .ClearFormatting
        .Text = ""
        .Font.color = wdColorWhite
        .Font.Underline = wdUnderlineDotted
        .Replacement.Text = ""
        .Replacement.Font.color = wdColorPink
        .Replacement.Font.Underline = wdUnderlineNone
        .Replacement.Font.DoubleStrikeThrough = False
        .Format = True
        .MatchCase = False
        .MatchWholeWord = False
        .MatchWildcards = False
        .MatchSoundsLike = False
        .MatchAllWordForms = False
        .Forward = True
        .Wrap = wdFindContinue
    End With
    Selection.Find.Execute Replace:=wdReplaceAll

    MsgBox ("Done Weiss2Rot")
End Sub
'Umwandeln von magenta Text in weissen Text
Sub Magenta2Weiss()
    '  weiß/punktiert unterstrichen <- magenta/beliebig unterstrichen
    WordBasic.EditFindClearFormatting
    WordBasic.EditFindFont Points:="", Underline:=-1, color:=5, StrikeThrough:=-1, Superscript:=-1, Subscript:=-1, Hidden:=-1, SmallCaps:=-1, AllCaps:=-1, Spacing:="", Position:="", Kerning:=-1, KerningMin:="", Tab:="0", Font:="(normaler Text)", Bold:=-1, Italic:=-1
    WordBasic.EditReplaceClearFormatting
    WordBasic.EditReplaceFont Points:="", Underline:=4, color:=8, StrikeThrough:=-1, Superscript:=-1, Subscript:=-1, Hidden:=-1, SmallCaps:=-1, AllCaps:=-1, Spacing:="", Position:="", Kerning:=-1, KerningMin:="", Tab:="0", Font:="(normaler Text)", Bold:=-1, Italic:=-1
    WordBasic.EditReplace Find:="", Replace:="", Direction:=0, MatchCase:=0, WholeWord:=0, PatternMatch:=0, SoundsLike:=0, ReplaceAll:=1, Format:=1, Wrap:=1
End Sub
'#########################################################################
' Markieren von Formeln und Bildern
'#########################################################################
'Farbdefinition für unsichtbaren Text (Weiss = RGB(255,255,255))
Function GETWEISS()
    GETWEISS = RGB(255, 255, 255)
End Function
'Farbdefinition für sichtbaren Bild und Formelhintergrund (Flieder = RGB(255,204,255))
Function GETFLIEDER()
    GETFLIEDER = RGB(255, 204, 255)
End Function
'Farbdefinition für unsichtbaren Bild und Formelhintergrund (Creme = RGB(255, 255, 204))
Function GETCREME()
    GETCREME = RGB(254, 254, 254)
End Function
Sub MarkiereFormel()
' Markiere eine Formel oder ein Bild mit Flieder
    Selection.InlineShapes(1).Fill.Visible = msoTrue
    Selection.InlineShapes(1).Fill.Solid
    Selection.InlineShapes(1).Fill.ForeColor.RGB = GETFLIEDER
    Selection.InlineShapes(1).Fill.Transparency = 0#
End Sub
Sub EntmarkiereFormel()
' Entferne die Markierung von einer Formel oder einem Bild
    Selection.InlineShapes(1).Fill.Visible = msoFalse
    Selection.InlineShapes(1).Fill.Solid
    Selection.InlineShapes(1).Fill.ForeColor.RGB = GETWEISS
    Selection.InlineShapes(1).Fill.Transparency = 0#
End Sub
Sub FindeMarkierteBilder()
Attribute FindeMarkierteBilder.VB_Description = "Dies ist mein"
Attribute FindeMarkierteBilder.VB_ProcData.VB_Invoke_Func = "Normal.WordMakrosZn.FindeMarkierteBilder"
' Finde markierte Formeln und Bilder
    
    h = MsgBox("Hintergrundfarbe der markieren Bilder ändern: ?", vbYesNo)
    If (h = vbYes) Then
        f = MsgBox("Neue Farbe: yes=Flieder   no=creme?", vbYesNo)
    End If
    
    For Each s In ActiveDocument.InlineShapes
'       s.Select
'       MsgBox s.Type  ', , s.OLEFormat.ProgID
        If (s.Type = msoAutoShape) Or (s.Type = wdInlineShapeLinkedOLEObject) Then 'Falls es sich um ein eingebettes Objekt ...
            If s.OLEFormat.ClassType = "Designer.Drawing.8" Then   '... Micrografx Designers
                s.Select
                If s.Fill.ForeColor.RGB = GETFLIEDER Or s.Fill.ForeColor.RGB = GETCREME Then '... mit Flieder- oder Creme-Hintergrund handelt
                    s.Select                                        'Bild auswählen
                    i = MsgBox("Bild gefunden, öffnen?", vbYesNo)
                    If (i = vbYes) Then
'                       s.OLEFormat.Open                            'und zum Öffnen in Designer anbieten
                        s.OLEFormat.DoVerb VerbIndex:=1
'                       s.Fill.ForeColor.RGB = GETCREME
                    End If
                    If (h = vbYes) Then                             'Hintergrundfarbe ändern?
                        If (f = vbYes) Then
                            s.Fill.ForeColor.RGB = GETFLIEDER
                        Else
                            s.Fill.ForeColor.RGB = GETCREME
                        End If
                    End If
                End If
            End If
        End If
    Next
End Sub


'#########################################################################
' Verschiedene Makros für Bussysteme in der Fahrzeugtechnik
'#########################################################################
' 2pt Abstand vor/nach Absatz
Sub Format2vor2nach()
Attribute Format2vor2nach.VB_Description = "Makro aufgezeichnet am 26.12.2005 von Prof. Dr.-Ing. Werner Zimmermann"
Attribute Format2vor2nach.VB_ProcData.VB_Invoke_Func = "Normal.NewMacros.Format2vor"
    With Selection.ParagraphFormat
        .SpaceBefore = 2
        .SpaceBeforeAuto = False
        .SpaceAfter = 2
        .SpaceAfterAuto = False
    End With
End Sub
' 2pt Abstand vor, 0pt nach Absatz
Sub Format2vor0nach()
    With Selection.ParagraphFormat
        .SpaceBefore = 2
        .SpaceBeforeAuto = False
        .SpaceAfter = 0
        .SpaceAfterAuto = False
    End With
End Sub
' 0pt Abstand vor, 2pt nach Absatz
Sub Format0vor2nach()
    With Selection.ParagraphFormat
        .SpaceBefore = 0
        .SpaceBeforeAuto = False
        .SpaceAfter = 2
        .SpaceAfterAuto = False
    End With
End Sub
' 0pt Abstand vor, 0pt nach Absatz
Sub Format0vor0nach()
    With Selection.ParagraphFormat
        .SpaceBefore = 0
        .SpaceBeforeAuto = False
        .SpaceAfter = 0
        .SpaceAfterAuto = False
    End With
End Sub
' Rahmenlinien in einer Tabelle mit 0.5pt
Sub TabelleRahmen()
Attribute TabelleRahmen.VB_Description = "Makro aufgezeichnet am 28.12.2005 von Prof. Dr.-Ing. Werner Zimmermann"
Attribute TabelleRahmen.VB_ProcData.VB_Invoke_Func = "Normal.NewMacros.TabelleRahmen"
    Selection.Tables(1).Select
    With Selection.Tables(1)
        With .Borders(wdBorderLeft)
            .LineStyle = wdLineStyleSingle
            .LineWidth = wdLineWidth050pt
            .color = wdColorAutomatic
        End With
        With .Borders(wdBorderRight)
            .LineStyle = wdLineStyleSingle
            .LineWidth = wdLineWidth050pt
            .color = wdColorAutomatic
        End With
        With .Borders(wdBorderTop)
            .LineStyle = wdLineStyleSingle
            .LineWidth = wdLineWidth050pt
            .color = wdColorAutomatic
        End With
        With .Borders(wdBorderBottom)
            .LineStyle = wdLineStyleSingle
            .LineWidth = wdLineWidth050pt
            .color = wdColorAutomatic
        End With
        With .Borders(wdBorderHorizontal)
            .LineStyle = wdLineStyleSingle
            .LineWidth = wdLineWidth050pt
            .color = wdColorAutomatic
        End With
        With .Borders(wdBorderVertical)
            .LineStyle = wdLineStyleSingle
            .LineWidth = wdLineWidth050pt
            .color = wdColorAutomatic
        End With
        .Borders(wdBorderDiagonalDown).LineStyle = wdLineStyleNone
        .Borders(wdBorderDiagonalUp).LineStyle = wdLineStyleNone
        .Borders.Shadow = False
    End With
    With Options
        .DefaultBorderLineStyle = wdLineStyleSingle
        .DefaultBorderLineWidth = wdLineWidth050pt
        .DefaultBorderColor = wdColorAutomatic
    End With
End Sub
'#########################################################################
' Diverses
'#########################################################################
' Umwandlung Zahlen in Buchstaben (für Indexe in Vorlesungsmanuskripten)
Public Sub IndexZahl2Buchstabe()
    WordBasic.EditReplace Find:="1-", Replace:="A-", Direction:=0, MatchCase:=0, WholeWord:=0, PatternMatch:=0, SoundsLike:=0, ReplaceAll:=1, Format:=0, Wrap:=2
    WordBasic.EditReplace Find:="2-", Replace:="B-", Direction:=0, MatchCase:=0, WholeWord:=0, PatternMatch:=0, SoundsLike:=0, ReplaceAll:=1, Format:=0, Wrap:=2
    WordBasic.EditReplace Find:="3-", Replace:="C-", Direction:=0, MatchCase:=0, WholeWord:=0, PatternMatch:=0, SoundsLike:=0, ReplaceAll:=1, Format:=0, Wrap:=2
    WordBasic.EditReplace Find:="4-", Replace:="D-", Direction:=0, MatchCase:=0, WholeWord:=0, PatternMatch:=0, SoundsLike:=0, ReplaceAll:=1, Format:=0, Wrap:=2
    WordBasic.EditReplace Find:="5-", Replace:="E-", Direction:=0, MatchCase:=0, WholeWord:=0, PatternMatch:=0, SoundsLike:=0, ReplaceAll:=1, Format:=0, Wrap:=2
    WordBasic.EditReplace Find:="6-", Replace:="F-", Direction:=0, MatchCase:=0, WholeWord:=0, PatternMatch:=0, SoundsLike:=0, ReplaceAll:=1, Format:=0, Wrap:=2
    WordBasic.EditReplace Find:="7-", Replace:="G-", Direction:=0, MatchCase:=0, WholeWord:=0, PatternMatch:=0, SoundsLike:=0, ReplaceAll:=1, Format:=0, Wrap:=2
    WordBasic.EditReplace Find:="8-", Replace:="H-", Direction:=0, MatchCase:=0, WholeWord:=0, PatternMatch:=0, SoundsLike:=0, ReplaceAll:=1, Format:=0, Wrap:=2
    WordBasic.EditReplace Find:="9-", Replace:="I-", Direction:=0, MatchCase:=0, WholeWord:=0, PatternMatch:=0, SoundsLike:=0, ReplaceAll:=1, Format:=0, Wrap:=2
    WordBasic.EditReplace Find:="10-", Replace:="K-", Direction:=0, MatchCase:=0, WholeWord:=0, PatternMatch:=0, SoundsLike:=0, ReplaceAll:=1, Format:=0, Wrap:=2
End Sub

