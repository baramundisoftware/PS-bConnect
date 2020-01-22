Function New-bConnectApplicationUninstallUserSettings() {
    <#
        .Synopsis
            Creates a new UninstallUserSettings for Applications.
        .Parameter baramundiDeployScript
            Path to the deploy script that needs to be executed during uninstallation
        .Parameter ValidForInstallUser
            If set, script will also run for the install user
        .Parameter RunbDSVisible
            If set, bDS will run visible
        .Parameter CopyScriptToClient
            If set, script will be copied to client
        .Outputs
            UninstallUserSettings (see bConnect documentation for more details)
    #>

    [OutputType("System.Management.Automations.PSObject")]
    Param(
        [string]$baramundiDeployScript,
        [switch]$ValidForInstallUser,
        [switch]$RunbDSVisible,
        [switch]$CopyScriptToClient
    )

    $_new_uninstallUserSettings = @{
        baramundiDeployScript = $baramundiDeployScript;
        ValidForInstallUser = $ValidForInstallUser;
        RunbDSVisible = $RunbDSVisible;
        CopyScriptToClient = $CopyScriptToClient;
    }

    return $_new_uninstallUserSettings
}
