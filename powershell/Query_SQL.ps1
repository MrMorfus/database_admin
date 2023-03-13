# Pass in the BillID to look up
param (
    [string]$billID
    )

# Declare some variables to hold stuff
$dataSource = ""
$user = ""
$pwd = ""
$database = ""
$outputFile = "C:\TMP\Bill_Lines.txt"
# Build a connection string
$connectionString = 'Data Source=' + $dataSource + ';uid=' + $user + ';pwd=' + $pwd + ';Initial Catalog=' + $database + ';Integrated Security=False;'

# Create a sql connection and open a session
$connection = New-Object System.Data.SqlClient.SqlConnection
$connection.ConnectionString = $connectionString
$connection.Open()

# Your big gross query to pull data
$query = "select billedCodes.BilledCodeID,LineNumber,billedCodes.DateOfService,billedCodes.Code,Modifier,billedCodes.Quantity,IsDuplicate,IsOverride,OverrideAllowance,isnull(TOS,'') as TOS,isnull(billedCodes.POS,'') as POS,isnull(billedCodes.SpecialtyCode,'') as SpecialtyCode, isnull(BilledCode,'') as BilledCode,isnull(BilledModifier,'') as BilledModifier,isnull(billedCodes.BilledUnits,0) as BilledUnits,isnull(RxID,'') as RxID,isnull(IsRxRefill,'') as IsRxRefill,isnull(billedCodes.RxCertification,'') as RxCertification,isnull(PrescriberLicenseNumber,'') as PrescriberLicenseNumber,isnull(DMEFrequencyCode,'') as DMEFrequencyCode,isnull(billedCodes.DispensingFee,0) as DispensingFee,isnull(billedCodes.DispensedAsWritten,'') as DispensedAsWritten,isnull(billedCodes.QuantityType,'') as QuantityType,isnull(BilledAmount,0) as BilledAmount,isnull(BillReviewReduction,0) as BillReviewReduction,isnull(ContractReduction,0) as ContractReduction,isnull(RecAllowance,0) as RecAllowance,billedCodes.Description,billedCodes.Notes,IsForDiagnosis1,IsForDiagnosis2,IsForDiagnosis3,IsForDiagnosis4,'' as Messages,Bills.IsReviewed,isnull(Bills.IsInvoiced,0) as IsInvoiced,Bills.IsSuspended,Bills.IsLocked,isnull(DaysSupply,'') as DaysSupply,isnull(AnesthesiaMinutes,0) as AnesthesiaMinutes,isnull(SSPCode,'') as SSPCode,isnull(StRptLineData.RenderingLineNPI,'') as renderingLineNPI FROM billedCodes (nolock) join bills (nolock) on bills.billID = billedCodes.billID	left join StRptLineData (nolock) on StRptLineData.BilledCodeID = billedCodes.BilledCodeID WHERE billedCodes.billID = " + $billID

# Start a timer to get total execution time
$startQuery = (Get-Date)

# Really execute the query now
$command = $connection.CreateCommand()
$command.CommandText = $query
$result = $command.ExecuteReader()

# Create a fancy table to make it easier to read and load the results
$table = new-object “System.Data.DataTable”
$table.Load($result)

# Grab the end time for query results
$endQuery = (Get-Date)

# Take the gross query and format it!
$format = @{Expression={$_.BilledCodeID};Label="BilledCodeID";width=20},@{Expression={$_.LineNumber};Label="LineNumber";width=3},@{Expression={$_.DateOfService};Label="DOS";width=30},@{Expression={$_.Code};Label="Code";width=6},@{Expression={$_.Modifier};Label="Modifier";width=3},@{Expression={$_.Quantity};Label="Quantity";width=6},@{Expression={$_.IsDuplicate};Label="IsDuplicate";width=2},@{Expression={$_.IsOverride};Label="IsOverride";width=2},@{Expression={$_.OverrideAllowance};Label="OverrideAllowance";width=6},@{Expression={$_.TOS};Label="TOS";width=2},@{Expression={$_.POS};Label="POS";width=2},@{Expression={$_.SpecialtyCode};Label="SpecialtyCode";width=30},@{Expression={$_.BilledCode};Label="BilledCode";width=6},@{Expression={$_.BilledModifier};Label="BilledModifier";width=2},@{Expression={$_.BilledUnits};Label="BilledUnits";width=6},@{Expression={$_.RxID};Label="RxID";width=20},@{Expression={$_.IsRxRefill};Label="IsRxRefill";width=2},@{Expression={$_.RxCertification};Label="RxCert";width=2},@{Expression={$_.PrescriberLicenseNumber};Label="LicNum";width=30},@{Expression={$_.DMEFrequencyCode};Label="DMECode";width=20},@{Expression={$_.DispensingFee};Label="DispFee";width=6},@{Expression={$_.DispensedAsWritten};Label="DispWritten";width=5},@{Expression={$_.QuantityType};Label="QuantType";width=20},@{Expression={$_.BilledAmount};Label="BilledAmount";width=10},@{Expression={$_.BillReviewReduction};Label="Reduced";width=10},@{Expression={$_.ContractReduction};Label="CReduction";width=10},@{Expression={$_.RecAllowance};Label="RecAllowance";width=10},@{Expression={$_.Description};Label="Desc";width=100},@{Expression={$_.Notes};Label="Notes";width=300},@{Expression={$_.IsForDiagnosis1};Label="IsForDiagnosis1";width=2},@{Expression={$_.IsForDiagnosis2};Label="IsForDiagnosis2";width=2},@{Expression={$_.IsForDiagnosis3};Label="IsForDiagnosis3";width=2},@{Expression={$_.IsForDiagnosis4};Label="IsForDiagnosis4";width=2},@{Expression={$_.Messages};Label="Messages";width=300},@{Expression={$_.IsReviewed};Label="IsReviewed";width=2},@{Expression={$_.IsInvoiced};Label="IsInvoiced";width=2},@{Expression={$_.IsSuspended};Label="IsSuspended";width=2},@{Expression={$_.IsLocked};Label="IsLocked";width=2},@{Expression={$_.DaysSupply};Label="DaysSupply";width=3},@{Expression={$_.AnesthesiaMinutes};Label="AnesthesiaMins";width=5},@{Expression={$_.SSPCode};Label="SSPCode";width=5},@{Expression={$_.RenderingLineNPI};Label="NPI";width=12}
$table | format-table $format | Out-File $outputFile

# Close the connection and report the query execution time
$connection.Close()
"Elapsed Query Time: $(($endQuery-$startQuery).totalseconds) seconds"