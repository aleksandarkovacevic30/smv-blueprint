Class od.HubConfig Extends (%Persistent,%JSON.Adaptor)
{
Property ska As %String;

Storage Default
{
<Data name="HubConfigDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ska</Value>
</Value>
</Data>
<DataLocation>^od.HubConfigD</DataLocation>
<DefaultData>HubConfigDefaultData</DefaultData>
<IdLocation>^od.HubConfigD</IdLocation>
<IndexLocation>^od.HubConfigI</IndexLocation>
<StreamLocation>^od.HubConfigS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}