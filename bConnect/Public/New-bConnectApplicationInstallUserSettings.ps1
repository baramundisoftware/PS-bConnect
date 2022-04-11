Function New-bConnectApplicationInstallUserSettings() {
    <#
        .Synopsis
            Creates a new InstallUserSettings for Applications.
        .Parameter baramundiDeployScript
            Path to the deploy script that needs to be executed during installation
        .Parameter ValidForInstallUser
            If set, script will also run for the install user
        .Parameter RunbDSVisible
            If set, bDS will run visible
        .Parameter CopyScriptToClient
            If set, script will be copied to client
        .Parameter ExecuteAtEveryLogin
            If set, script will run on every login
        .Outputs
            InstallUserSettings (see bConnect documentation for more details)
    #>

    [CmdletBinding()]
    [OutputType("System.Management.Automations.PSObject")]
    Param(
        [string]$baramundiDeployScript,
        [switch]$ValidForInstallUser,
        [switch]$RunbDSVisible,
        [switch]$CopyScriptToClient,
        [switch]$ExecuteAtEveryLogin
    )

    $_new_installUserSettings = @{
        baramundiDeployScript = $baramundiDeployScript;
        ValidForInstallUser = $ValidForInstallUser;
        RunbDSVisible = $RunbDSVisible;
        CopyScriptToClient = $CopyScriptToClient;
        ExecuteAtEveryLogin = $ExecuteAtEveryLogin;
    }

    return $_new_installUserSettings
}
