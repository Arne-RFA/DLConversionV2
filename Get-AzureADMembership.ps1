<#
    .SYNOPSIS

    This function obtains the DL membership of the Office 365 distribution group.

    .DESCRIPTION

    This function obtains the DL membership of the Office 365 distribution group.

    .PARAMETER GroupObjectID

    The Object ID to obtain membership values from Azure.

    .OUTPUTS

    Returns the membership array of the DL in Office 365.

    .EXAMPLE

    get-o365dlMembership -groupSMTPAddress Address

    #>
    Function Get-AzureADMembership
     {
        [cmdletbinding()]

        Param
        (
            [Parameter(Mandatory = $true)]
            [string]$groupObjectID,
            [Parameter(Mandatory = $false)]
            [boolean]$isHealthReport=$false
        )

        #Output all parameters bound or unbound and their associated values.

        write-functionParameters -keyArray $MyInvocation.MyCommand.Parameters.Keys -parameterArray $PSBoundParameters -variableArray (Get-Variable -Scope Local -ErrorAction Ignore)

        #Declare function variables.

        $functionDLMembership=$NULL #Holds the return information for the group query.

        #Start function processing.

        Out-LogFile -string "********************************************************************************"
        Out-LogFile -string "BEGIN GET-AZUREADMEMBERSHIP"
        Out-LogFile -string "********************************************************************************"

        #Get the recipient using the exchange online powershell session.

        out-logfile -string "Attempting to obtain the Azure AD Group membership."

        if ($isHealthReport -eq $FALSE)
        {
            try {
                $functionDLMembership = get-azureADGroupMember -objectID $groupobjectID -all:$TRUE -errorAction STOP
            }
            catch {
                out-logfile -string "Unable to obtain the azure group membership."
                out-logfile -string $_ -isError:$TRUE
            }
        }
        else 
        {
            try {
                $functionDLMembership = get-azureADGroupMember -objectID $groupobjectID -all:$TRUE -errorAction STOP | select-object objectID,objectType,mail,mailnickname,onPremisesSecurityIdentifier,proxyAddresses,userPrincipalName,userType,provisioningErrors
            }
            catch {
                out-logfile -string "Unable to obtain the azure group membership."
                out-logfile -string $_ -isError:$TRUE
            }
        }



        if ($functionDLMembership.count -gt 0)
        {
            out-logfile -string $functionDLMembership
        }
        else
        {
            out-logfile -string "No Azure AD Group members in the specified group."
        }
        
        Out-LogFile -string "END GET-AZUREADMEMBERSHIP"
        Out-LogFile -string "********************************************************************************"
        
        #Return the membership to the caller.
        
        return $functionDLMembership
    }