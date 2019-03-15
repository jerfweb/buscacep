#include 'protheus.ch'

//-------------------------------------------------------------------
/*/{Protheus.doc} fTestCEP
Função para teste.
@author     Jerfferson Silva
@since      15.03.2019
@version    1.0
/*/
//-------------------------------------------------------------------
User Function fTestCEP()
    
    Private	aRet  := {}

    If !ParamInf(@aRet)
        Return
    Else
        U_fBuscaCep(aRet[1])
    Endif

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} ParamInf
Perguntas
@author     Jerfferson Silva
@since      15.03.2019
@return     aRet, Com as respostas
/*/
//-------------------------------------------------------------------
Static Function ParamInf(aRet)

    Local	lReturn   := .T.
    Local   aPergs    := {}
    Local	cSayCEP     := Space(TamSx3("A1_CEP")[1])
    Local	cLoad	  := "fTestCEP"
    Local   lCanSave  := .T.
    Local   lUserSave := .T.
    Private cCadastro := "Parâmetros"

    aAdd( aPergs ,{1,"CEP",cSayCEP , PesqPict("SA1","A2_CEP")   ,'.T.',     ,'.T.',38,.F.}) 
    If ParamBox (aPergs, "CEP", @aRet,,,,,,, cLoad, lCanSave, lUserSave)
        Aadd(aRet, {.T.} )
    Else
        lReturn := .F.
    EndIf

Return (lReturn)