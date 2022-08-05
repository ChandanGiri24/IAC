<powershell>
$file = $env:SystemRoot + "\Temp\" + (Get-Date).ToString("MM-dd-yy-hh-mm")
New-Item $file -ItemType file

aws s3 cp s3://my_bucket/my_folder/employee.zip C:/

Expand-Archive c:\employee.zip -DestinationPath c:\wwweroot

Import-Module WebAdministration
$siteName = "website"
$path = "C:\wweroot"
$Port = 80
appPoolName = "defaultpool"
$pool = New-WebAppPool $appPoolName
    $pool.managedRuntimeVersion = "v4.0"
    $pool.processModel.identityType = 2

     $pool | Set-Item

    if ((Get-WebAppPoolState -Name $appPoolName).Value -ne "Started") {
        throw "App pool $appPoolName was created but did not start automatically. Probably something is broken!"
    }

$website = New-Website -Name $siteName -PhysicalPath $path -ApplicationPool $appPoolName -Port $port

 if ((Get-WebsiteState -Name $siteName).Value -ne "Started") {
        throw "Website $siteName was created but did not start automatically. Probably something is broken!"
    }

     "Website and AppPool created and started sucessfully"

</powershell>
<persist>true</persist>
