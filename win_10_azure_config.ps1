# 1. turn off firewall and allow winrm
# 2. set preferred dns
# 3. add to skybox.demo.com domain

# initialize input params
param(
  [string]$localpass_input,
  [string]$dcpass_input
)

### Set Log file ###
$dir_name = "Azure_config_log"
$dir_path = "C:\$dir_name\azure_config.txt"

New-Item -ItemType Directory -Force -Path "C:\$dir_name"
Set-Content -Path $dir_path -Value "Beginning config script" -Force

# turning off local firewall, if you want to leave on you need to open up winrm ports 5985
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False

# Set network to private (necessary for winrm to work)
Get-NetConnectionProfile | Set-NetConnectionProfile -NetworkCategory Private

# check connection profile
$net_connection_profile = Get-NetConnectionProfile
$net_category = $net_connection_profile.NetworkCategory
Set-Content -Path $dir_path -Value "Current Network Profile $net_category" -Force

# allow winrm config
Enable-PSRemoting -SkipNetworkProfileCheck -Force
winrm set winrm/config/client/auth '@{Basic="true"}'
winrm set winrm/config/service/auth '@{Basic="true"}'
winrm set winrm/config/service '@{AllowUnencrypted="true"}'

# check winrm status
$winrm_status= Test-WSMan
$wsmid = $winrm_status.wsmid
Add-Content -Path $dir_path "WinRm wsmid: `n$wsmid"


# set execution policy to allow scripts to run
Set-ExecutionPolicy -ExecutionPolicy Unrestricted

$exec_policy = Get-ExecutionPolicy

Add-Content -Path $dir_path "Current Execution Policy: $exec_policy"

### set preferred DNS ###

$dc_ip = "192.168.90.5"
$alt_dns_ip = "168.63.129.16"
$interface_alias = "Ethernet 4"

Set-DnsClientServerAddress -InterfaceAlias $interface_alias -ServerAddresses ($dc_ip, $alt_dns_ip)

#### Add to demo.skybox.com domain ###
$domain_name = "demo.skybox.com"
$local_user = "quali_admin"
$dc_user = "administrator"

$local_password= ConvertTo-SecureString -String $localpass_input -AsPlainText -Force
$local_cred = new-object -typename System.Management.Automation.PSCredential -argumentlist $local_user, $local_password

$dc_pass = ConvertTo-SecureString -String $dcpass_input -AsPlainText -Force
$dc_cred = new-object -typename System.Management.Automation.PSCredential -argumentlist $user, $pass

Add-Computer -LocalCredential $localcred -DomainName $domain_name -Credential $dc_cred

# validate domain
$current_domain = (Get-WmiObject Win32_ComputerSystem).Domain
Add-Content -Path $dir_path "Current domain is: $current_domain"

Add-Content -Path $dir_path "Config script finished running"
