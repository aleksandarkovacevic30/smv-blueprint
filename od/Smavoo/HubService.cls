Class od.Smavoo.HubService extends Ens.BusinessService {

/// Maximum number of seconds that an event is remembered to avoid duplicates.
Property MaximumEventAge As %Integer [InitialExpression = 86400];

Parameter SETTINGS = "MaximumEventAge";

Method OnProcessInput(pInput As %Stream.Object, Output pOutput As od.msg.HubResponse) As %Status
{
	set pOutput = ##class(od.msg.HubResponse).%New()
	if $CLASSNAME(pInput)'="od.msg.HubRequest" {
		set pOutput.resp.state = "INVALID_REQUEST_TYPE"
		quit $$$OK
	}
	quit ..SendRequestSync("HubOperation",pInput,.pOutput,5)
}

}