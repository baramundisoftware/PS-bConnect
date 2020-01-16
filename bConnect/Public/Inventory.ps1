#--- Inventory ---
Function Get-bConnectInventoryDataRegistryScan() {
    <#
        .Synopsis
            Get registry scans.
        .Parameter EndpointGuid
            Valid GUID of a endpoint.
        .Outputs
            Inventory (see bConnect documentation for more details).
    #>

    Param (
        [string]$EndpointGuid
    )

    $_connectVersion = Get-bConnectVersion
    If($_connectVersion -ge "1.0") {
        If($EndpointGuid) {
            $_body = @{
                EndpointId = $EndpointGuid
            }
        }

        return Invoke-bConnectGet -Controller "InventoryDataRegistryScans" -Version $_connectVersion -Data $_body
    } else {
        return $false
    }
}

Function Get-bConnectInventoryDataFileScan() {
    <#
        .Synopsis
            Get file scans.
        .Parameter EndpointGuid
            Valid GUID of a endpoint.
        .Outputs
            Inventory (see bConnect documentation for more details).
    #>

    Param (
        [string]$EndpointGuid
    )

    $_connectVersion = Get-bConnectVersion
    If($_connectVersion -ge "1.0") {
        If($EndpointGuid) {
            $_body = @{
                EndpointId = $EndpointGuid
            }
        }

        return Invoke-bConnectGet -Controller "InventoryDataFileScans" -Version $_connectVersion -Data $_body
    } else {
        return $false
    }
}

Function Get-bConnectInventoryDataWmiScan() {
    <#
        .Synopsis
            Get WMI scans.
        .Parameter EndpointGuid
            Valid GUID of a endpoint.
        .Parameter TemplateName
            Valid name of a inventory template
        .Parameter ScanTerm
            "latest" or specified as UTC time in the format “yyyy-MM-ddThh:mm:ssZ” (y=year, M=month, d=day, h=hours, m=minutes, s=seconds).
        .Outputs
            Inventory (see bConnect documentation for more details).
    #>

    Param (
        [string]$EndpointGuid,
        [string]$TemplateName,
        [string]$ScanTerm
    )

    $_connectVersion = Get-bConnectVersion
    If($_connectVersion -ge "1.0") {
        $_body = @{}
        If($EndpointGuid) {
            $_body += @{ EndpointId = $EndpointGuid }
        }
        If($TemplateName) {
            $_body += @{ TemplateName = $TemplateName }
        }
        If($ScanTerm) {
            $_body += @{ Scan = $ScanTerm }
        }

        return Invoke-bConnectGet -Controller "InventoryDataWmiScans" -Version $_connectVersion -Data $_body
    } else {
        return $false
    }
}

Function Get-bConnectInventoryDataCustomScan() {
    <#
        .Synopsis
            Get custom scans.
        .Parameter EndpointGuid
            Valid GUID of a endpoint.
        .Parameter TemplateName
            Valid name of a inventory template
        .Parameter ScanTerm
            "latest" or specified as UTC time in the format “yyyy-MM-ddThh:mm:ssZ” (y=year, M=month, d=day, h=hours, m=minutes, s=seconds).
        .Outputs
            Inventory (see bConnect documentation for more details).
    #>

    Param (
        [string]$EndpointGuid,
        [string]$TemplateName,
        [string]$ScanTerm
    )

    $_connectVersion = Get-bConnectVersion
    If($_connectVersion -ge "1.0") {
        $_body = @{}
        If($EndpointGuid) {
            $_body += @{ EndpointId = $EndpointGuid }
        }
        If($TemplateName) {
            $_body += @{ TemplateName = $TemplateName }
        }
        If($ScanTerm) {
            $_body += @{ Scan = $ScanTerm }
        }

        return Invoke-bConnectGet -Controller "InventoryDataCustomScans" -Version $_connectVersion -Data $_body
    } else {
        return $false
    }
}

Function Get-bConnectInventoryDataHardwareScan() {
    <#
        .Synopsis
            Get Hardware scans.
        .Parameter EndpointGuid
            Valid GUID of a endpoint.
        .Parameter TemplateName
            Valid name of a inventory template
        .Parameter ScanTerm
            "latest" or specified as UTC time in the format “yyyy-MM-ddThh:mm:ssZ” (y=year, M=month, d=day, h=hours, m=minutes, s=seconds).
        .Outputs
            Inventory (see bConnect documentation for more details).
    #>

    Param (
        [string]$EndpointGuid,
        [string]$TemplateName,
        [string]$ScanTerm
    )

    $_connectVersion = Get-bConnectVersion
    If($_connectVersion -ge "1.0") {
        $_body = @{}
        If($EndpointGuid) {
            $_body += @{ EndpointId = $EndpointGuid }
        }
        If($TemplateName) {
            $_body += @{ TemplateName = $TemplateName }
        }
        If($ScanTerm) {
            $_body += @{ Scan = $ScanTerm }
        }

        return Invoke-bConnectGet -Controller "InventoryDataHardwareScans" -Version $_connectVersion -Data $_body
    } else {
        return $false
    }
}

