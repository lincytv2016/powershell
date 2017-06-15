# Returns the version of the OS greater that n Windows 2008 R2

$vers=[Environment]::OSVersion.Version -ge (new-object 'Version' 6,1)
if($vers -contains "True") {
	Write-Output " Version Greater then Windows 2008 R2"
}
else
{
	Write-Output " Appling the patches"
    #Write Code for Updateing the windows server
    #Get-HotFix.ps1
}