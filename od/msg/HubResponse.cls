Class od.msg.HubResponse Extends Ens.Response
{
Property resp As od.HubReply;

Storage Default
{
<Data name="HubResponseDefaultData">
<Subscript>"HubResponse"</Subscript>
<Value name="1">
<Value>resp</Value>
</Value>
</Data>
<DefaultData>HubResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}