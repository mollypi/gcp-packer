#<-----------DEV ONLY !!! DO NOT USE FOR ANY LONG LIVE MACHNE-------->


$Username = 'packer'
$Password = 'ZPA@Dedham123'

$group = 'Administrators'

$adsi = [ADSI]"WinNT://$env:COMPUTERNAME"
$existing = $adsi.Children | Where-Object { $_.SchemaClassName -eq 'user' -and $_.Name -eq $Username }

if (!($existing)) {

    Write-Host "Creating new local user $Username."
    & NET USER $Username $Password /add /y /expires:never
    
    Write-Host "Adding local user $Username to $group."
    & NET LOCALGROUP $group $Username /add

} else {
    Write-Host "Setting password for existing local user $Username."
    $existing.SetPassword($Password)
}

Write-Host "Ensuring password for $Username never expires."
& WMIC USERACCOUNT WHERE "Name='$Username'" SET PasswordExpires=FALSE