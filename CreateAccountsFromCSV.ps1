#This script automates the creation of Active Directory user accounts from a comma separated value (CSV) file
 #Based on script from Kevin Brown
 #Feel free to use, modify and share this script.

#Use these two lines if you want to force the script to follow Powershell best practices
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

#Add Active Module for Powershell if this hasn't been done already
#Import-Module ActiveDirectory

 $password = (Read-Host "Enter the password you want the new accounts to use temporarily" -AsSecureString)
 $accounts_created = 0
 $group1 = "Staff Group"
 $group2 = "Sales Group"

Import-CSV "C:\new user accounts.csv" | ForEach-Object {
 $user = $_."samAccountName" + "@LabDomain.com"

 New-ADUser -Name $_.name `
  -SamAccountName  $_."samaccountname" `
  -UserPrincipalName  $user `
  -AccountPassword $password `
  -ChangePasswordAtLogon $true  `
  -Enabled $true `
  -givenName $_."givenname"
  -surName $_."surname"
  -displayname $_."displayname"
  -department $_."department"
  -title $_."job title"
  -OfficePhone $_."phone"
  -EmailAddress $_."email"

 #Optionally add user to distribution groups and/or security groups
 Add-ADGroupMember "group1" $_."samAccountName";
 Add-ADGroupMember "group2" $_."samAccountName";

 $accounts_created++
}

Write-host "If you haven't received any error messages, then you have successfully created " $accounts_created "accounts."
