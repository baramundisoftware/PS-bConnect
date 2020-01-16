#--- Job Instance ---
Function Get-bConnectJobInstance() {
    <#
        .Synopsis
            Get specified jobinstance by GUID, all jobinstances of a job or all jobinstances on a endpoint.
        .Parameter JobInstanceGuid
            Valid GUID of a jobinstance.
        .Parameter JobGuid
            Valid GUID of a job.
        .Parameter EndpointGuid
            Valid GUID of a endpoint
        .Parameter Username
            Valid Username (in combination with EndpointGuid)
        .Outputs
            Array of JobInstance (see bConnect documentation for more details).
    #>

    Param (
        [string]$JobInstanceGuid,
        [string]$JobGuid,
        [string]$EndpointGuid,
        [string]$Username
    )

    $_connectVersion = Get-bConnectVersion
    If($_connectVersion -ge "1.0") {
        If($JobGuid) {
            $_body = @{
                JobId = $JobGuid
            }
        }

        If($EndpointGuid) {
            $_body = @{
                EndpointId = $EndpointGuid
            }
        }

        If($JobInstanceGuid) {
            $_body = @{
                Id = $JobInstanceGuid
            }
        }

        If($Username -and $EndpointGuid) {
            $_body = @{
                User = $Username
                EndpointId = $EndpointGuid
            }
        }

        return Invoke-bConnectGet -Controller "JobInstances" -Version $_connectVersion -Data $_body
    } else {
        return $false
    }
}

Function New-bConnectJobInstance() {
    <#
        .Synopsis
            Assign the specified job to a endpoint.
        .Parameter EndpointGuid
            Valid GUID of a endpoint.
        .Parameter JobGuid
            Valid GUID of a job.
        .Parameter StartIfExists
            Restart the existing jobinstance if there is one.
        .Parameter Initiator
            Set the Initiator of the new job instance.
        .Outputs
            JobInstance (see bConnect documentation for more details).
    #>

    Param (
        [Parameter(Mandatory=$true)][string]$EndpointGuid,
        [Parameter(Mandatory=$true)][string]$JobGuid,
        [string]$Initiator,
        [switch]$StartIfExists
    )

    $_connectVersion = Get-bConnectVersion
    If($_connectVersion -ge "1.0") {
        $_body = @{
            EndpointId = $EndpointGuid;
            JobId = $JobGuid;
            StartIfExists = $StartIfExists.ToString()
        }

        If($JobInstanceGuid) {
            $_body += @{
                Initiator = $Initiator
            }
        }

        return Invoke-bConnectGet -Controller "JobInstances" -Version $_connectVersion -Data $_body
    } else {
        return $false
    }
}

Function Start-bConnectJobInstance() {
    <#
        .Synopsis
            Start the specified jobinstance.
        .Parameter JobInstanceGuid
            Valid GUID of a jobinstance.
        .Outputs
            Bool
    #>

    Param (
        [string]$JobInstanceGuid
    )

    $_connectVersion = Get-bConnectVersion
    If($_connectVersion -ge "1.0") {
        $_body = @{
            Id = $JobInstanceGuid;
            Cmd = "start"
        }

        return Invoke-bConnectGet -Controller "JobInstances" -Version $_connectVersion -Data $_body
    } else {
        return $false
    }
}

Function Stop-bConnectJobInstance() {
    <#
        .Synopsis
            Stop the specified jobinstance.
        .Parameter JobInstanceGuid
            Valid GUID of a jobinstance.
        .Outputs
            Bool
    #>

    Param (
        [string]$JobInstanceGuid
    )

    $_connectVersion = Get-bConnectVersion
    If($_connectVersion -ge "1.0") {
        $_body = @{
            Id = $JobInstanceGuid;
            Cmd = "stop"
        }

        return Invoke-bConnectGet -Controller "JobInstances" -Version $_connectVersion -Data $_body
    } else {
        return $false
    }
}

Function Resume-bConnectJobInstance() {
    <#
        .Synopsis
            Resume the specified jobinstance.
        .Parameter JobInstanceGuid
            Valid GUID of a jobinstance.
        .Outputs
            Bool
    #>

    Param (
        [string]$JobInstanceGuid
    )

    $_connectVersion = Get-bConnectVersion
    If($_connectVersion -ge "1.0") {
        $_body = @{
            Id = $JobInstanceGuid;
            Cmd = "resume"
        }

        return Invoke-bConnectGet -Controller "JobInstances" -Version $_connectVersion -Data $_body
    } else {
        return $false
    }
}

Function Remove-bConnectJobInstance() {
    <#
        .Synopsis
            Remove specified jobinstance.
        .Parameter JobInstanceGuid
            Valid GUID of a jobinstance.
        .Outputs
            Bool
    #>

    Param (
        [Parameter(Mandatory=$true)][string]$JobInstanceGuid
    )

    $_connectVersion = Get-bConnectVersion
    If($_connectVersion -ge "1.0") {
        $_body = @{
            Id = $JobInstanceGuid
        }

        return Invoke-bConnectDelete -Controller "JobInstances" -Version $_connectVersion -Data $_body
    } else {
        return $false
    }
}

Export-ModuleMember Get-bConnectJobInstance
Export-ModuleMember New-bConnectJobInstance
Export-ModuleMember Start-bConnectJobInstance
Export-ModuleMember Stop-bConnectJobInstance
Export-ModuleMember Resume-bConnectJobInstance
Export-ModuleMember Remove-bConnectJobInstance
