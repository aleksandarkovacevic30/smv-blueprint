/// Main Business Process, which use object detection in images to manage fruits on the shelf.
Class od.FruitOrderProcess Extends Ens.BusinessProcessBPL
{

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='od.msg.FruitShelfUpdateRequest' response='Ens.Response' height='2000' width='2000' >
<context>
<property name='ObjectsAsString' type='%String' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='2500' />
</parameters>
</property>
<property name='exportableDF' type='%String' collection='array' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='' />
</parameters>
</property>
<property name='listDF' type='%String' collection='list' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='' />
</parameters>
</property>
<property name='status' type='%Integer' collection='array' instantiate='0' />
<property name='resultName' type='%String' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='250' />
</parameters>
</property>
</context>
<sequence xend='200' yend='850' >
<call name='Detect Objects' target='od.BP.DetectObjects' async='1' xpos='200' ypos='250' >
<request type='od.msg.ImageODRequest' >
<assign property="callrequest.Filename" value="request.Filename" action="set" />
<assign property="callrequest.Filepath" value="request.Filepath" action="set" />
</request>
<response type='od.msg.ImageODResponse' >
<assign property="context.ObjectsAsString" value="callresponse.JSONResponse" action="set" />
<assign property="context.resultName" value="callresponse.resultFile" action="set" />
</response>
</call>
<sync calls='Detect Objects' type='all' xpos='200' ypos='350' />
<code name='Store Data Into IRIS' xpos='200' ypos='450' >
<![CDATA[
  set ol=##class(od.ObjectsList).%New()
  s sc = ol.%JSONImport(context.ObjectsAsString)
  do ol.%Save()
  set ^lastImage=context.resultName]]>
</code>
<code name='Calculate Shelf Status' xpos='200' ypos='550' >
<![CDATA[
  SET myquery = "SELECT Class, COUNT(*) As cnt FROM od.Objects Where Timestamp = (Select MAX(Timestamp) from od.Objects) group by Class"
  SET tStatement = ##class(%SQL.Statement).%New()
  SET qStatus = tStatement.%Prepare(myquery)
  IF qStatus'=1 {WRITE "%Prepare failed:" DO $System.Status.DisplayError(qStatus) QUIT}
  SET rset = tStatement.%Execute()
  WHILE rset.%Next() { set sc=context.status.SetAt(rset.cnt, rset.Class) }
]]>
</code>
<call name='Order Routing' target='od.BP.Router' async='1' xpos='200' ypos='650' >
<request type='od.msg.odRouterRequest' >
<assign property="callrequest.Apples" value="context.status.GetAt(&quot;APPLE&quot;)" action="set" />
<assign property="callrequest.Bananas" value="context.status.GetAt(&quot;BANANA&quot;)" action="set" />
<assign property="callrequest.Oranges" value="context.status.GetAt(&quot;ORANGE&quot;)" action="set" />
<assign property="callrequest.Other" value="context.status.GetAt(&quot;MOUSE&quot;)" action="set" />
<assign property="callrequest.Image" value="context.resultName" action="set" />
</request>
<response type='Ens.Response' />
</call>
<sync calls='Order Routing' type='all' xpos='200' ypos='750' />
</sequence>
</process>
}

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}
