Function New-bConnectIpNetwork() {
    <#
        .Synopsis
            Create a new Ip Network.
        .Parameter Name
            Valid Name for an Ip Network.
        .Parameter Scopes
            Valid Array of Ip Scopes (see bConnect documentation for more details).
        .Outputs
            Boolean
    #>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'low')]
    [OutputType("System.Management.Automations.PSObject","System.Boolean")]
    Param (
        [Parameter(Mandatory=$true)][string]$Name,
        [Parameter(Mandatory=$true)][array]$Scopes,
        [bConnectIpNetworkBandwidthMode]$BandwidthMode,
        [string]$Dips,
        [string]$WolRelay,
        [long]$MaxBandwidthKbits,
        [switch]$DuplicateWolToThisNetwork
    )

    $_connectVersion = Get-bConnectVersion
    If($_connectVersion -ge "1.0") {
        $_body = @{
            Name = $Name;
            Scopes = $Scopes;
        }

        If(![string]::IsNullOrEmpty($BandwidthMode)){
            $_body += @{ BandwidthMode = $BandwidthMode }
        }

        If(![string]::IsNullOrEmpty($Dips)){
            $_body += @{ Dips = $Dips }
        }

        If(![string]::IsNullOrEmpty($WolRelay)){
            $_body += @{ WolRelay = $WolRelay }
        }

        If(![string]::IsNullOrEmpty($MaxBandwidthKbits)){
            $_body += @{ MaxBandwidthKbits = $MaxBandwidthKbits }
        }

        If(![string]::IsNullOrEmpty($DuplicateWolToThisNetwork)){
            $_body += @{ DuplicateWolToThisNetwork = $DuplicateWolToThisNetwork }
        }

        if($PSCmdlet.ShouldProcess($_body.Name, "Create new Ip Network")){
            return Invoke-bConnectPost -Controller "IpNetworks" -Version $_connectVersion -Data $_body
        } else {
            return $false
        }
    } else {
        return $false
    }
}
