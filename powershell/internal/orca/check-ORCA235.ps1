# Generated on 04/16/2025 21:38:23 by .\build\orca\Update-OrcaTests.ps1

using module ".\orcaClass.psm1"

[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '')]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingEmptyCatchBlock', '')]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSPossibleIncorrectComparisonWithNull', '')]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars', '')]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingCmdletAliases', '')]
param()




class ORCA235 : ORCACheck
{
    <#
    
        CONSTRUCTOR with Check Header Data
    
    #>

    ORCA235()
    {
        $this.Control="235"
        $this.Area="SPF"
        $this.Name="SPF Records"
        $this.PassText="SPF records is set up for all your custom domains"
        $this.FailRecommendation="Set up SPF records to prevent spoofing"
        $this.Importance="SPF helps validate outbound email sent from your custom domain. Microsoft 365 uses the Sender Policy Framework (SPF) TXT record in DNS to ensure that destination email systems trust messages sent from your custom domain."
        $this.ExpandResults=$True
        $this.CheckType=[CheckType]::ObjectPropertyValue
        $this.ObjectType="Domain"
        $this.ItemName="SPF Record Lookup"
        $this.DataType="Is HardFail"
        $this.ChiValue=[ORCACHI]::Low
        $this.Links= @{
            "Use SPF to validate outbound email sent from your custom domain in Office 365"="https://aka.ms/orca-spf-docs-1"
        }
    }

    <#
    
        RESULTS
    
    #>

    GetResults($Config)
    {

        # Check pre-requisites for DNS resolution
        If(!(Get-Command "Resolve-DnsName" -ErrorAction:SilentlyContinue))
        {
            # No Resolve-DnsName command
            ForEach($AcceptedDomain in $Config["AcceptedDomains"])
            {
                $ConfigObject = [ORCACheckConfig]::new()
                $ConfigObject.Object = $($AcceptedDomain.Name)
                $ConfigObject.SetResult([ORCAConfigLevel]::All,[ORCAResult]::Informational)
                $ConfigObject.ConfigItem = "Pre-requisites not installed"
                $ConfigObject.ConfigData = "Resolve-DnsName is not found on ORCA computer. Required for DNS checks."
                $this.AddConfig($ConfigObject)
            }

            $this.CheckFailed = $true
            $this.CheckFailureReason = "Resolve-DnsName is not found on ORCA computer and is required for DNS checks."
            
        }
        else 
        {
            # Check SPF
            ForEach($AcceptedDomain in $Config["AcceptedDomains"]) 
            {  
                $SplatParameters = @{
                    'ErrorAction' = 'SilentlyContinue'
                }

                # If alternate DNS specified, add Server param
                if($null -ne $this.ORCAParams.AlternateDNS)
                {
                    $SplatParameters["Server"] = $this.ORCAParams.AlternateDNS
                }

                $HasMailbox = $false

                try
                {
                    $mailbox = Resolve-DnsName -Name $($AcceptedDomain.Name) -Type MX -ErrorAction:Stop @SplatParameters

                    if($null -ne $mailbox -and $mailbox.Count -gt 0)
                    {
                        $HasMailbox = $true
                    }
                }
                Catch{}
                
                If($HasMailbox) 
                {   
                    # Check objects
                    $ConfigObject = [ORCACheckConfig]::new()
                    $ConfigObject.Object = $($AcceptedDomain.Name)

                    $SPF = Resolve-DnsName -Name $($AcceptedDomain.Name) -Type TXT @SplatParameters | where-object { $_.strings -match "v=spf1" } | Select-Object -ExpandProperty strings -ErrorAction SilentlyContinue
                    if ($SPF -match "redirect") {
                        $redirect = $SPF.Split(" ")
                        $RedirectName = $redirect -match "redirect" -replace "redirect="
                        $SPF = Resolve-DnsName -Name "$RedirectName" -Type TXT @SplatParameters | where-object { $_.strings -match "v=spf1" } | Select-Object -ExpandProperty strings -ErrorAction SilentlyContinue
                    }

                    $SpfAdvisory = "No SPF record"
                    if ( $null -eq $SPF) {
                        $SpfAdvisory = "No SPF record"
                    }
                    if ($SPF -is [array]) {
                        $SpfAdvisory = "More than one SPF-record"
                    }
                    Else {
                        switch -Regex ($SPF) {
                        '~all' {
                            $SpfAdvisory = "Soft Fail"
                        }
                        '-all' {
                            $SpfAdvisory = "Hard Fail"
                        }
                        Default {
                            $SpfAdvisory = "No qualifier found"
                        }
                    }
                    }

                    # Get matching DKIM signing configuration          
        
                    If($true)
                    {
                        $ConfigObject.ConfigItem="$($SPF)"

                        if($SpfAdvisory -eq "Hard Fail")
                        {
                            $ConfigObject.ConfigData = "Yes"
                        }
                        Elseif( ($SpfAdvisory -eq "Soft Fail") -or ($SpfAdvisory -eq "No qualifier found"))
                        {
                            $ConfigObject.ConfigData = "No"
                        }
                        Else
                        {
                            $ConfigObject.ConfigData = "Not Detected"
                        }

                        if($SpfAdvisory -eq "Hard Fail")
                        {
                            $ConfigObject.SetResult([ORCAConfigLevel]::Standard,"Pass")
                        }
                        Else 
                        {
                            $ConfigObject.SetResult([ORCAConfigLevel]::Standard,"Fail")
                        }
                    }
                    Else
                    {
                        $ConfigObject.ConfigItem = "Not Detected"
                        $ConfigObject.ConfigData = "Not Detected"
                        $ConfigObject.SetResult([ORCAConfigLevel]::Standard,"Fail")
                    }

                    # Add config to check
                    $this.AddConfig($ConfigObject)
                }   
            }    
        }
       
    }
}