Function Get-bConnectInventoryDataSnmpScan() {
    <#
        .Synopsis
            Get SNMP scans.
        .Parameter EndpointGuid
            Valid GUID of a endpoint.
        .Outputs
            Inventory (see bConnect documentation for more details).
    #>

    Param (
        [string]$EndpointGuid
    )

    $_connectVersion = Get-bConnectVersion
    If($_connectVersion -ge "1.0") {
        If($EndpointGuid) {
            $_body = @{
                EndpointId = $EndpointGuid
            }
        }

        return Invoke-bConnectGet -Controller "InventoryDataSnmpScans" -Version $_connectVersion -Data $_body
    } else {
        return $false
    }
}

Function Get-bConnectInventoryOverview() {
    <#
        .Synopsis
            Get overview over all inventory scans.
        .Parameter EndpointGuid
            Valid GUID of a endpoint.
        .Outputs
            InventoryOverview (see bConnect documentation for more details).
    #>

    Param (
        [string]$EndpointGuid
    )

    $_connectVersion = Get-bConnectVersion
    If($_connectVersion -ge "1.0") {
        If($EndpointGuid) {
            $_body = @{
                EndpointId = $EndpointGuid
            }
        }

        return Invoke-bConnectGet -Controller "InventoryOverviews" -Version $_connectVersion -Data $_body
    } else {
        return $false
    }
}

Function Get-bConnectSoftwareScanRule() {
    <#
        .Synopsis
            Get all software scan rules.
        .Outputs
            SoftwareScanRule (see bConnect documentation for more details).
    #>

    $_connectVersion = Get-bConnectVersion
    If($_connectVersion -ge "1.0") {

        return Invoke-bConnectGet -Controller "SoftwareScanRules" -Version $_connectVersion -Data $_body
    } else {
        return $false
    }
}
Function Get-bConnectSoftwareScanRuleCounts() {
    <#
        .Synopsis
            Get all software scan rule counts.
        .Outputs
            SoftwareScanRuleCount (see bConnect documentation for more details).
    #>

    $_connectVersion = Get-bConnectVersion
    If($_connectVersion -ge "1.0") {

        return Invoke-bConnectGet -Controller "SoftwareScanRuleCounts" -Version $_connectVersion -Data $_body
    } else {
        return $false
    }
}

Function Get-bConnectEndpointInvSoftware() {
    <#
        .Synopsis
            Get all links between endpoints and software scan rules.
        .Outputs
            EndpointInvSoftware (see bConnect documentation for more details).
    #>

    $_connectVersion = Get-bConnectVersion
    If($_connectVersion -ge "1.0") {

        return Invoke-bConnectGet -Controller "EndpointInvSoftware" -Version $_connectVersion -Data $_body
    } else {
        return $false
    }
}

Function Get-bConnectInventoryAppScan() {
    <#
        .Synopsis
            Get app inventory data for mobile endpoints.
        .Parameter EndpointGuid
            Valid GUID of a endpoint.
        .Outputs
            InventoryApp (see bConnect documentation for more details).
    #>

    Param (
        [string]$EndpointGuid
    )

    $_connectVersion = Get-bConnectVersion
    If($_connectVersion -ge "1.0") {
        If($EndpointGuid) {
            $_body = @{
                EndpointId = $EndpointGuid
            }
        }

        return Invoke-bConnectGet -Controller "InventoryAppScans" -Version $_connectVersion -Data $_body
    } else {
        return $false
    }
}

Function Remove-bConnectInventoryDataRegistryScan() {
    <#
        .Synopsis
            Remove all registry scans from specified endpoint.
        .Parameter EndpointGuid
            Valid GUID of a endpoint.
        .Outputs
            Bool
    #>

    Param (
        [Parameter(Mandatory=$true)][string]$EndpointGuid
    )

    $_connectVersion = Get-bConnectVersion
    If($_connectVersion -ge "1.0") {
        $_body = @{
            EndpointId = $EndpointGuid;
        }
        return Invoke-bConnectDelete -Controller "InventoryDataRegistryScans" -Version $_connectVersion -Data $_body
    } else {
        return $false
    }
}

Function Remove-bConnectInventoryDataFileScan() {
    <#
        .Synopsis
            Remove all file scans from specified endpoint.
        .Parameter EndpointGuid
            Valid GUID of a endpoint.
        .Outputs
            Bool
    #>

    Param (
        [Parameter(Mandatory=$true)][string]$EndpointGuid
    )

    $_connectVersion = Get-bConnectVersion
    If($_connectVersion -ge "1.0") {
        $_body = @{
            EndpointId = $EndpointGuid;
        }
        return Invoke-bConnectDelete -Controller "InventoryDataFileScans" -Version $_connectVersion -Data $_body
    } else {
        return $false
    }
}

Export-ModuleMember Get-bConnectInventoryDataRegistryScan
Export-ModuleMember Remove-bConnectInventoryDataRegistryScan
Export-ModuleMember Get-bConnectInventoryDataFileScan
Export-ModuleMember Remove-bConnectInventoryDataFileScan
Export-ModuleMember Get-bConnectInventoryDataWmiScan
Export-ModuleMember Get-bConnectInventoryDataCustomScan
Export-ModuleMember Get-bConnectInventoryDataHardwareScan
Export-ModuleMember Get-bConnectInventoryDataSnmpScan
Export-ModuleMember Get-bConnectInventoryOverview
Export-ModuleMember Get-bConnectSoftwareScanRule
Export-ModuleMember Get-bConnectSoftwareScanRuleCounts
Export-ModuleMember Get-bConnectEndpointInvSoftware
Export-ModuleMember Get-bConnectInventoryAppScan
