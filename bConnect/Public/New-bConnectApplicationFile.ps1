Function New-bConnectApplicationFile() {
    <#
        .Synopsis
            Creates a new ApplicationFile for Applications.
        .Parameter Source
            Path or file
        .Parameter Type
            Type of the source
        .Outputs
            ApplicationFile (see bConnect documentation for more details)
    #>

    [CmdletBinding()]
    [OutputType("System.Management.Automations.PSObject")]
    Param(
        [Parameter(Mandatory=$true)][string]$Source,
        [Parameter(Mandatory=$true)][ValidateSet("FolderWithSubFolders","SingleFolder","File",ignoreCase=$true)][string]$Type
    )

    $_new_applicationFile = @{
        Source = $Source;
        Type = $Type;
    }

    return $_new_applicationFile
}
