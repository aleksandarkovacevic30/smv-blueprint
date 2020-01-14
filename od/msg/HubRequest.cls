Class od.msg.HubRequest Extends Ens.Request
{

Property req As od.SensorReading;

Storage Default
{
<Data name="HubRequestDefaultData">
<Subscript>"HubRequest"</Subscript>
<Value name="1">
<Value>req</Value>
</Value>
</Data>
<DefaultData>HubRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}