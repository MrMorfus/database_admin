# Server to watch and txt file of services to look for
$Computer = "WTW2PPLDVAP024" 
$ServiceList = "E:\PowerShell_Scripts\NAS_unstuck_job\service_list.txt"
 
# Create a list of all services on the server
$GetService = get-service -ComputerName $Computer | WHERE {$_.StartType -ne "Disabled"}
 
# Store a list of services you are looking for
$ServiceArray = Get-Content $ServiceList; 
 
# Find any iWFM service that is stopped/stop pending and try to do something about it
foreach ($Service in $GetService) 
{ 
    foreach ($srv in $ServiceArray) 
    { 
        if ($Service.name -eq $srv) 
        { 
            # Check if the service is hung
            if ($Service.status -eq "StopPending") 
            { 
            # Email to notify if the service is frozen: optional
            # Send-Mailmessage -to admin@domain.com -Subject "$srv is hung on $Computer" -from admin@domain.com -Body "The $srv service was found hung" -SmtpServer smtp.domain.com 
            $servicePID = (gwmi win32_Service | where { $_.Name -eq $srv}).ProcessID 
            Stop-Process $ServicePID 
            Start-Service -InputObject (get-Service -ComputerName $Computer -Name $srv) 
            } 
            # Check if the service is stopped 
            elseif ($Service.status -eq "Stopped") 
            { 
            # Email to notify if the service is stopped 
            # Send-Mailmessage -to admin@domain.com -Subject "$srv is stopped on $Computer" -from admin@domain.com -Body "The $srv service was found stopped" -SmtpServer smtp.domain.com 
            # Automatically restart the service. 
            Start-Service -InputObject (get-Service -ComputerName $Computer -Name $srv) 
            } 
        } 
    } 
}

# Note: Use this to get the service list: get-service | WHERE {$_.StartType -ne "Disabled" -and $_.Name -like "PPL*"} | format-list -Property Name | out-file C:\users\mwinchell\services.txt