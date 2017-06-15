$systempath='C:\windows\System32\WindowsPowerShell\v1.0\Modules'
Invoke-WebRequest -Uri https://gallery.technet.microsoft.com/scriptcenter/2d191bcd-3308-4edd-9de2-88dff796b0bc/file/41459/47/PSWindowsUpdate.zip -OutFile $systempath\PSWindowsUpdate.zip
Copy-Item 
Import-Module -Name PSWindowsUpdate
