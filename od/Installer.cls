Class od.Installer
{

XData Install [ XMLNamespace = INSTALLER ]
{
<Manifest>
  <Var Name="pwd" Value="SYS"/> 
  <User Username="SuperUser" ChangePassword="0" PasswordVar="pwd" Roles="%All" Enabled="1"/>
  <Default Name="NAMESPACE" Value="SMAVOO"/>
  <Default Name="DBNAME" Value="${NAMESPACE}"/>
  <Default Name="SOURCESPATH" Dir='#{$system.Util.GetEnviron("SRC_DIR")}' />
  <Default Name="RESOURCE" Value="%DB_${DBNAME}" /> 
  <Namespace Name="${NAMESPACE}" Code="${DBNAME}CODE" Data="${DBNAME}DATA" Create="yes" Ensemble="1">
    <Configuration>
      <Database Name="${DBNAME}CODE" Dir="${MGRDIR}${DBNAME}CODE" Create="yes" Resource="${RESOURCE}"/>
      <Database Name="${DBNAME}DATA" Dir="${MGRDIR}${DBNAME}DATA" Create="yes" Resource="${RESOURCE}"/>
    </Configuration>

    <Import File="${SOURCESPATH}od" Recurse="1"/>

    <Log Level="1" Text="Enabling OS level Authentication"/>
    <Invoke Class="od.Installer" Method="OSAuth" CheckStatus="true"/>
    
	<Log Level="1" Text="Enabling Analytics"/>
	<Invoke Class="od.Installer" Method="EnableAnalytics" CheckStatus="true">
      <Arg Value="/csp/smavoo/"/>
    </Invoke>

	<Log Level="1" Text="Configuring REST"/>
    <Invoke Class="od.Installer" Method="CreateREST">
   <Arg Value="${NameSpace}"/>
   <Arg Value="/smavoo"/>
   <Arg Value="od.RestServer"/>
   </Invoke>

    <Production Name="od.Production"  AutoStart="1">
      <Credential Name="smavoo" Username="demo" Password="demo" Overwrite="0"/>
    </Production>
  </Namespace>
</Manifest>
}

ClassMethod Setup(ByRef pVars, pLogLevel As %Integer = 3, pInstaller As %Installer.Installer, pLogger As %Installer.AbstractLogger) As %Status [ CodeMode = objectgenerator, Internal ]
{
  Quit ##class(%Installer.Manifest).%Generate(%compiledclass, %code, "Install")
}

/// Enable OS Authentication
ClassMethod OSAuth() As %Status
{
	new $namespace
	set $namespace = "%SYS"
	set sc = ##Class(Security.System).Get($$$SystemSecurityName,.properties)
	quit:$$$ISERR(sc) sc
	
	set autheEnabled = properties("AutheEnabled")
	quit:'$data(autheEnabled) $$$ERROR($$$PropertyDoesNotExist, "AutheEnabled")
	set properties("AutheEnabled") = $ZBOOLEAN(+autheEnabled, $$$AutheOS, 7)
	set sc = ##Class(Security.System).Modify($$$SystemSecurityName, .properties) 
	
	quit sc
}

ClassMethod LoadZRoutines(dir As %String) As %Status
{
	new $namespace
	set $namespace = "%SYS"
	
	set dir = ##class(%File).NormalizeDirectory(dir)
	set sc = $system.OBJ.ImportDir(dir, "*.xml", "c")
	quit sc
}

ClassMethod CreateREST(namespace2 As %String, url As %String, dispatch As %String) As %Status
{
	#dim sc As %Status = $$$OK
    new $namespace
    set $namespace = "%SYS"
    if '##class(Security.Applications).Exists(url) {
        set props("AutheEnabled") = $$$AutheUnauthenticated
        set props("NameSpace") = "SMAVOO"
        set props("IsNameSpaceDefault") = $$$NO
        set props("DispatchClass") = dispatch
        set props("MatchRoles")=":" _ $$$AllRoleName
        set sc = ##class(Security.Applications).Create(url, .props)
    }
    quit sc
}

ClassMethod EnableAnalytics(pCSPName As %String, url As %String) As %Status
{
  new $namespace
  znspace "%SYS"
  set props("DeepSeeEnabled")=1
  do ##class(Security.Applications).Modify(pCSPName,.props)
  quit $$$OK
}

ClassMethod AddWorkflowRules() As %Status
{
    do ##class(EnsLib.Workflow.UserDefinition).CreateUser("SuperUser","SU Account")
	do ##class(EnsLib.Workflow.RoleDefinition).CreateRole("OrderTeam")
	do ##class(EnsLib.Workflow.RoleDefinition).AddUserToRole("OrderTeam","SuperUser")
}

}
