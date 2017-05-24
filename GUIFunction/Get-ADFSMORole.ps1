#获取AD环境中的操作主机角色
function Get-ADFSMORole
{
	
	Trap { "这里检测到了异常: $($_.Exception.Message)"; Continue }
	
	# Query with the current credentials
	$ForestRoles = Get-ADForest
	$DomainRoles = Get-ADDomain
	
	
	# Define Properties
	$Properties = @{
		SchemaMaster = $ForestRoles.SchemaMaster
		DomainNamingMaster = $ForestRoles.DomainNamingMaster
		InfraStructureMaster = $DomainRoles.InfraStructureMaster
		RIDMaster = $DomainRoles.RIDMaster
		PDCEmulator = $DomainRoles.PDCEmulator
	}
	#New-Object -TypeName PSObject -Property $Properties
	
	$Properties
	
}