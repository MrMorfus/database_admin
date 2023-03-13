# Set you variables here. UNC path must have double slashes
$text = "C:\\TMP\\AddendumB.txt"
$crap = "`t`"" # stupid thing you are parsing on
$char = "`t"   # add some more
$norm = "`t"   # thing you want to replace with
# --- STOP ---
$string = $crap + $char
(Get-Content $text) | 
Foreach-Object {$_ -replace $string, $norm} | 
Set-Content $text