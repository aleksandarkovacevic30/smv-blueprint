Class od.RestServer Extends %CSP.REST
{

Parameter HandleCorsRequest = 1;

Parameter CHARSET = "utf-8";

Parameter CONTENTTYPE = "application/json";

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
	<Route Url="/sendImage/:ind" Method="GET" Call="sendImage"/>
	<Route Url="/api/device/:device" Method="GET" Call="getDeviceInfo"/>
	<Route Url="/api/device/status" Method="POST" Call="setDeviceStatus"/>
</Routes>
}

ClassMethod setDeviceStatus() As %Status
{
	#dim %request As %CSP.Request

	// Calling this method triggers the cleanup of old sensor events.
	set st = $$$OK
	set tMaxAge = ##class(Ens.Director).GetItemSettingValue("od.Production||HubService", "Host", "MaximumEventAge", .st)
	if $GET(^sensorEvent) < ($ZDATETIME($HOROLOG,-2) - tMaxAge) set st = ..deleteOldEvents(tMaxAge)
	if st'=1 quit st
	
	// Convert JSON payload to object.
	set tRequest = ##class(od.msg.HubRequest).%New()
	set tRequest.req = ##class(od.SensorReading).%New()
	set tStr = %request.Content.Read()
	set st = tRequest.req.%JSONImport(tStr)
	if st'=1 quit st
	
	// Check for duplicate messages. We assume that the combination of id and cycle is unique.
	if $DATA(^sensorEvent(tRequest.req.id, tRequest.req.cycle)) {
		write "{""state"":""DUPLICATE READING"",""id"":"""_tRequest.req.id_""",""cycle"":"_tRequest.req.cycle_"}"
		quit $$$OK
	}
	set st = tRequest.req.%Save()
	if st'=1 quit st
	set ^sensorEvent(tRequest.req.id, tRequest.req.cycle) = $ZDATETIME($HOROLOG,-2)
	
	// Forward the event to the Business Service.
	#dim tOutput As od.msg.HubResponse
	set st = ##class(Ens.Director).CreateBusinessService("HubService",.tService)
	set st = tService.ProcessInput(tRequest,.tOutput)
	set %response.Status = ..#HTTP200OK
	
	//write "{""state"":""DEVICE_INACTIVE_STATE"",""config"":{""ska"":""3600""}}"
	set ^av("State returned") = tOutput.resp.state
	set st = tOutput.resp.%JSONExportToString(.str)
	write str
	quit st
}

/// Returns most recent info for device with id <var>pDeviceid</var>.
ClassMethod getDeviceInfo(pDeviceId As %String) As %Status
{
	&sql(SELECT TOP 1 type, ident, heap, wifiFailureCount 
	INTO :tType, :tIdent, :tHeap, :tWifiFailureCount
	FROM od.SensorReading ORDER BY ts DESC)
	set tObj = {}.%Set("type",tType).%Set("identity",tIdent).%Set("heap",tHeap).%Set("wifiFailureCount",tWifiFailureCount)
	write tObj.%ToJSON()
	quit $$$OK
}

/// Deletes all sensorEvents older than <var>pAge</var> seconds.
/// The default is to delete all events older than one day.
ClassMethod deleteOldEvents(pAge As %Integer = 86400) As %Status
{
	set ^sensorEvent = $ZDATETIME($HOROLOG,-2) // Keep track of last execution time.
	set tMinimumTimestamp = ^sensorEvent - pAge
	set kSensorId = $ORDER(^sensorEvent(""),-1)
	while (kSensorId'="") {
		set kSensorCycle = $ORDER(^sensorEvent(kSensorId,""),-1,tTimestamp)
		while (kSensorCycle'="") {
			if tTimestamp < tMinimumTimestamp kill ^sensorEvent(kSensorId,kSensorCycle)
			set kSensorCycle = $ORDER(^sensorEvent(kSensorId,kSensorCycle),-1,tTimestamp)
		}
		set kSensorId = $ORDER(^sensorEvent(kSensorId),-1)
	}
	quit $$$OK
}

ClassMethod sendImage(id As %String) As %Status
{
 set tRet = {"status":"ok"}
 set tSC = $$$OK
 try {
 		//Instantiate Business Service
 		set tSC = ##class(Ens.Director).CreateBusinessService("od.BS.RestFulService",.tService)
 		$$$ThrowOnError(tSC)
 		//Pass along input from url to ProcessInput
 		set request = ##class(od.msg.ImageODRequest).%New()
 		set request.Filename="Fruitshelf"_id_".jpg"
 		set request.Filepath="/usr/irissys/csp/python/shelf_images"
 		set tSC = tService.ProcessInput(request,.output)
 	 	$$$ThrowOnError(tSC)
 	 	set %response.Status = ..#HTTP200OK
 	}
 	Catch ex {
 		set tSC=ex.AsStatus()
 		set tRet = {"status":"exception thrown", "details":"not implemented"}
 		set %response.Status = ..#HTTP500INTERNALSERVERERROR
 	}
 	write tRet.%ToJSON()

  quit $$$OK
}

}
