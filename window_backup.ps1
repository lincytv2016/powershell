#Reading the Windows Features for Windows Backup Installation 

#network backup path
$backup_path = '\\192.168.1.48\New Folder'

#backup time 
$back_time = '12:30AM'

function create_backup()
{
$pol = New-WBPolicy
$pol | Add-WBSystemState 
#$pol = Get-WBPolicy -Editable
New-WBBackupTarget -policy $pol -NetworkPath $backup_path
Set-WBSchedule -Policy $pol -Schedule $back_time
Start-WBBackup -Policy $pol
}


$a=Get-WindowsFeature *backup* | where {$_.InstallState -eq "Installed"}

if($a.Installed -eq "True")
{
Write-Output "Windows BAckup Server installed"
}
else
{

# Adding Windows Backup Feature
Add-WindowsFeature Windows-Server-Backup
}