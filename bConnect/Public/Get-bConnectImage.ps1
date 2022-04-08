Function Get-bConnectImage() {
    <#
        .Synopsis
            Get the image for the specified GUID.
        .Parameter Id
            Valid GUID of an image.
        .Outputs
            Image (see bConnect documentation for more details).
    #>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$true)][string]$Id
    )

    $_connectVersion = Get-bConnectVersion
    If($_connectVersion -ge "1.0") {
        $_body = @{
            Id = $Id
        }

        return Invoke-bConnectGet -Controller "Images" -Version $_connectVersion -Data $_body
    } else {
        return $false
    }
}

