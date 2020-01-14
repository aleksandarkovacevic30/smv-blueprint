Class od.HubReply Extends (%Persistent,%JSON.Adaptor)
{
Property state As %String; // DEVICE_INACTIVE_STATE
Property config As od.HubConfig; // {"ska":"3600"}

Storage Default
{
<Data name="HubReplyDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>stat</Value>
</Value>
<Value name="3">
<Value>config</Value>
</Value>
<Value name="4">
<Value>state</Value>
</Value>
</Data>
<DataLocation>^od.HubReplyD</DataLocation>
<DefaultData>HubReplyDefaultData</DefaultData>
<IdLocation>^od.HubReplyD</IdLocation>
<IndexLocation>^od.HubReplyI</IndexLocation>
<StreamLocation>^od.HubReplyS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}