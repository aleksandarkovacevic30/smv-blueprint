Class od.SensorReading Extends (%Persistent,%JSON.Adaptor)
{
Parameter DSTIME = "AUTO"; // For cube synchronization.

Property id As %String; // "690001001"
Property cycle As %Integer; // 1
Property type As %String; // "LEVER_SWITCH_V2"
Property identity As %String [ SqlFieldName = "ident" ]; // "vwpnwrclb001"
Property vcc As %Integer; // 0
Property heap As %Integer; // 211884
Property rssi As %Integer; // -56
Property value As %String; // "1"
Property sleepWakeupCause As %Integer; // 1
Property wifiFailureCount As %Integer; // 0
Property serverFailureCount As %Integer; // 0
Property fw As %String; // "3.1.8"
Property connectionTime As %Integer; // 1707
Property transactionTime As %Integer; // 4101
Property ska As %Integer; // 3600
Property forceDeepSleep As %Integer (%JSONFIELDNAME = "FORCE_DEEP_SLEEP"); // 14000
Property snw As %Integer; // 300
Property ssf As %Integer; // 180
Property swf As %Integer; // 180
Property wrm As %Integer; // 5
Property srm As %Integer; // 5
Property oct As %Integer; // 1
Property brownout As %Integer; // 0
Property ts As %Integer (%JSONINCLUDE = "none"); // timestamp

Index idIdx On(id);
Index idCycleIdx On(id,cycle);
Index tsIdx On(ts);

Method %OnNew() As %Status [ Private, ServerOnly = 1 ] 
{
	set ..ts = $ZDATETIME($HOROLOG,-2)
	quit $$$OK
}

Storage Default
{
<Data name="SensorReadingDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>id</Value>
</Value>
<Value name="3">
<Value>cycle</Value>
</Value>
<Value name="4">
<Value>type</Value>
</Value>
<Value name="5">
<Value>identity</Value>
</Value>
<Value name="6">
<Value>vcc</Value>
</Value>
<Value name="7">
<Value>heap</Value>
</Value>
<Value name="8">
<Value>rssi</Value>
</Value>
<Value name="9">
<Value>value</Value>
</Value>
<Value name="10">
<Value>sleepWakeupCause</Value>
</Value>
<Value name="11">
<Value>wifiFailureCount</Value>
</Value>
<Value name="12">
<Value>serverFailureCount</Value>
</Value>
<Value name="13">
<Value>fw</Value>
</Value>
<Value name="14">
<Value>connectionTime</Value>
</Value>
<Value name="15">
<Value>transactionTime</Value>
</Value>
<Value name="16">
<Value>ska</Value>
</Value>
<Value name="17">
<Value>forceDeepSleep</Value>
</Value>
<Value name="18">
<Value>snw</Value>
</Value>
<Value name="19">
<Value>ssf</Value>
</Value>
<Value name="20">
<Value>swf</Value>
</Value>
<Value name="21">
<Value>wrm</Value>
</Value>
<Value name="22">
<Value>srm</Value>
</Value>
<Value name="23">
<Value>oct</Value>
</Value>
<Value name="24">
<Value>brownout</Value>
</Value>
<Value name="25">
<Value>ts</Value>
</Value>
</Data>
<DataLocation>^od.SensorReadingD</DataLocation>
<DefaultData>SensorReadingDefaultData</DefaultData>
<IdLocation>^od.SensorReadingD</IdLocation>
<IndexLocation>^od.SensorReadingI</IndexLocation>
<StreamLocation>^od.SensorReadingS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}