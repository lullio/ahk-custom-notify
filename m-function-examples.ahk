#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%
; https://www.youtube.com/watch?v=R1GMJrksxwM
; https://github.com/maestrith/MsgBox-Class/blob/master/New%20MsgBox.ahk

; o código atualizado tá no github, de 2020
; o código do vídeo é de 2018

; é igual messagebox do autohotkey
; retorna o valor do q vc clicar

; https://www.autohotkey.com/docs/commands/MsgBox.htm
; tem as msm opções da msgbox, tipos de botoes, ync yn, rc, oc, o, ari, ctc
if(m("testing 123", "btn:ync","def:2","ico:?")="YES"){
   m("you chose yes")
}

res1:=m("testing 123", "btn:o","def:2","ico:?")
m(res1) ; retorna o valor do botao q clicar


Obj:= {1:"Hello", 2:["There", "Things", "More"], Things:"other things"}
String:= "this is a string ehhehe"

res:= m(String, "btn:rc", "def:2", "ico:?", "Testing", Obj, Obj.2, Obj.1, Obj.Things, Obj.2.1)
m(res)