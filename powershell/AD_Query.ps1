$GFile = New-Item -type file -force "C:\Scripts\GroupDetails.csv" 
Import-CSV "C:\Scripts\GList.csv" | ForEach-Object { 
$GName = $_.GroupName 
$group = [ADSI] "LDAP://$GName" 
$group.cn 
$group.cn | Out-File $GFile -encoding ASCII -append 
    foreach ($member in $group.member) 
        { 
            $Uname = new-object directoryservices.directoryentry("LDAP://$member") 
            $Uname.cn 
            $Uname.cn | Out-File $GFile -encoding ASCII -append 
        } 
}