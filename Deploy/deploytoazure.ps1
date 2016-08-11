param($websiteName, $packOutput)
 $website = Get-AzureWebsite -Name $websiteName

 # get the SCM URL to use with MSDeploy.  
 # by default this will be the second in the array.
 $msdeployurl = $website.EnabledHostNames[1]

 $publishProperties = @{'WebPublishMethod'='MSDeploy';
                 'MSDeployServiceUrl'=$msdeployurl;
                 'DeployIisAppPath'=$website.Name;
                 'Username'=$website.PublishingUsername;
                 'Password'=$website.PublishingPassword}

#  $publishScript = "./default-publish.ps1"

#  . $publishScript -publishProperties $publishProperties  -packOutput $packOutput

#  [cmdletbinding(SupportsShouldProcess=$true)]
# param($publishProperties=@{}, $packOutput, $pubProfilePath)

# to learn more about this file visit https://go.microsoft.com/fwlink/?LinkId=524327

try{
    if ($publishProperties['ProjectGuid'] -eq $null){
        $publishProperties['ProjectGuid'] = ''
    }

    $publishModulePath = Join-Path (Split-Path $MyInvocation.MyCommand.Path) 'publish-module.psm1'
    Import-Module $publishModulePath -DisableNameChecking -Force

    # call Publish-AspNet to perform the publish operation
    Publish-AspNet -publishProperties $publishProperties -packOutput $packOutput -pubProfilePath $pubProfilePath
}
catch{
    "An error occurred during publish.`n{0}" -f $_.Exception.Message | Write-Error
}