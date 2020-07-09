Class BankingSrv.BO.SendEmail Extends Ens.BusinessOperation [ Language = objectscript ]
{

Parameter ADAPTER = "EnsLib.EMail.OutboundAdapter";

Property Adapter As EnsLib.EMail.OutboundAdapter;

Parameter INVOCATION = "Queue";

Method SendMsg(pInput As BankingSrv.Msg.EmailRequest, Output pOutput As Ens.Response) As %Status
{
	$$$TRACE("SendMsg to "_pInput.Recipient)
	set pOutput = ##class(Ens.Response).%New()
	
	If pInput.Recipient = "" {
		$$$TRACE("No Recipient")
		Quit $$$OK
	} 
	#dim oMsg As %Net.MailMessage
	
	set oMsg = ##class(%Net.MailMessage).%New()
	do oMsg.To.Insert(pInput.Recipient)
	set oMsg.Subject = pInput.Subject
	do oMsg.TextData.Write(pInput.EmailBody)
	
	set oStatus = ..Adapter.SendMail(oMsg)
	$$$TRACE("Sent Email to: "_pInput.Recipient) 
	quit oStatus
}

Method SendTranCountMsg(pInput As BankingSrv.Msg.TranCountEmailReq, Output pOutput As Ens.Response) As %Status
{
	$$$TRACE("SendMsg to "_pInput.Recipient)
	set pOutput = ##class(Ens.Response).%New()
	
	If pInput.Recipient = "" {
		$$$TRACE("No Recipient")
		Quit $$$OK
	} 
	#dim oMsg As %Net.MailMessage
	
	set oMsg = ##class(%Net.MailMessage).%New()
	do oMsg.To.Insert(pInput.Recipient)
	set oMsg.Subject = "Demo Bank - Activity Alert"
	do oMsg.TextData.Write("Dear Customer, "_$CHAR(10)_$CHAR(10) )
	do oMsg.TextData.Write("We have identified some unusual Credit Card transactions on your account."_$CHAR(10) )
	do oMsg.TextData.Write("You should check your credit card information."_$CHAR(10) )
	
	set oStatus = ..Adapter.SendMail(oMsg)
	$$$TRACE("Sent Email to: "_pInput.Recipient) 
	quit oStatus
}

XData MessageMap
{
<MapItems>
	<MapItem MessageType="BankingSrv.Msg.EmailRequest"> 
		<Method>SendMsg</Method>
	</MapItem>
	<MapItem MessageType="BankingSrv.Msg.TranCountEmailReq"> 
		<Method>SendTranCountMsg</Method>
	</MapItem>
	
	
</MapItems>
}

}