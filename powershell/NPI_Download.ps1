# Declare some variables
$error.clear()
$sourcepath = "http://download.cms.gov/nppes/"
$destpath = "D:\FeeScheduleDataLoad\IQSystem\NPI\"
$file1 = "NPPES_Data_Dissemination_" + (Get-Date -format MMMMMMMMMMMM) + "_" + (Get-Date -format yyyy) + ".zip"
$file2 = "NPPES_Data_Dissemination_" + (Get-Date -format MMMM) + "_" + (Get-Date -format yyyy) + ".zip"
$file3 = "NPPES_Data_Dissemination_" + (Get-Date -format MMM) + "_" + (Get-Date -format yyyy) + ".zip"
$source1 = $sourcepath + $file1
$source2 = $sourcepath + $file2
$source3 = $sourcepath + $file3
$destination1 = $destpath + $file1
$destination2 = $destpath + $file2
$destination3 = $destpath + $file3
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
Try
{
$wc.DownloadFile($source2, $destination2)
}
Catch
{
	"The remote server returned an error:"
}
Try
{
$wc.DownloadFile($source3, $destination3)
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