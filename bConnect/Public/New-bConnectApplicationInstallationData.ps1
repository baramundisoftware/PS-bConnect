Function New-bConnectApplicationInstallationData() {
    <#
        .Synopsis
            Creates a new InstallationData for Applications.
            Empty or filled with given information.
        .Parameter Command
            Installation command
        .Parameter Parameter
            Parameter for installation command
        .Parameter ResponseFile
            ResponseFile for the installation
        .Parameter EngineFile
            File for installation engine (Engine will be set automatically based on EngineFile; only bDS supported in this PS module)
        .Parameter Options
            InstallApplicationOption object
        .Parameter UserSettings
            InstallUserSettings object
        .Outputs
            InstallationData (see bConnect documentation for more details)
    #>

    [OutputType("System.Management.Automations.PSObject")]
    Param(
        [string]$Command,
        [string]$Parameter,
        [string]$ResponseFile,
        [string]$EngineFile,
        [PSCustomObject]$Options,
        [PSCustomObject]$UserSettings
    )

    $_new_installationData = @{}

    If(![string]::IsNullOrEmpty($Command)) {
        $_new_installationData += @{ Command = $Command }
    }

    If(![string]::IsNullOrEmpty($Parameter)) {
        $_new_installationData += @{ Parameter = $Parameter }
    }

    If(![string]::IsNullOrEmpty($ResponseFile)) {
        $_new_installationData += @{ ResponseFile = $ResponseFile }
    }

    If(![string]::IsNullOrEmpty($EngineFile)) {
        $_new_installationData += @{ Engine = "baramundi Deploy Script"; EngineFile = $EngineFile }
    }

    If($Options) {
        $_new_installationData += @{ Options = $Options }
    }

    If($UserSettings) {
        $_new_installationData += @{ UserSettings = $UserSettings }
    }

    return $_new_installationData
}
