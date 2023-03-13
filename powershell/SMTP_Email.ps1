#
#.PURPOSE
#Sends SMTP email via the Hub Transport server
#
#.SYNTAX
#.\Send-Email.ps1 -To "example@xerox.com" -Subject "Test email" -Body "This is a test"
#

param(
[string]$to,
[string]$cc,
[string]$subject,
[string]$body,
[string]$hostname
)

$hostname = $env:computername
$smtpServer = ""
$smtpFrom = "noreply@xerox.com"
$smtpTo = $to
$smtpCc = $cc
$messageSubject = $subject
$messageBody = $body + " on server " + $hostname + "!! Please restart or reboot the server as soon as possible!"

$smtp = New-Object Net.Mail.SmtpClient($smtpServer)
$smtp.Send($smtpFrom,$smtpTo,$messagesubject,$messagebody)