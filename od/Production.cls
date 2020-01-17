/// Sample production
Class od.Production Extends Ens.Production
{

XData ProductionDefinition
{
<Production Name="od.Production" TestingEnabled="true" LogGeneralTraceEvents="true">
  <Description></Description>
  <ActorPoolSize>2</ActorPoolSize>
  <Item Name="HubOperation" Category="" ClassName="od.Smavoo.HubOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Adapter" Name="HTTPPort">80</Setting>
    <Setting Target="Adapter" Name="HTTPServer">sensor.smavoo.com</Setting>
    <Setting Target="Adapter" Name="URL">/api/device/status</Setting>
    <Setting Target="Adapter" Name="Credentials">smavoo</Setting>
  </Item>
  <Item Name="HubService" Category="" ClassName="od.Smavoo.HubService" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="MaximumEventAge">10</Setting>
  </Item>
</Production>
}

}
