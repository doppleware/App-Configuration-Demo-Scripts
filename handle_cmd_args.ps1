param(
  [string]$localpass,
  [string]$dcpass
)

# turning off local firewall, if you want to leave on you need to open up winrm ports 5985
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False

# Set network to private (necessary for winrm to work)
Get-NetConnectionProfile | Set-NetConnectionProfile -NetworkCategory Private

# allow winrm config
Enable-PSRemoting -SkipNetworkProfileCheck -Force
winrm set winrm/config/client/auth '@{Basic="true"}'
winrm set winrm/config/service/auth '@{Basic="true"}'
winrm set winrm/config/service '@{AllowUnencrypted="true"}'

# set execution policy to allow scripts to run
Set-ExecutionPolicy -ExecutionPolicy Unrestricted

Write-Output "local password is: $localpass, dc password is: $dcpass"

$dir_name = "test-dir"

New-Item -ItemType Directory -Force -Path "C:\$dir_name"
Set-Content -Path "C:\$dir_name\ps-test.txt" -Value "local password is: $localpass, dc password is: $dcpass" -Force

Write-Output "The test directory has been created on C Drive: $dir_name"

