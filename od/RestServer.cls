Class od.RestServer Extends %CSP.REST
{

Parameter HandleCorsRequest = 1;

Parameter CHARSET = "utf-8";

Parameter CONTENTTYPE = "application/json";

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
	<Route Url="/sendImage/:ind" Method="GET" Call="sendImage"/>
	<Route Url="/api/device/status" Method="POST" Call="deviceStatus"/>
</Routes>
}

ClassMethod deviceStatus() As %Status
{
	#dim %request As %CSP.Request

	set st = $$$OK
	// Calling this method triggers the cleanup of old sensor events.
	if ^sensorEvent < ($ZDATETIME($HOROLOG,-2) - 86400) set st = ..deleteOldEvents(86400)
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
	
	write "{""state"":""DEVICE_INACTIVE_STATE"",""config"":{""ska"":""3600""}}"
	quit st
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
