$myUser = $env:UserName

Set-Content -Path "C:\Users\$myUser\Desktop\powershell-test.txt" -Value "My test Value!!!" -Force