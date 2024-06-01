#SingleInstance, Force

text=
(
felipe
TV_GetSelection()
okkk
)

Notify:=Notify(10)
Notify().AddWindow("Sucesso ao obter os containers!" containers,{Time:8000,Icon:177,Background:"0x039018",Title:"Sucesso!",TitleColor:"0xF0F8F1", TitleSize:15, Size:15, Color: "0xF0F8F1"},"","setPosBR")

Notify().AddWindow("Texto",{Time:3000,Icon:28,Background:"0x990000",Title:"ERRO",TitleSize:15, Size:15, Color: "0xCDA089", TitleColor: "0xE1B9A4"},"w330 h30","setPosBR") ;

Notify.AddWindow("Contas e containers recuperados com sucesso!",{Time:3000,Icon:177,Background:"0x039018",Title:"SUCESSO",TitleColor:"0xF0F8F1", TitleSize:15, Size:15, Color: "0xF0F8F1"},"","setPosBR")
Notify.AddWindow("Tags recuperadas com sucesso!",{Time:3000,Icon:177,Background:"0x039018",Title:"SUCESSO",TitleColor:"0xF0F8F1", TitleSize:15, Size:15, Color: "0xF0F8F1"},"","setPosBR")

Notify.AddWindow("Triggers recuperados com sucesso!",{Time:3000,Icon:177,Background:"0x039018",Title:"SUCESSO",TitleColor:"0xF0F8F1", TitleSize:15, Size:15, Color: "0xF0F8F1"},"","setPosBR")

Notify.AddWindow("Variables recuperadas com sucesso!",{Time:3000,Icon:177,Background:"0x039018",Title:"SUCESSO",TitleColor:"0xF0F8F1", TitleSize:15, Size:15, Color: "0xF0F8F1"},"","setPosBR")

; WindowID:=Notify.AddWindow("Your Text Here",{Icon:4,Background:"0xAA00AA",Buttons:"OK,Exit"})

; Notify().AddWindow(text, {buttons:"one, two, tree"})
; NotifyClass.AddWindow(text,{Flash:1000, FlashColor: "0x1100AA",Icon:"C:\Users\Estudos\Downloads\alfinete (4).png", IconSize: 40, Background:"0x1100AA",Title:"Caminho na Area de Transferencia",TitleSize:16,size:12, Sound:800,Hide:"Right" })



; SysGet,Mon,MonitorWorkArea

; SysGet, Mon2, MonitorWorkArea
; MsgBox, Left: %Mon2Left% -- Top: %Mon2Top% -- Right: %Mon2Right% -- Bottom %Mon2Bottom%.

Notify().AddWindow(text,{Flash:1000, FlashColor: "0x1100AA",Icon:"C:\Users\Estudos\Downloads\alfinete (4).png", IconSize: 40, Background:"0x1100AA",Title:"Caminho na Area de Transferencia",TitleSize:16,size:12, Sound:800,Hide:"Right" })

Notify().AddWindow(text,{Time:3000,Icon:300,Background:"0x1100AA",Title:"Seus Telefones",TitleSize:16,size:14})

; margem 1015 fica no topo centro
; *************************** **********************

; Se quiser pode instanciar uma vez somente 
Notify := Notify(20)

; agora só precisa chamar o objeto usando Notify.AddWindow
Notify.addWindow("texto para exibir") ; exibe pra sempre até clicar nela pois não tem tempo

; Adicionar uma animação, colocar delay na animação
Notify.AddWindow("Seu texto aqui", {Animate:"Blend", ShowDelay:1500})

; Pode adicionar ícone
Notify.AddWindow(text,{Icon:"C:\Users\Estudos\Downloads\alfinete (4).png, 1", IconSize: 40})

; olha na pasta shell32 do windows por ícones, ai pode usar número
; melhores ícones, 24, 23, 28, 44, 48, 110, 118, 131, 132, 145, 155, 177, 210, 209, 234, 238, 297, 321, 300, 
Notify.AddWindow(text,{Icon:321, IconSize: 40})

; pode adicionar flash de cor, soundm beep, radius da box, pode adicionar botoes
; sound, usar 300 3000 (é um beep, número é a frequência) ou pode adicionar um audio colocar o caminho do arquivo mp3
Notify.AddWindow(text,{Icon:321, IconSize: 40, Sound:"c:\windows\media\alarm05.wav"})

; ADICIONAR BOTÕES E FUNÇÕES PARA OS BOTÕES
Notify.AddWindow(text, {buttons:"one, two, tree"})
; ao clicar num botão, exibe o valor do botão
; tive que desativar essa função no arquivo Notify.ahk da Lib pois no script Notify.ahk tem exemplos de códigos vc precisa apagar
click(obj){
   m(obj) ; exibir todas infos capturadas do obj
   MsgBox, % obj.button

   if(Obj.Ident="MyID")
      msgbox % ("you clicked the first")
   if(Obj.Ident="MyID2")
      msgbox % ("you clicked the second")
}