MsgBoxGui(Title, Text, Timeout:=0, GuiName:="") {
   global TextBox                       ; This variable can be used to update the text in the MsgBoxGui
   static WhiteBox
   
   static Gap          := 26            ; Spacing above and below text in top area of the Gui
   static LeftMargin   := 12            ; Left Gui margin
   static RightMargin  := 8             ; Space between right side of button and right Gui edge
   static ButtonWidth  := 88            ; Width of OK button
   static ButtonHeight := 26            ; Height of OK button
   static ButtonOffset := 30            ; Offset between the right side of text and right edge of button
   static MinGuiWidth  := 138           ; Minimum width of Gui
   static SS_WHITERECT := 0x0006        ; Gui option for white rectangle (http://ahkscript.org/boards/viewtopic.php?p=20053#p20053)

   BottomGap := LeftMargin                      ; Set the distance between the bottom of the white box and the top of the OK button
   BottomHeight := ButtonHeight+2*BottomGap+3   ; Calculate the height of the bottom section of the Gui
   if !GetMsgBoxFontInfo(FontName,FontSize,FontWeight,IsFontItalic)             ; Get the MsgBox font information
      Return false                                                              ; If there is a problem getting the font information, return false
   GuiOptions := "s" FontSize " w" FontWeight (IsFontItalic ? " italic" : "")   ; Define a string with the Gui options
   Gui, %GuiName%Font, %GuiOptions%, %FontName%                                          ; Set the font options and name
   Gui, +LastFound +ToolWindow -MinimizeBox -MaximizeBox                        ; Set the Gui so it doesn't have an icon or the minimize and maximize buttons
   Gui, %GuiName%Add, Text, x0 y0 %SS_WHITERECT% vWhiteBox                               ; Add a white box at the top of the window
   if Text                                                                      ; If the text field is not blank ...
   {  Gui, %GuiName%Add, Link, x%LeftMargin% y%Gap% BackgroundTrans vTextBox, %Text%     ; Add the text to the Gui allowing for any links in it
      GuiControlGet, Size, Pos, TextBox                                         ; Get the position of the text box
      GuiWidth := LeftMargin+SizeW+ButtonOffset+RightMargin+1                   ; Calculate the Gui width
      GuiWidth := GuiWidth < MinGuiWidth ? MinGuiWidth : GuiWidth               ; Make sure that it's not smaller than MinGuiWidth
      WhiteBoxHeight := SizeY+SizeH+Gap                                         ; Calculate the height of the white box
   }
   else                                                                         ; If the text field is blank ...
   {  GuiWidth := MinGuiWidth                                                   ; Set the width of the Gui to MinGuiWidth
      WhiteBoxHeight := 2*Gap+1                                                 ; Set the height of the white box
      BottomGap++                                                               ; Increase the gap above the button by one
      BottomHeight--                                                            ; Decrease the height of the bottom section of the Gui
   }
   GuiControl, %GuiName%Move, WhiteBox, w%GuiWidth% h%WhiteBoxHeight%   ; Adjust the width and height of the white box
   ButtonX := GuiWidth-RightMargin-ButtonWidth                 ; Calculate the horizontal position of the button
   ButtonY := WhiteBoxHeight+BottomGap                         ; Calculate the vertical position of the button
   Gui, %GuiName%Add, Button, x%ButtonX% y%ButtonY% w%ButtonWidth% h%ButtonHeight% Default, OK   ; Add the OK button
   GuiControl, %GuiName%Focus, OK                                       ; Sets keyboard focus to the OK button
   GuiHeight := WhiteBoxHeight+BottomHeight                    ; Calculate the overall height of the Gui
   Gui, %GuiName%Show, w%GuiWidth% h%GuiHeight%, %Title%                ; Show the Gui
   Gui, -ToolWindow                                            ; Remove the ToolWindow option so that the Gui has rounded corners and no icon
                                                               ; Trick from http://ahkscript.org/boards/viewtopic.php?p=11519#p11519
   if Timeout                                                  ; If the Timeout parameter has been specified ...
      SetTimer, GuiClose, % -Timeout*1000                      ; Start a timer to destroy the MsgBoxGui after Timeout seconds
   Return true

   ButtonOK:
   GuiClose:
   GuiEscape:
   Gui Destroy
   Return
}

; Reference: http://ahkscript.org/boards/viewtopic.php?f=6&t=9122

GetMsgBoxFontInfo(ByRef Name:="", ByRef Size:=0, ByRef Weight:=0, ByRef IsItalic:=0) {
   ; SystemParametersInfo constant for retrieving the metrics associated with the nonclient area of nonminimized windows
   static SPI_GETNONCLIENTMETRICS := 0x0029
   
   static NCM_Size        := 40 + 5*(A_IsUnicode ? 92 : 60)   ; Size of NONCLIENTMETRICS structure (not including iPaddedBorderWidth)
   static MsgFont_Offset  := 40 + 4*(A_IsUnicode ? 92 : 60)   ; Offset for lfMessageFont in NONCLIENTMETRICS structure
   static Size_Offset     := 0    ; Offset for cbSize in NONCLIENTMETRICS structure
   
   static Height_Offset   := 0    ; Offset for lfHeight in LOGFONT structure
   static Weight_Offset   := 16   ; Offset for lfWeight in LOGFONT structure
   static Italic_Offset   := 20   ; Offset for lfItalic in LOGFONT structure
   static FaceName_Offset := 28   ; Offset for lfFaceName in LOGFONT structure
   static FACESIZE        := 32   ; Size of lfFaceName array in LOGFONT structure
                                  ; Maximum number of characters in font name string
   
   VarSetCapacity(NCM, NCM_Size, 0)              ; Set the size of the NCM structure and initialize it
   NumPut(NCM_Size, &NCM, Size_Offset, "UInt")   ; Set the cbSize element of the NCM structure
   ; Get the system parameters and store them in the NONCLIENTMETRICS structure (NCM)
   if !DllCall("SystemParametersInfo"            ; If the SystemParametersInfo function returns a NULL value ...
             , "UInt", SPI_GETNONCLIENTMETRICS
             , "UInt", NCM_Size
             , "Ptr", &NCM
             , "UInt", 0)                        ; Don't update the user profile
      Return false                               ; Return false
   Name   := StrGet(&NCM + MsgFont_Offset + FaceName_Offset, FACESIZE)          ; Get the font name
   Height := NumGet(&NCM + MsgFont_Offset + Height_Offset, "Int")               ; Get the font height
   Size   := DllCall("MulDiv", "Int", -Height, "Int", 72, "Int", A_ScreenDPI)   ; Convert the font height to the font size in points
   ; Reference: http://stackoverflow.com/questions/2944149/converting-logfont-height-to-font-size-in-points
   Weight   := NumGet(&NCM + MsgFont_Offset + Weight_Offset, "Int")             ; Get the font weight (400 is normal and 700 is bold)
   IsItalic := NumGet(&NCM + MsgFont_Offset + Italic_Offset, "UChar")           ; Get the italic state of the font
   Return true
}