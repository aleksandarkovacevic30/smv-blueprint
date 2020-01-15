Class od.Smavoo.HubOperation extends Ens.BusinessOperation {

Parameter ADAPTER = "EnsLib.HTTP.OutboundAdapter";

Property Adapter As EnsLib.HTTP.OutboundAdapter;

Parameter INVOCATION = "Queue";

Method SendSensorReading(pInput As od.msg.HubRequest, Output pOutput As od.msg.HubResponse) As %Status
{
	#dim req As %Net.HttpRequest
	
	set st = pInput.req.%JSONExportToString(.payload)
	if st'=1 quit st
	set req = ##class(%Net.HttpRequest).%New()
	set req.WriteRawMode = 1
	set req.ContentType = "application/json"
	set st = req.EntityBody.Write(payload)
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