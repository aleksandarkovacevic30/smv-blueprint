Class od.ShelfStatus Extends %Persistent
{

Property Apples As %Numeric;

Property Bananas As %Numeric;

Property Orange As %Numeric;

Property Other As %String;

Storage Default
{
<Data name="ShelfStatusDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Apples</Value>
</Value>
<Value name="3">
<Value>Bananas</Value>
</Value>
<Value name="4">
<Value>Orange</Value>
</Value>
<Value name="5">
<Value>Other</Value>
</Value>
</Data>
<DataLocation>^od.ShelfStatusD</DataLocation>
<DefaultData>ShelfStatusDefaultData</DefaultData>
<IdLocation>^od.ShelfStatusD</IdLocation>
<IndexLocation>^od.ShelfStatusI</IndexLocation>
<StreamLocation>^od.ShelfStatusS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
