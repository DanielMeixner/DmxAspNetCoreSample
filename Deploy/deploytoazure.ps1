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

 $publishScript = "default-publish.ps1"

 . $publishScript -publishProperties $publishProperties  -packOutput $packOutput