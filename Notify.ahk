/*
SetWorkingDir, %A_ScriptDir%
#SingleInstance,Force
Count:=0
; Notify:=Notify(20)
Notify:=New NotifyClass()
*/

/*
Eu modifiquei para vc poder definir HEIGHT/WIDTH da GUI/Notify
basta adicionar como ultimo parametro "w500 h500"
%guiSizeFelipe%

quero poder ajustar posição da gui tbm

IMPORTANTE:
; SysGet,Mon,MonitorWorkArea
; this.MonBottom:=MonBottom,this.MonTop:=MonTop,this.MonLeft:=MonLeft,this.MonRight:=MonRight
; https://www.autohotkey.com/docs/commands/SysGet.htm#MonitorWorkArea

IMPORTANTE: 
WinGetPos,x,y,w,h,% b.ID
WinSet
Olhar doc

*/

/*  
- Icons shell: 24, 23, 28, 44, 48, 110, 118, 131, 132, 145, 155, 177, 210, 209, 234, 238, 297, 321, 300
- 

*/
	; Notify(5).AddWindow("Testing",{Size: 15,Title:"Título", TitleSize:20, TitleColor:"#06131D", Icon: 300, Iconsize: 25, Time:5000, Background:"#06131D",Color:"0xFF0000",Radius:40, Animate:"Blend", ShowDelay:1500}, "", "setPosBR")


/*
	Usage:
	Notify:=Notify()
	Window:=Notify.AddWindow("Your Text Here",{Icon:4,Background:"0xAA00AA"})
	|---Window ID                                          |--------Options
	Options:
	
	Window ID will be used when making calls to Notify.SetProgress(Window,ProgressValue)
	
	Animate: Ways that the window will animate in eg. {Animate:""} Can be Bottom, Top, Left, Right, Slide, Center, or Blend (Some work together, and some override others)
	Background: Color value in quotes eg. {Background:"0xAA00AA"}
	Buttons: Comma Delimited list of names for buttons eg. {Buttons:"One,Two,Three"}
	Color: Font color eg.{Color:"0xAAAAAA"}
	Destroy: Comma Delimited list of Bottom, Top, Left, Right, Slide, Center, or Blend
	Flash: Flashes the background of the notification every X ms eg. {Flash:1000}
	FlashColor: Sets the second color that your notification will change to when flashing eg. {FlashColor:"0xFF00FF"}
	Font: Face of the message font eg. {Font:"Consolas"}
	Icon: Can be either an Integer to pull an icon from Shell32.dll or a full path to an EXE or full path to a dll.  You can add a comma and an integer to select an icon from within that file eg. {Icon:"C:\Windows\HelpPane.exe,2"}
	IconSize: Width and Height of the Icon eg. {IconSize:20}
	Hide: Comma Separated List of Directions to Hide the Notification eg. {Hide:"Left,Top"}
	Progress: Adds a progress bar eg. {Progress:10} ;Starts with the progress set to 10%
	Radius: Size of the border radius eg. {Radius:10}
	Size: Size of the message text eg {Size:20}
	ShowDelay: Time in MS of how long it takes to show the notification
	Sound: Plays either a beep if the item is an integer or the sound file if it exists eg. {Sound:500}
	Time: Sets the amount of time that the notification will be visible eg. {Time:2000}
	Title: Sets the title of the notification eg. {Title:"This is my title"}
	TitleColor: Title font color eg. {TitleColor:"0xAAAAAA"}
	TitleFont: Face of the title font eg. {TitleFont:"Consolas"}
	TitleSize: Size of the title text eg. {TitleSize:12}
*/

;Actual code starts here
Notify(Margin:=0){
	static Notify:=New NotifyClass()
	Notify.Margin:=Margin
	return Notify
}

