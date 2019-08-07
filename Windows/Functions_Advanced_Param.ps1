Param(

[Parameter(Mandatory=$true)]

[ValidateNotNullOrEmpty()] # 参数不允许空值

[String]$First,

[Parameter(Mandatory=$true)]

[AllowEmptyString()] # 参数允许空值

[String]$Last

)

# 获取Function Param的帮助信息

Update-Help
Get-Help about_functions_Advanced_Parameters