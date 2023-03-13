# $servers = Get-ADComputer -Filter {OperatingSystem -Like "Windows Server*"} -Property Name 
$servers = "WTW1PPLDVAP001"
$user = Get-Content c:\PS_folder\user_exceptions.txt
foreach ($server in $servers) {
      $disconnected = qwinsta | select-string "Disc" | select-string -notmatch "services" | select-string -notmatch $user
      if ($disconnected) {
            $disconnected| % { 
                  logoff ($_.tostring() -split ' +')[2] /server:$server
                  write-host "$user logged off $server"
                  }
      } else { write-host "Active Session on $server" }
}
start-sleep -s 10
Copy-Item "C:\Program Files\WindowsPowerShell\RDP\user_exceptions.txt" -Destination "C:\PS_folder\" -force