Class NotifyClass{
	__New(Margin:=10){
		this.ShowDelay:=40,this.ID:=0,this.Margin:=Margin,this.Animation:={Bottom:0x00000008,Top:0x00000004,Left:0x00000001,Right:0x00000002,Slide:0x00040000,Center:0x00000010,Blend:0x00080000}
		if(!this.Init)
			OnMessage(0x201,NotifyClass.Click.Bind(this)),this.Init:=1
   ; adicionar argumentos obrigatórios da GUI      
	}AddWindow(Text,Info:="",guiSizeFelipe:="",posicaoGuiFelipe:="setPosBR"){
		(Info?Info:Info:=[])
		for a,b in {Background:0,Color:"0xAAAAAA",TitleColor:"0xAAAAAA",Font:"Consolas",TitleSize:12,TitleFont:"Consolas",Size:20,Font:"Consolas",IconSize:20}
			if(Info[a]="")
				Info[a]:=b
		if(!IsObject(Win:=NotifyClass.Windows))
			Win:=NotifyClass.Windows:=[]
		Hide:=0
		for a,b in StrSplit(Info.Hide,",")
			if(Val:=this.Animation[b])
				Hide|=Val
		Info.Hide:=Hide
		DetectHiddenWindows,On
		this.Hidden:=Hidden:=A_DetectHiddenWindows,this.Current:=ID:=++this.ID,Owner:=WinActive("A")
 		Gui,Win%ID%:Default
		if(Info.Radius)
			Gui,Margin,% Floor(Info.Radius/3),% Floor(Info.Radius/3)
		Gui,-Caption +HWNDMain +AlwaysOnTop +Owner%Owner%
		Gui,Color,% Info.Background,% Info.Background
		NotifyClass.Windows[ID]:={ID:"ahk_id" Main,HWND:Main,Win:"Win" ID,Text:Text,Background:Info.Background,FlashColor:Info.FlashColor,Title:Info.Title,ShowDelay:Info.ShowDelay,Destroy:Info.Destroy}
		for a,b in Info
			NotifyClass.Windows[ID,a]:=b
		if((Ico:=StrSplit(Info.Icon,",")).1)
			Gui,Add,Picture,% (Info.IconSize?"w" Info.IconSize " h" Info.IconSize:""),% "HBITMAP:" LoadPicture(Foo:=(Ico.1+0?"Shell32.dll":Ico.1),Foo1:="Icon" (Ico.2!=""?Ico.2:Info.Icon),2)
		if(Info.Title){
			Gui,Font,% "s" Info.TitleSize " c" Info.TitleColor,% Info.TitleFont
			Gui,Add,Text,x+m,% Info.Title
		}Gui,Font,% "s" Info.Size " c" Info.Color,% Info.Font
		Gui,Add,Text, %guiSizeFelipe% %setCenter% HWNDText,%Text%
		SysGet,Mon,MonitorWorkArea
		if(Info.Sound+0)
			SoundBeep,% Info.Sound
		if(FileExist(Info.Sound))
			SoundPlay,% Info.Sound
		this.MonBottom:=MonBottom,this.MonTop:=MonTop,this.MonLeft:=MonLeft,this.MonRight:=MonRight
		if(Info.Time){
			TT:=this.Dismiss.Bind({this:this,ID:ID})
			SetTimer,%TT%,% "-" Info.Time
		}if(Info.Flash){
			TT:=this.Flash.Bind({this:this,ID:ID})
			SetTimer,%TT%,% Info.Flash
			NotifyClass.Windows[ID].Timer:=TT
		}
		for a,b in StrSplit(Info.Buttons,","){
			Gui,Margin,% Info.Radius?Info.Radius/2:5,5
			Gui,Font,s10
			Gui,Add,Button,% (a=1?"xm":"x+m"),%b%
		}
		if(Info.Progress!=""){
			Gui,Win%ID%:Font,s4
			ControlGetPos,x,y,w,h,,ahk_id%Text%
			Gui,Add,Progress,w%w% HWNDProgress,% Info.Progress
			NotifyClass.Windows[ID].Progress:=Progress
		}Gui,Win%ID%:Show,Hide
		WinGetPos,x,y,w,h,ahk_id%Main%
		if(Info.Radius)
			WinSet, Region, % "0-0 w" W " h" H " R" Info.Radius "-" Info.Radius,ahk_id%Main%
		Obj:=this.SetPos(posicaoGuiFelipe),Flags:=0
		for a,b in StrSplit(Info.Animate,",")
			Flags|=Round(this.Animation[b])
		DllCall("AnimateWindow","UInt",Main,"Int",(Info.ShowDelay?Info.ShowDelay:this.ShowDelay),"UInt",(Flags?Flags:0x00000008|0x00000004|0x00040000|0x00000002))
		for a,b in StrSplit((Obj.Destroy?Obj.Destroy:"Top,Left,Slide"),",")
			Flags|=Round(this.Animation[b])
		Flags|=0x00010000,NotifyClass.Windows[ID].Flags:=Flags
		DetectHiddenWindows,%Hidden%
		return ID
	}Click(){
		Obj:=NotifyClass.Windows[RegExReplace(A_Gui,"\D")],Obj.Button:=A_GuiControl,(Fun:=Func("Click"))?Fun.Call(Obj):"",this.Delete(A_Gui)
	}Delete(Win){
		Win:=RegExReplace(Win,"\D"),Obj:=NotifyClass.Windows[Win],NotifyClass.Windows.Delete(Win)
		if(WinExist("ahk_id" Obj.HWND)){
			DllCall("AnimateWindow","UInt",Obj.HWND,"Int",Obj.ShowDelay,"UInt",Obj.Flags)
			Gui,% Obj.Win ":Destroy"
		}if(TT:=Obj.Timer)
			SetTimer,%TT%,Off
		this.SetPos(posicaoGuiFelipe)
	}Dismiss(){
		this.this.Delete(this.ID)
	}Flash(){
		Obj:=NotifyClass.Windows[this.ID]
		Obj.Bright:=!Obj.Bright
		Color:=Obj.Bright?(Obj.FlashColor!=""?Obj.FlashColor:Format("{:06x}",Obj.Background+800)):Obj.Background
		if(WinExist(Obj.ID))
			Gui,% Obj.Win ":Color",%Color%,%Color%
	}SetPos(position:="setPosBR"){
		Width:=this.MonRight-this.MonLeft,MH:=this.MonBottom-this.MonTop,MinX:=[],MinY:=[],Obj:=[],Height:=0,Sub:=0,MY:=MH,MaxW:={0:1},Delay:=A_WinDelay,Hidden:=A_DetectHiddenWindows
		DetectHiddenWindows,On
		SetWinDelay,-1
		for a,b in NotifyClass.Windows{
			WinGetPos,x,y,w,h,% b.ID
			Height+=h+this.Margin
			if(MH<=Height)
				Sub:=Width-MinX.MinIndex()+this.Margin,MY:=MH,MinY:=[],MinX:=[],Height:=h,MaxW:={0:1},Reset:=1
			MaxW[w]:=1,MinX[Width-w-Sub]:=1,MinY[MY:=MY-h-this.Margin]:=y,XPos:=MinX.MinIndex()+(Reset?0:MaxW.MaxIndex()-w)

         ; eu criei essa regra para definir a posição da gui, o padrão é fundo direito. Passar position como parametro, na chamada da funcao passar o valor do position
         if(position = "setPosBR"){
		   WinMove,% b.ID,,%XPos%,MinY.MinIndex() ; fundo direito / bottom right
         }else if(position = "setPosTR"){
			WinMove,% b.ID,,%XPos%,0 ; topo direito / top right
         }else if(position = "setPosBL"){
			WinMove,% b.ID,,0,MinY.MinIndex() ; fundo esquerdo / bottom left
         }else if(position = "setPosTL"){
         WinMove,% b.ID,,0,0 ; topo esquedo / top left
         }else{
            ; se ñ especificar nenhum parametro, parametro vazio ""
            ; se definir o default parameter como ""
            WinMove,% b.ID,,%XPos%,MinY.MinIndex() ; fundo direito / bottom right
         }
			Obj[a]:={x:x,y:y,w:w,h:h},Reset:=0
		}DetectHiddenWindows,%Hidden%
		SetWinDelay,%Delay%
	}SetProgress(ID,Progress){
		GuiControl,,% NotifyClass.Windows[ID].Progress,%Progress%
	}
}


