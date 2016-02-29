Write-Output "`nWelcome to SetAutLoginWindowsUserDomain tool. This script manages key values in HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon to enable/manage autologon for domain users. use under your own responsability`n
http://github.com/audricd/SALWUD `n" 


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
$checkreg = Test-Path $reg
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
$gpaal = (Get-Itemproperty $reg).$aal
#gp ddn
$gpddn = (Get-Itemproperty $reg).$ddn
#gp dp
$gpdp = (Get-Itemproperty $reg).$dp
#gp dun
$gpdun = (Get-Itemproperty $reg).$dun

#1st step, check if reg exists
$checkregresult = if ($checkreg -eq $true){Write-Output "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon exists."} Else {Write-Output "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon either does not exist or I cannot access it. Stopping process. Try running this with admin rights."; break}
$checkregresult

#function, check if AAL is enabled
$checkaal = if ($gpaal -eq 1){Write-Output "AutoAdminLogon is enabled on $gpdun for the domain $gpddn"} Else {Write-Output "AutoAdminLogon is disabled"}

#function enable AAL
$enableaal = Set-ItemProperty -Path $reg -Name AutoAdminLogon -Value 1



#function disable AAL
$disableaal = Set-ItemProperty -Path $reg -Name AutoAdminLogon -Value 0

do {
  [int]$userMenuChoice = 0
  while ( $userMenuChoice -lt 1 -or $userMenuChoice -gt 6) {
	Write-Host "1. Enable AutoAdminLogon"
	Write-Host "2. Set user"
	Write-Host "3. Set password"
	Write-Host "4. domain"
	Write-Host "5. Disable AutoAdminLogon"
	Write-Host "6. Exit"

    [int]$userMenuChoice = Read-Host "`nPlease choose an option"

    switch ($userMenuChoice) {
	  1{Set-ItemProperty -Path $reg -Name AutoAdminLogon -Value 1}
	  2{$dun = Read-Host "Input username"; Set-ItemProperty -Path $reg -Name DefaultUserName -Value $dun}
	  3{$dp = Read-Host "Input password"; Set-ItemProperty -Path $reg -Name DefaultPassword -Value $dp}
	  4{$ddn = Read-Host "Input domain"; Set-ItemProperty -Path $reg -Name DefaultDomainName -Value $ddn}
	  5{Set-ItemProperty -Path $reg -Name AutoAdminLogon -Value 0}

	}
}
	}

 while	 ( $userMenuChoice -ne 6 )
