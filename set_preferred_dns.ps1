# netshell version
netsh interface ipv4 set dnsservers name="{ethernet_alias}"  source=static address="{dns_server_ip}" validate=no

# ps version
Set-DnsClientServerAddress -InterfaceAlias "Ethernet 4" -ServerAddresses ("192.168.90.5", "168.63.129.16") 