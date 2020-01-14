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
	// Convert JSON payload to object, verifying its content in the process.
	set tRequest = ##class(od.HubRequest).%New()
	set tRequest.req = ##class(od.HubRequest).%New()
	set tRequest.req = %request.%FromJSON(obj)
	
	/*
	if '..GetJSONFromRequest(.obj) {
		set %response.Status = ..#HTTP400BADREQUEST
		set error = {"errormessage": "JSON not found"}
		write error.%ToJSON()
		quit $$$OK
	}
	
	if '..ValidateJSON(obj,.error) {
		set %response.Status = ..#HTTP400BADREQUEST
		write error.%ToJSON()
		quit $$$OK
	}
	
	// Create a request and send it to the operation.
	do ..CopyToCoffeemakerFromJSON(.cm,obj)
	
	set sc = cm.%Save()
	
	set result={}
	do result.%Set("Status",$s($$$ISERR(sc):$system.Status.GetOneErrorText(sc),1:"OK"))
	write result.%ToJSON()
	*/
	quit sc
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
