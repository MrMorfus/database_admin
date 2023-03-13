# Declare some variables
$error.clear()
$sourcepath = "http://download.cms.gov/nppes/"
$destpath = "D:\FeeScheduleDataLoad\IQSystem\NPI\Weekly\"
#File is posted on Sunday each week
$file1 = "NPPES_Data_Dissemination_" + (Get-Date -date $(get-date).Adddays(-7) -format MMddyy) + "_" + (Get-Date -date $(get-date).Adddays(-1) -format MMddyy) + "_Weekly" + ".zip"
$source1 = $sourcepath + $file1
$destination1 = $destpath + $file1
$wc = New-Object System.Net.WebClient
$files = Get-ChildItem $destpath
$rar = "C:\Program Files\WinRAR\winrar.exe"
$rarpara = "e " + $files.FullName + " " + $destpath
#http://download.cms.gov/nppes/NPI_Files.html

#Go download a file from the INTARWEBz
Try
{
$wc.DownloadFile($source1, $destination1)
}
Catch
{
	"The remote server returned an error:"
}

#Now, unzip this massive thing!
foreach($item in $files)
{
Start-Process -FilePath $rar -ArgumentList $rarpara
}