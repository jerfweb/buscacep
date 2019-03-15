#include 'protheus.ch'

//-------------------------------------------------------------------
/*/{Protheus.doc} fBuscaCep
Função para buscar o CEP, via webserce com retorno em JSON.
@author     Jerfferson Silva
@since      15.03.2019
@version	1.0
@param      cCEP, caracter, Cep sem o '-' apenas os numeros.
/*/
//-------------------------------------------------------------------
User Function fBuscaCep(cCEP)

Local cUrl			:= "http://viacep.com.br/ws/"
Local cGetParams	:= ""
Local nTimeOut		:= 200
Local aHeadStr		:= {"Content-Type: application/json"}
Local cHeaderGet	:= ""
Local cRetWs		:= ""
Local oObjJson		:= Nil
Local cStrResul		:= ""

	If fValidarCep(cCep,@cUrl)

		cRetWs	:= HttpGet(cUrl, cGetParams, nTimeOut, aHeadStr, @cHeaderGet)

		If !FWJsonDeserialize(cRetWs, @oObjJson)
			MsgStop("Ocorreu erro no processamento do Json.")
			Return Nil
		ElseIf AttIsMemberOf(oObjJson,"ERRO")
			MsgStop("CEP inexistente na base de dados.")
			Return Nil
		Else
			
			cStrResult := DecodeUTF8(oObjJson:logradouro) + ", "
			cStrResult += DecodeUTF8(oObjJson:complemento) + ", "
			cStrResult += DecodeUTF8(oObjJson:bairro) + ", "
			cStrResult += DecodeUTF8(oObjJson:localidade) + "/"
			cStrResult += DecodeUTF8(oObjJson:uf) + ", "
			cStrResult += DecodeUTF8(oObjJson:unidade) + ", CEP: "
			cStrResult += DecodeUTF8(oObjJson:cep) + ", Cód. IBGE: "
			cStrResult += DecodeUTF8(oObjJson:ibge) + ", "

			AVISO("Consulta CEP - WS ViaCEP", cStrResult, {"Fechar"}, 2)

		EndIf

	EndIf

Return (cStrResul)

//-------------------------------------------------------------------------------------
/*/{Protheus.doc} fValidarCep
Função para validação do cep
@author     Jerfferson Silva
@since      15.03.2019
@param 		cCep, caracter, Cep pra consulta
@param 		cUrl, caracter, Url do serviço
@return 	lRet, logico, Retorno .T. (true) se cep valido ou .F. (false) se invalido.
/*/
//-------------------------------------------------------------------------------------
Static Function fValidarCep(cCep,cUrl)

	Local lRet := .F.

	If Empty(Alltrim(cCep)) //Validar se foi passado conteudo é vazio.
		MsgStop("Favor informar o CEP.")
		Return (lRet)
	ElseIf Len(Alltrim(cCep)) < 8 //Validar se o CEP informado tem menos 8 digitos.
		MsgStop("O CEP informado não contem a quantidade de dígito correta, favor informe um CEP válido.")
		Return (lRet)
	ElseIf At("-",cCep,) > 0 //Validar se o CEP está separado por "-".
		If Len(StrTran(AllTrim(cCep),"-")) == 8 //Validar se o CEP informado tem 8 digitos.
			cUrl += StrTran(AllTrim(cCep),"-")+"/json/"
			lRet := .T.
		Else
			MsgStop("O CEP informado não contem a quantidade de dígito correta, favor informe um CEP válido.")
			Return (lRet)
		EndIf
	Else
		cUrl += AllTrim(cCep)+"/json/"
		lRet := .T.
	EndIf

Return (lRet)