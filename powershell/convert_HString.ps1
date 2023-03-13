function Global:Convert-HString { 
#Requires -Version 2.0  
            
[CmdletBinding()]             
 Param              
   ( 
    [Parameter(Mandatory=$false, 
               ValueFromPipeline=$true, 
               ValueFromPipelineByPropertyName=$true)] 
    [String]$HString 
   )#End Param 
 
Begin  
{ 
    Write-Verbose "Converting Here-String to Array" 
}#Begin 
Process  
{ 
    $HString -split "`n" | ForEach-Object { 
     
        $ComputerName = $_.trim() 
        if ($ComputerName -notmatch "#") 
            { 
                $ComputerName 
            }     
         
         
        } 
}#Process 
End  
{ 
    # Nothing to do here. 
}#End 
 
}#Convert-HString 