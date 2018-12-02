param(
  [string]$localpass,
  [string]$dcpass
)

Write-Output "local password is: $localpass, dc password is: $dcpass"

$dir_name = "test-dir"

New-Item -ItemType Directory -Force -Path "C:\$dir_name"
Set-Content -Path "C:\$dir_name\ps-test.txt" -Value "local password is: $localpass, dc password is: $dcpass" -Force

Write-Output "The test directory has been created on C Drive: $dir_name"

