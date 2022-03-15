Function Edit-bConnectJobSteps() {
    <#
        .Synopsis
            Add, delete, exchange a step to an array of jobsteps or change the step type.
            Deploy steps with multiple application are not supported yet!
            Jobsteps can be identified either by an application GUID or the jobstep sequence.
            Uses New-bConnectJobStep.ps1 to generate jobsteps.
        .Parameter JobGuid
            Valid GUID of a job to work on.
        .Parameter Action
            Set the action to execute.
        .Parameter ApplicationGuid
            Valid GUID of a application to alter. It must be part of a step in the job.
        .Parameter NewApplicationGuid
            Valid GUID of a application to insert.
        .Parameter InstallType
            Set the new type of a job step.
        .Parameter Sequence
            Valid step number to alter. It must be part of a step in the job.
        .Parameter IgnoreAssignments
            Set the option to alter Jobs even if they are assigned to clients.
        .Outputs
            Changed Job object (see bConnect documentation for more details)
    #>

    Param(
        [Parameter(Mandatory=$true)][string]$JobGuid,
        [Parameter(Mandatory=$true)][ValidateSet("Add", "Delete", "Exchange", "ChangeType", ignoreCase=$true)][string]$Action,
        [Parameter(Mandatory=$false)][string]$ApplicationGuid,
        [Parameter(Mandatory=$false)][string]$NewApplicationGuid,
        [Parameter(Mandatory=$false)][ValidateSet("Deploy","SoftwareDeployUninstall",ignoreCase=$true)][string]$InstallType,
        [Parameter(Mandatory=$false)][int]$Sequence = 9999,
        [Parameter(Mandatory=$false)][boolean]$IgnoreAssignments = $false
    )

    $JobObj = Get-bConnectJob -JobGuid $JobGuid -Steps
    $JobObj_Steps = $JobObj.Steps
    $JobObj_Steps_Count = $JobObj_Steps.Count
    $JobObj_Steps_New = @()
    switch ($Action) {
        "Add"  {
            # Insert a jobstep.
            # If a sequence is given, the step is inserted right behind it.
            # If application GUID is provided, the step is inserted right behind it.
            # If no sequence and no application GUID is present, the step will be inserted at the end.
            If($Sequence -gt $JobObj_Steps_Count) {
                $Sequence = ($JobObj_Steps_Count + 1)
            }
            $NewJobStep = New-bConnectJobStep -ApplicationGuid $NewApplicationGuid -Sequence $Sequence -JobStepType $InstallType
            $NewSequence = 1
            foreach ($JobStep in $JobObj_Steps) {
                $JobStep.Sequence = $NewSequence
                $JobObj_Steps_New = $JobObj_Steps_New + $JobStep
                $NewSequence++
                
                If(($ApplicationGuid -eq $JobStep.Applications.id) -or ($Sequence -eq $NewSequence)) {
                    $NewJobStep.Sequence = $NewSequence
                    $JobObj_Steps_New = $JobObj_Steps_New + $NewJobStep
                    $Sequence = 0
                    $ApplicationGuid = "0"
                    $NewSequence++
                }
            }
            break
        }
        "Delete"  {
            If($Sequence -gt $JobObj_Steps_Count) {
                $Sequence = $JobObj_Steps_Count
            }
            $NewSequence = 1
            foreach ($JobStep in $JobObj_Steps) {
                If(($ApplicationGuid -eq $JobStep.Applications.id) -or ($Sequence -eq $NewSequence)) {
                    $NewSequence++
                    $Sequence = 0
                    $ApplicationGuid = "0"
                
                }else {
                    $JobStep.Sequence = $NewSequence
                    $JobObj_Steps_New = $JobObj_Steps_New + $JobStep
                    $NewSequence++
                }
            }
            break
        }
        "Exchange"  {
            If($Sequence -gt $JobObj_Steps_Count) {
                $Sequence = $JobObj_Steps_Count
            }
            $NewJobStep = New-bConnectJobStep -ApplicationGuid $NewApplicationGuid -Sequence $Sequence -JobStepType $InstallType
            $NewSequence = 1
            foreach ($JobStep in $JobObj_Steps) {
                If(($ApplicationGuid -eq $JobStep.Applications.id) -or ($Sequence -eq $NewSequence)) {
                    $NewJobStep.Sequence = $NewSequence
                    $JobObj_Steps_New = $JobObj_Steps_New + $NewJobStep
                    $Sequence = 0
                    $ApplicationGuid = "0"
                
                }else {
                    $JobStep.Sequence = $NewSequence
                    $JobObj_Steps_New = $JobObj_Steps_New + $JobStep
                }
                $NewSequence++
            }
            break
        }
        "ChangeType"  {
            $NewSequence = 1
            foreach ($JobStep in $JobObj_Steps) {
                If(($ApplicationGuid -eq $JobStep.Applications.id) -or ($Sequence -eq $NewSequence)) {
                    $JobStep.Type = $InstallType
                    $Sequence = 0
                    $ApplicationGuid = "0"
                }
                $NewSequence++
            }
            $JobObj_Steps_New = $JobObj_Steps
            break
        }
    }
    $JobObj.Steps = $JobObj_Steps_New
    Edit-bConnectJob -Job $JobObj -IgnoreAssignments $IgnoreAssignments
}
