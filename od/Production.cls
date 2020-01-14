/// Sample production
Class od.Production Extends Ens.Production
{

XData ProductionDefinition
{
<Production Name="od.Production" TestingEnabled="true" LogGeneralTraceEvents="true">
  <Description></Description>
  <ActorPoolSize>2</ActorPoolSize>
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
  <Item Name="HubOperation" Category="" ClassName="od.Smavoo.HubOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Adapter" Name="HTTPPort">80</Setting>
    <Setting Target="Adapter" Name="HTTPServer">sensor.smavoo.com</Setting>
    <Setting Target="Adapter" Name="URL">/api/device/status</Setting>
    <Setting Target="Adapter" Name="Credentials">SmavooSensorHub</Setting>
  </Item>
</Production>
}

}
