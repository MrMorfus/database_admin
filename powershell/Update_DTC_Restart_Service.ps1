Set-ItemProperty -Path HKLM:\Software\Microsoft\MSDTC\Security -Name NetworkDtcAccess -Value 1
Set-ItemProperty -Path HKLM:\Software\Microsoft\MSDTC\Security -Name NetworkDtcAccessInbound -Value 1
Set-ItemProperty -Path HKLM:\Software\Microsoft\MSDTC\Security -Name NetworkDtcAccessOutbound -Value 1

start-sleep -s 5

$service = get-service "MSDTC" -ErrorAction SilentlyContinue
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
$service = get-service "MSDTC" -ErrorAction SilentlyContinue
if ( $service.status -eq "Stopped" )
{
.\PSfolder\SMTP_Email.ps1 -To "@xerox.com" -Cc "@xerox.com" -Subject "FAILED to restart MSDTC" -Body "The service failed to restart, please recheck this service "
}
else
{
"The specified service is not stopped"
}

Set-ExecutionPolicy restricted