Class od.RestFulService Extends Ens.BusinessService
{

Parameter ADAPTER = "EnsLib.HTTP.InboundAdapter";

Property Target As %String(MAXLEN = 100)[InitialExpression = "od.BP.FruitOrderProcess"];

Parameter SETTINGS = "Target:Basic";

Method OnProcessInput(pInput As od.msg.FruitShelfUpdateRequest, Output pOutput As Ens.Response) As %Status
{
	Set tSC=$$$OK
	Try {
		set tSC=..SendRequestAsync(..Target,.pInput,"")
		$$$ThrowOnError(tSC) 

	}
	Catch ex{
		set tSC=ex.AsStatus()
	}
	return tSC
}

}
