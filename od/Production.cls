/// Sample production
Class od.Production Extends Ens.Production
{

/// Register callout lib system-wide
ClassMethod OnStart(pTimeStarted As %String) As %Status
{
  set sc = ##class(isc.py.Callout).Setup()
  quit sc
}

XData ProductionDefinition
{
<Production Name="od.Production" TestingEnabled="true" LogGeneralTraceEvents="false">
  <Description></Description>
  <ActorPoolSize>2</ActorPoolSize>
  <Item Name="od.BO.PythonGateway" Category="" ClassName="isc.py.ens.Operation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Host" Name="PythonLib">libpython3.6m.so</Setting>
  </Item>
  <Item Name="od.BS.RestFulService" Category="" ClassName="od.RestFulService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="od.BP.DetectObjects" Category="" ClassName="od.DetectObjects" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="od.BP.EscalatedodWorkflow" Category="" ClassName="od.EscalatedodWorkflow" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="od.BP.NormalodWorkflow" Category="" ClassName="od.NormalodWorkflow" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="od.BO.OrderTeam" Category="" ClassName="EnsLib.Workflow.Operation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="AutoCreateRole">1</Setting>
  </Item>
  <Item Name="od.BP.Router" Category="" ClassName="EnsLib.MsgRouter.RoutingEngine" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="BusinessRuleName">od.odRouterRoutingRule</Setting>
  </Item>
  <Item Name="od.BP.FruitOrderProcess" Category="" ClassName="od.FruitOrderProcess" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
</Production>
}

}
