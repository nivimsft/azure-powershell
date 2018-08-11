<#
Copyright (c) Microsoft Corporation. All rights reserved.
Licensed under the MIT License. See License.txt in the project root for license information.

Code generated by Microsoft (R) PSSwagger
Changes may cause incorrect behavior and will be lost if the code is regenerated.
#>

<#
.SYNOPSIS
    Update an existing compute quota using the provided parameters.

.DESCRIPTION
    Update an existing compute quota.

.PARAMETER Name
    The name of the quota.

.PARAMETER Location
    Location of the resource.

.PARAMETER AvailabilitySetCount
    Maximum number of availability sets allowed.

.PARAMETER CoresLimit
    Maximum number of core allowed.

.PARAMETER VmScaleSetCount
    Maximum number of scale sets allowed.

.PARAMETER VirtualMachineCount
    Maximum number of virtual machines allowed.

.PARAMETER MaxAllocationStandardManagedDisksAndSnapshots
	Maximum number of standard managed disks and snapshots allowed

.PARAMETER MaxAllocationPremiumManagedDisksAndSnapshots
	Maximum number of Premium managed disks and snapshots allowed

.PARAMETER ResourceId
    The ARM compute quota id.

.PARAMETER InputObject
    Posbbily modified compute quota returned form Get-AzsComputeQuota.

.EXAMPLE

    PS C:\> Set-AzsComputeQuota -Name Quota1 -CoresLimit 10

    Update a compute quota.

#>
function Set-AzsComputeQuota {
    [OutputType([Microsoft.AzureStack.Management.Compute.Admin.Models.Quota])]
    [CmdletBinding(DefaultParameterSetName = 'Update', SupportsShouldProcess = $true)]
    param(
        [Parameter(Mandatory = $true, ParameterSetName = 'Update')]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $Name,

        [Parameter(Mandatory = $false)]
        [int32]
        $AvailabilitySetCount,

        [Parameter(Mandatory = $false)]
        [int32]
        $CoresLimit,

        [Parameter(Mandatory = $false)]
        [int32]
        $VmScaleSetCount,

        [Parameter(Mandatory = $false)]
        [int32]
        $VirtualMachineCount,

        [Parameter(Mandatory = $false)]
        [int32]
		$MaxAllocationStandardManagedDisksAndSnapshots,

        [Parameter(Mandatory = $false)]
        [int32]
		$MaxAllocationPremiumManagedDisksAndSnapshots,

        [Parameter(Mandatory = $false)]
        [System.String]
        $Location,

        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'ResourceId')]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $ResourceId,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'InputObject')]
        [ValidateNotNullOrEmpty()]
        [Microsoft.AzureStack.Management.Compute.Admin.Models.Quota]
        $InputObject
    )

    Begin {
        Initialize-PSSwaggerDependencies -Azure
        $tracerObject = $null
        if (('continue' -eq $DebugPreference) -or ('inquire' -eq $DebugPreference)) {
            $oldDebugPreference = $global:DebugPreference
            $global:DebugPreference = "continue"
            $tracerObject = New-PSSwaggerClientTracing
            Register-PSSwaggerClientTracing -TracerObject $tracerObject
        }
    }

    Process {


        $NewQuota = $null

        if ('InputObject' -eq $PsCmdlet.ParameterSetName -or 'ResourceId' -eq $PsCmdlet.ParameterSetName) {
            $GetArmResourceIdParameterValue_params = @{
                IdTemplate = '/subscriptions/{subscriptionId}/providers/Microsoft.Compute.Admin/locations/{location}/quotas/{quotaName}'
            }

            if ('ResourceId' -eq $PsCmdlet.ParameterSetName) {
                $GetArmResourceIdParameterValue_params['Id'] = $ResourceId
            } else {
                $GetArmResourceIdParameterValue_params['Id'] = $InputObject.Id
                $NewQuota = $InputObject
            }
            $ArmResourceIdParameterValues = Get-ArmResourceIdParameterValue @GetArmResourceIdParameterValue_params

            $Location = $ArmResourceIdParameterValues['location']
            $Name = $ArmResourceIdParameterValues['quotaName']
        }

        if ($PSCmdlet.ShouldProcess("$Name" , "Update compute quota")) {

            $NewServiceClient_params = @{
                FullClientTypeName = 'Microsoft.AzureStack.Management.Compute.Admin.ComputeAdminClient'
            }

            $GlobalParameterHashtable = @{}
            $NewServiceClient_params['GlobalParameterHashtable'] = $GlobalParameterHashtable

            $GlobalParameterHashtable['SubscriptionId'] = $null
            if ($PSBoundParameters.ContainsKey('SubscriptionId')) {
                $GlobalParameterHashtable['SubscriptionId'] = $PSBoundParameters['SubscriptionId']
            }

            $ComputeAdminClient = New-ServiceClient @NewServiceClient_params

            if ([System.String]::IsNullOrEmpty($Location)) {
                $Location = (Get-AzureRMLocation).Location
            }

            if ('Update' -eq $PsCmdlet.ParameterSetName -or 'InputObject' -eq $PsCmdlet.ParameterSetName -or 'ResourceId' -eq $PsCmdlet.ParameterSetName) {

                if ($NewQuota -eq $null) {
                    $NewQuota = Get-AzsComputeQuota -Location $Location -Name $Name
                }

                # Update the Quota object from anything passed in
                $flattenedParameters = @('AvailabilitySetCount', 'CoresLimit', 'VmScaleSetCount', 'VirtualMachineCount', 'MaxAllocationStandardManagedDisksAndSnapshots', 'MaxAllocationPremiumManagedDisksAndSnapshots' )
                $flattenedParameters | ForEach-Object {
                    if ($PSBoundParameters.ContainsKey($_)) {
                        $NewQuota.$($_) = $PSBoundParameters[$_]
                    }
                }

                Write-Verbose -Message 'Performing operation update on $ComputeAdminClient.'
                $TaskResult = $ComputeAdminClient.Quotas.CreateOrUpdateWithHttpMessagesAsync($Location, $Name, $NewQuota)
            } else {
                Write-Verbose -Message 'Failed to map parameter set to operation method.'
                throw 'Module failed to find operation to execute.'
            }

            if ($TaskResult) {
                $GetTaskResult_params = @{
                    TaskResult = $TaskResult
                }
                Get-TaskResult @GetTaskResult_params
            }
        }
    }

    End {
        if ($tracerObject) {
            $global:DebugPreference = $oldDebugPreference
            Unregister-PSSwaggerClientTracing -TracerObject $tracerObject
        }
    }
}

