Class od.Smavoo.HubOperation extends Ens.BusinessOperation {

Parameter ADAPTER = "EnsLib.HTTP.OutboundAdapter";

Property Adapter As EnsLib.HTTP.OutboundAdapter;

Parameter INVOCATION = "Queue";

Method SendSensorReading(pInput As od.msg.HubRequest = "", Output pOutput As od.msg.HubResponse) As %Status
{
	#dim req As %Net.HttpRequest

	set dataString = "{""id"":""690001001"",""cycle"":1,""type"":""LEVER_SWITCH_V2"",""identity"":""vwpnwrclb001"",""vcc"":0,""heap"":211884,""rssi"":-56,""value"":""1"",""sleepWakeupCause"":1,""wifiFailureCount"":0,""serverFailureCount"":0,""fw"":""3.1.8"",""connectionTime"":1707,""transactionTime"":4101,""ska"":3600,""FORCE_DEEP_SLEEP"":14000,""snw"":300,""ssf"":180,""swf"":180,""wrm"":5,""srm"":5,""oct"":1,""brownout"":0}"
	//if pInput="" {
		$$$TRACE("Creating object")
		set pInput = ##class(od.msg.HubRequest).%New()
		set pInput.req = ##class(od.SensorReading).%New()
		set st = pInput.req.%JSONImport(dataString)
	//}
	set st = pInput.req.%JSONExportToString(.payload)
	if st'=1 quit st
	set req = ##class(%Net.HttpRequest).%New()
	set req.WriteRawMode = 1
	set req.ContentType = "application/json"
	set st = req.EntityBody.Write(dataString)
	set req.Server = ..Adapter.HTTPServer
	set req.Port = ..Adapter.HTTPPort
	set st = req.Post(..Adapter.URL)
	$$$TRACE("HTTP POST was executed; status is " _ st)
	set responseAsString = req.HttpResponse.Data.Read()
	$$$TRACE(responseAsString)
	
	set pOutput = ##class(od.msg.HubResponse).%New()
	set pOutput.resp = ##class(od.HubReply).%New()
	set st = pOutput.resp.%JSONImport(responseAsString)
	set st = pInput.%Save()
	quit st
}

Method SendSensorReadingAsJSONString(pInput As Ens.StringRequest, Output pOutput As Ens.StringResponse) As %Status
{
	#dim req As %Net.HttpRequest
	
	set pOutput = ##class(Ens.StringResponse).%New()
	set req = ##class(%Net.HttpRequest).%New()
	set req.WriteRawMode = 1
	set req.ContentType = "application/json"
	set req.Server = ..Adapter.HTTPServer
	set req.Port = ..Adapter.HTTPPort
	set st = req.Post(..Adapter.URL)
	set st = req.EntityBody.Write(pInput.StringValue)
	set pOutput.StringValue = req.HttpResponse.Data.Read()
	
	/*
	set reqTest = ##class(od.msg.HubRequest).%New()
	set respTest = ##class(od.msg.HubResponse).%New()
	set st = reqTest.req.%JSONImport(pInput.StringValue)
	set st =  ..SendSensorReading(reqTest, .respTest)
	set pOutput.StringValue = reqTest.%ToJSON()
	*/
	
	quit $$$OK
}

XData MessageMap {
<MapItems>
    <MapItem MessageType="od.msg.HubRequest">
        <Method>SendSensorReading</Method>
    </MapItem>
    <MapItem MessageType="Ens.StringRequest">
        <Method>SendSensorReadingAsJSONString</Method>
    </MapItem>
</MapItems>
}

}