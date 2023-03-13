$Server = "";              
$Database = "";
$Dest = "";     
$bufferSize = 8192;
$Sql = "SELECT [Document_Name],[DocumentBin] FROM [FileStreamDemoDB_test].[dbo].[Tbl_Support_Documents]";
$con = New-Object Data.SqlClient.SqlConnection; 
$con.ConnectionString = "Data Source=$Server;" + 
 "Integrated Security=True;" + 
 "Initial Catalog=$Database"; 
  $con.Open();

Write-Output ((Get-Date -format yyyy-MM-dd-HH:mm:ss) + ": Export FILESTREAM objects Started ...");
$cmd = New-Object Data.SqlClient.SqlCommand $Sql, $con; 
$rd = $cmd.ExecuteReader();
$out = [array]::CreateInstance('Byte', $bufferSize) 
  
  While ($rd.Read()) 
{ 
 try 
  { 
   Write-Output ("Exporting Objects from FILESTREAM container: {0}" -f $rd.GetString(0)); 
   # New BinaryWriter 
   $fs = New-Object System.IO.FileStream ($Dest + $rd.GetString(0)), Create, Write; 
   $bw = New-Object System.IO.BinaryWriter $fs; 
 
   $start = 0; 
   # Read first byte stream 
   $received = $rd.GetBytes(1, $start, $out, 0, $bufferSize - 1); 
   While ($received -gt 0) 
   { 
    $bw.Write($out, 0,      $received); 
    $bw.Flush(); 
    $start += $received; 
    # Read next byte stream 
    $received = $rd.GetBytes(1, $start, $out, 0, $bufferSize - 1); 
   } 
   $bw.Close(); 
   $fs.Close(); 
  } 
  catch 
  { 
   Write-Output ($_.Exception.Message) 
  } 
  finally 
  { 
   $fs.Dispose();         
  }
 }
$rd.Close(); 
$cmd.Dispose(); 
$con.Close();