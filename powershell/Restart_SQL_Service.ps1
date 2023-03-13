start-sleep -s 5

$service = get-service "MSSQLSERVER" -ErrorAction SilentlyContinue
if ( $service.status -eq "Running" )
{
"ReStarting Service..."
restart-service $service.name
"Service ReStarted"
}
else
{
"The specified service does not exist"
}
start-sleep -s 15
$service = get-service "MSSQLSERVER" -ErrorAction SilentlyContinue
if ( $service.status -eq "Stopped" )
{
.\PSfolder\SMTP_Email.ps1 -To "mark.winchell@xerox.com" -Cc "jason.spencer@xerox.com" -Subject "FAILED to restart MSDTC" -Body "The service failed to restart, please recheck this service "
}
else
{
"The specified service is not stopped"
}

start-sleep -s 5

$service = get-service "SQLSERVERAGENT" -ErrorAction SilentlyContinue
if ( $service.status -eq "Running" )
{
"ReStarting Service..."
restart-service $service.name
"Service ReStarted"
}
else
{
"The specified service does not exist"
}
start-sleep -s 15
$service = get-service "SQLSERVERAGENT" -ErrorAction SilentlyContinue
if ( $service.status -eq "Stopped" )
{
.\PSfolder\SMTP_Email.ps1 -To "mark.winchell@xerox.com" -Cc "jason.spencer@xerox.com" -Subject "FAILED to restart MSDTC" -Body "The service failed to restart, please recheck this service "
}
else
{
"The specified service is not stopped"
}