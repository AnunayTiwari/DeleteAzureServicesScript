$subscription=$args[0]
$PatternString=$args[1]
$ServiceNamesToExclude=$args[2]
Get-AzureSubscription
Select-AzureSubscription -Current $subscription
$services = Get-AzureService | select ServiceName
$servicesToDelete = $services | Where { ($_.ServiceName.ToLower().Contains($PatternString))}
$servicesToDelete = $servicesToDelete | Where { !($_.ServiceName -in $ServiceNamesToExclude)} 

$servicesToDelete | ForEach-Object {
    Remove-AzureDeployment -ServiceName $_.ServiceName `
      -Slot Production -DeleteVHD -Force
    Remove-AzureService -ServiceName $_.ServiceName -Force
}

