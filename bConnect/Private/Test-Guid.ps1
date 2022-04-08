Function Test-Guid() {
    <#
        .Synopsis
            Test for valid GUID.
        .Parameter Guid
            String to test.
        .Outputs
            Bool
    #>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$true)][string]$Guid
    )

    If($Guid -match "\b[A-F0-9]{8}(?:-[A-F0-9]{4}){3}-[A-F0-9]{12}\b") {
        return $true
    } else {
        return $false
    }
}
