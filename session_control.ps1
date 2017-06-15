#Registery Pathe for terminal Server session key
$regkeypath='HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server'

# Setting the Powershell Script ExecutionPolicy to Remotely Signed
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -WarningAction Inquire

#reading the Session Path Value Info
$a = Get-ItemProperty -Path $regkeypath -Name fSingleSessionPerUser #| ft fSingleSessionPerUser
write-output $a
if ($a -gt 1 ) {
Set-ItemProperty -Path $regkeypath -Name "fSingleSessionPerUser" -Value 1
Write-Output "Setting New Value"
}
else
{
write-output $a
}

