#SingleInstance,Force
Count:=0
Notify:=Notify(20)

Text:=["Longer text for a longer thing","Taller Text`nfor`na`ntaller`nthing"]
SetTimer,RandomProgress,500
Loop,2
{
	Random,Time,3000,8000
	/*
		Time:=A_Index=40?1000:Time
		Random,Sound,500,800
	*/
	Random,TT,1,2
	Random,Background,0x0,0xFFFFFF
	Random,Color,0x0,0xFFFFFF
	Random,Icon,20,200
	Notify.AddWindow(Text[TT],{Icon:300,Title:"This is my title",TitleFont:"Tahoma",TitleSize:10,Time:Time,Background:Background,Flash:1000,Color:Color})
	Notify.AddWindow(Text[TT],{Icon:"D:\AHK\AHK-Studio\AHK-Studio.exe",IconSize:20,Title:"This is my title",TitleFont:"Tahoma",TitleSize:10,Time:Time,Background:Background,Flash:1000,FlashColor:"0xAA00AA",Color:Color,Time:Time,Sound:Sound})
	Notify.AddWindow(Text[TT],{Icon:Icon,IconSize:80,Title:"This is my title",TitleFont:"Tahoma",TitleSize:10,Time:Time,Background:Background,Flash:1000,FlashColor:"0xAA00AA",Color:Color,Time:Time,Sound:Sound})
	ID:=Notify.AddWindow(Text[TT],{Progress:0,Icon:Icon,IconSize:80,Title:"This is my title",TitleFont:"Tahoma",TitleSize:10,Time:Time,Background:Background,Flash:1000,FlashColor:"0xAA00AA",Color:Color,Time:Time,Sound:Sound})
	Notify.AddWindow("This is my text",{Title:"My Title"})
	Random,Ico,1,5
	Notify.AddWindow("Odd icon",{Icon:A_AhkPath "," Ico,IconSize:20,Title:"This is my title",TitleFont:"Tahoma",TitleSize:10,Time:Time,Background:Background,Flash:1000,Color:Color,Time:Time})
	Random,Delay,100,400
	Delay:=1000
	Notify.AddWindow(Text[TT],{Radius:20,Hide:"Left,Bottom",Animate:"Right,Slide",ShowDelay:Delay,Icon:Icon,IconSize:20,Title:"This is my title",TitleFont:"Tahoma",TitleSize:10,Background:Background,Color:Color,Time:Time,Progress:0})
}
return
RandomProgress:
for a,b in NotifyClass.Windows{
	Random,Pro,10,100
	Notify.SetProgress(a,Pro)
}
return
Click(Obj){
	for a,b in Obj
		Msg.=a " = " b "`n"
    	MsgBox,%Msg%
}
;Actual code starts here

return
Escape::
ExitApp
return