Function New-bConnectApplicationDependency() {
    <#
        .Synopsis
            Creates a new Dependency for Applications.
            Empty or filled with given information.
        .Parameter DependencyId
            Guid of Application to use in Dependency
        .Parameter DependencyAppName
            Name of Application to use in Dependency
		.Parameter DependencyType
            Parameter with DependencyType
		.Parameter ValidForOS
            Parameter with ValidForOS
        .Outputs
            Dependency entry (see bConnect documentation for more details)
    #>

    [OutputType("System.Management.Automations.PSObject")]
    Param(
		[Parameter(Mandatory=$true)][string]$DependencyId,
		[Parameter(Mandatory=$true)][string]$DependencyAppName,
        [Parameter(Mandatory=$true)][ValidateSet("InstallBeforeIfNotInstalled","AlwaysInstallAfterwards","AlwaysInstallBefore","DeinstallBeforeIfInstalled","ErrorIfNotInstalled","ErrorIfInstalled",ignoreCase=$true)][string]$DependencyType,
        [Parameter(Mandatory=$true)][ValidateSet("NT4","Windows2000","WindowsXP","WindowsServer2003","WindowsVista","WindowsServer2008","Windows7","WindowsServer2008R2","WindowsXP_x64","WindowsServer2003_x64","WindowsVista_x64","WindowsServer2008_x64","Windows7_x64","WindowsServer2008R2_x64","Windows8","WindowsServer2012","Windows8_x64","WindowsServer2012_x64","Windows10","Windows10_x64","WindowsServer2016_x64","WindowsServer2019_x64",ignoreCase=$true)][array]$ValidForOS
    )

    $_new_Dependency = @{
        DependencyId = $DependencyId;
        DependencyAppName = $DependencyAppName;
        DependencyType = $DependencyType;
        ValidForOS = $ValidForOS
    }
<#     If(![string]::IsNullOrEmpty($DependencyId)) {
        $_new_Dependency += @{ DependencyId = $DependencyId }
    }

    If(![string]::IsNullOrEmpty($DependencyAppName)) {
        $_new_Dependency += @{ DependencyAppName = $DependencyAppName }
    }

    If(![string]::IsNullOrEmpty($DependencyType)) {
        $_new_Dependency += @{ DependencyType = $DependencyType }
    }

    If(![string]::IsNullOrEmpty($ValidForOS)) {
        $_new_Dependency += @{ ValidForOS = $ValidForOS } #>

    return $_new_Dependency
}
