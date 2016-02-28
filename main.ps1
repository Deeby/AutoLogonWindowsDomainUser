<#
$date = Get-Date -format dd.MM.yyy-HH.mm

If(-not(Test-Path -Path logs))
 {
     Write-Output "Creating logs folder"
	 New-Item -Path logs -Type Directory -Force | Out-Null
  }
Start-Transcript -Path log\log$date.txt  | Out-Null

Write-Output "`nWelcome to SetAutLoginWindowsUserDomain tool.`n
http://github.com/audricd/SALWUD `n" 
#>

function Test-RegistryValue {

param (

 [parameter(Mandatory=$true)]
 [ValidateNotNullOrEmpty()]$Path,

[parameter(Mandatory=$true)]
 [ValidateNotNullOrEmpty()]$Value
)

try {

Get-ItemProperty -Path $Path | Select-Object -ExpandProperty $Value -ErrorAction Stop | Out-Null
 return $true
 }

catch {

return $false

}

}
#reg
$reg = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon'
#values
$aal = 'AutoAdminLogon'
$ddn = 'DefaultDomainName'
$dp = 'DefaultPassword'
$dun = 'DefaultUsername'

#tp regs
#tp AutoAdminLogon
$tpaal = Test-RegistryValue -Path $reg -Value $aal
#tp DefaultDomainName
$tpddn = Test-RegistryValue -Path $reg -Value $ddn
#tp DefaultPassword
$tpdp = Test-RegistryValue -Path $reg -Value $dp
#tp DefaultUserName
$tpdun = Test-RegistryValue -Path $reg -Value $dun

#gp regs
#gp aal
(Get-Itemproperty $reg).$aal
#gp ddn
(Get-Itemproperty $reg).$ddn
#gp dp
(Get-Itemproperty $reg).$dp
#gp dun
(Get-Itemproperty $reg).$dun


 

<#
Stop-Transcript 
#>