# Backuping  Windows Active Directory Users Groups and Group Policy using 
# powershell script  to s3 bucket

# variables 
$s3_bucket = 's3://lincy-ad-backup/'

# Backup Path
$path = Split-Path -parent "c:\temp\*.*"

# Creating a temp  path 
New-Item $path -ItemType Directory

#Create a variable for the date stamp in the log file
$LogDate = get-date -f yyyyMMddhhmm
#Log file Name Creating 
$csvfile = $path + "\ALLADUsers_$logDate.csv"


#import the ActiveDirectory Module
Import-Module ActiveDirectory

# seting the domain variable
$domainname = Get-ADDomainController

#Get Admin accountb credential
$GetAdminact = Get-Credential

#seting the search doman
$SearchBase = $domainname.DefaultPartition 

#Define variable for a server with AD web services installed
$ADServer = $domainname.Domain   #'lizeon'

# geting all users 

$AllADUsers = Get-ADUser -server $ADServer `
-Credential $GetAdminact -searchbase $SearchBase `
-Filter * -Properties * | Where-Object {$_.info -NE 'Migrated'} #ensures that updated users are never exported.

$AllADUsers |
Select-Object @{Label = "First Name";Expression = {$_.GivenName}},
@{Label = "Last Name";Expression = {$_.Surname}},
@{Label = "Display Name";Expression = {$_.DisplayName}},
@{Label = "Logon Name";Expression = {$_.sAMAccountName}},
@{Label = "Full address";Expression = {$_.StreetAddress}},
@{Label = "City";Expression = {$_.City}},
@{Label = "State";Expression = {$_.st}},
@{Label = "Post Code";Expression = {$_.PostalCode}},
@{Label = "Country/Region";Expression = {if (($_.Country -eq 'GB')  ) {'United Kingdom'} Else {''}}},
@{Label = "Job Title";Expression = {$_.Title}},
@{Label = "Company";Expression = {$_.Company}},
@{Label = "Directorate";Expression = {$_.Description}},
@{Label = "Department";Expression = {$_.Department}},
@{Label = "Office";Expression = {$_.OfficeName}},
@{Label = "Phone";Expression = {$_.telephoneNumber}},
@{Label = "Email";Expression = {$_.Mail}},
@{Label = "Manager";Expression = {%{(Get-AdUser $_.Manager -server $ADServer -Properties DisplayName).DisplayName}}},
@{Label = "Account Status";Expression = {if (($_.Enabled -eq 'TRUE')  ) {'Enabled'} Else {'Disabled'}}}, # the 'if statement# replaces $_.Enabled
@{Label = "Last LogOn Date";Expression = {$_.lastlogondate}} | 

#Export CSV report

Export-Csv -Path $csvfile -NoTypeInformation

#################
#  GPO Export Policy 
###############

#installing awscli
Invoke-WebRequest 'https://s3.amazonaws.com/aws-cli/AWSCLI64.msi' -OutFile 'c:\temp\awscli.msi'
Start-Process msiexec.exe -Wait -ArgumentList '/I c:\temp\awscli.msi /quiet' -Verbose

#insatlling python 2.7 , pip and awscli
Invoke-WebRequest 'https://www.python.org/ftp/python/2.7.13/python-2.7.13.msi' -OutFile 'c:\temp\python-2.7.13.msi'
Start-Process msiexec.exe -Wait -ArgumentList '/I c:\temp\python-2.7.13.msi /quiet' -Verbose

# Backup the GPO files 
Backup-GPO -All -Path $path
aws s3 cp c:\temp\ $s3_bucket --recursive
