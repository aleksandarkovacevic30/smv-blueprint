Class od.msg.ImageODResponse Extends Ens.Response
{

Property JSONResponse As %String(MAXLEN = 99999);

Property resultFile As %String(MAXLEN = 100);

Storage Default
{
<Data name="ImageODResponseDefaultData">
<Subscript>"ImageODResponse"</Subscript>
<Value name="1">
<Value>JSONResponse</Value>
</Value>
<Value name="2">
<Value>resultFile</Value>
</Value>
</Data>
<DefaultData>ImageODResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
