VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "clsWoman"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Implements clsHuman ' clsHuman������

' �t�B�[���h
Private f_name As String
Private f_age As Integer

' �v���p�e�B: Name�̎���
Private Property Let clsHuman_Name(ByVal x_name As String)
    f_name = x_name
End Property

' �v���p�e�B: Name�̎���
Private Property Get clsHuman_Name() As String
    clsHuman_Name = f_name
End Property

' �v���p�e�B: Age�̎���
Private Property Let clsHuman_Age(ByVal x_age As Integer)
    f_age = x_age
End Property

' �v���p�e�B: Age�̎���
Private Property Get clsHuman_Age() As Integer
    clsHuman_Age = f_age
End Property

' Sub�v���V�[�W��: Greet�̎���
Private Sub clsHuman_Greet()
    Debug.Print "����ɂ��́B���̖��O�� " & f_name & " ��B"
End Sub

' Function�v���V�[�W��: GetInfo�̎���
Private Function clsHuman_GetInfo() As String
    clsHuman_GetInfo = "<woman name=""" & f_name & """ age=""" & CStr(f_age) & """>"
End Function
