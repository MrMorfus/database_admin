# Sometimes you need to import the script as a module. Try this: import-module .\start-monitor.psm1

function Start-Monitor {
      
      #Requires -Version 2.0            
      [CmdletBinding()]            
      Param             
      (                       
            [Parameter(Position=0,                         
                       ValueFromPipeline=$true,            
                       ValueFromPipelineByPropertyName=$true)]
            [String[]]$ComputerName = $env:COMPUTERNAME,        
            
            # Switch to Enable Email Notifications on First Down
            [Switch]$notifyonServerDown,
            
            # Switch to Enable Email Notifications on Server Online
            [Switch]$notifyonServerBackOnline,
            
            # Switch to Enable Email Notifications on MaxOutageCount
            [Switch]$notifyonMaxOutageCount,
            
            # Switch to Enable all notifications
            [Switch]$notifyAll,

            # specify the time you want email notifications resent for hosts that are down
            $EmailTimeOut = 30,
            # specify the time you want to cycle through your host lists.
            $SleepTimeOut = 5,
            # specify the maximum hosts that can be down before the script is aborted
            $MaxOutageCount = 100,
            
            # specify who gets notified 
            $tonotification = "mark.winchell@conduent.com", 
            # specify where the notifications come from 
            $fromnotification = "noreply@conduent.com", 
            # specify the SMTP server 
            $smtpserver = "ironports.compworks",
            
            # reset the lists of hosts prior to looping
            $OutageHosts = @()            
      )#End Param
 
 # Use end block, to ensure all computers are read in at once, even by pipeline     
 end {     
      if ($notifyAll)
      {
            $notifyonMaxOutageCount,$notifyonServerBackOnline,$notifyonServerDown =  $True,$True,$True
      }

      Write-Verbose -Message "computername: $computername"
      Write-Verbose -Message "notifyonMaxOutageCount: $notifyonMaxOutageCount"
      Write-Verbose -Message "notifyonServerBackOnline: $notifyonServerBackOnline"
      Write-Verbose -Message "notifyonServerDown: $notifyonServerDown"

      # Allow
      if ( $Input )
      {
            Write-Verbose -Message "Input: $Input"
            $ComputerName = $Input
      }
      
      # start looping here
      Do{
            $available = @()
            $notavailable = @()
            Write-Host (Get-Date)
            
            # Read the File with the Hosts every cycle, this way to can add/remove hosts
            # from the list without touching the script/scheduled task, 
            # also hash/comment (#) out any hosts that are going for maintenance or are down.f
            # $ComputerName | Where-Object {!($_ -match "#")} | 
            get-content -path D:\TMP\PSfolder\PROD.txt | Where-Object {!($_ -match "#")} |
            # "test1","test2" | Where-Object {!($_ -match "#")} |
            ForEach-Object {
                  if(Test-Connection -ComputerName $_ -Count 1 -ea silentlycontinue)
                  {
                        # if the Host is available then write it to the screen
                        write-host "Available host ---> "$_ -BackgroundColor Green -ForegroundColor White
                        [String[]]$available += $_
                        
                        # if the Host was out and is now backonline, remove it from the OutageHosts list
                        if ($OutageHosts -ne $Null)
                        {
                              if ($OutageHosts.ContainsKey($_))
                              {
                                    $OutageHosts.Remove($_)
                                    $Now = Get-date
                                    if ($notifyonServerBackOnline)
                                    {
                                          $Body = "$_ is back online at $Now"
                                          Send-MailMessage -Body "$body" -to $tonotification -from $fromnotification `
                                          -Subject "Host $_ is up" -SmtpServer $smtpserver
                                    }
                                    
                              }
                        }  
                  }
                  else
                  {
                        # If the host is unavailable, give a warning to screen
                        write-host "Unavailable host ------------> "$_ -BackgroundColor Magenta -ForegroundColor White
                        if(!(Test-Connection -ComputerName $_ -Count 2 -ea silentlycontinue))
                        {
                              # If the host is still unavailable for 4 full pings, write error and send email
                              write-host "Unavailable host ------------> "$_ -BackgroundColor Magenta -ForegroundColor White
                              [Array]$notavailable += $_
                              
                              if ($OutageHosts -ne $Null)
                              {
                                    if (!$OutageHosts.ContainsKey($_))
                                    {
                                          # First time down add to the list and send email
                                          Write-Host "$_ Is not in the OutageHosts list, first time down"
                                          $OutageHosts.Add($_,(get-date))
                                          $Now = Get-date
                                          if ($notifyonServerDown)
                                          {
                                                $Body = "$_ has not responded for 5 pings at $Now"
                                                Send-MailMessage -Body "$body" -to $tonotification -from $fromnotification `
                                                -Subject "Host $_ is down" -SmtpServer $smtpserver
                                          }
                                    }
                                    else
                                    {
                                          # If the host is in the list do nothing for 1 hour and then remove from the list.
                                          Write-Host "$_ Is in the OutageHosts list"
                                          if (((Get-Date) - $OutageHosts.Item($_)).TotalMinutes -gt $EmailTimeOut)
                                          {$OutageHosts.Remove($_)}
                                    }
                              }
                              else
                              {
                                    # First time down create the list and send email
                                    Write-Host "Adding $_ to OutageHosts."
                                    $OutageHosts = @{$_=(get-date)}
                                    $Now = Get-date
                                    if ($notifyonServerDown)
                                    {
                                          $Body = "$_ has not responded for 5 pings at $Now"
                                          Send-MailMessage -Body "$body" -to $tonotification -from $fromnotification `
                                          -Subject "Host $_ is down" -SmtpServer $smtpserver
                                    }
                              } 
                        }
                  }
            }
            # Report to screen the details
            Write-Host "Available count:"$available.count
            Write-Host "Not available count:"$notavailable.count
            if ($OutageHosts)
            {
                  Write-Host "Not available hosts:"
                  $OutageHosts
            }
            Write-Host ""
            Write-Host "Sleeping $SleepTimeOut seconds"
            Start-Sleep -Seconds $SleepTimeOut
            if ($OutageHosts.Count -gt $MaxOutageCount)
            {
                  # If there are more than a certain number of host down in an hour abort the script.
                  $Exit = $True
                  $body = $OutageHosts | Out-String
                  
                  if ($notifyonMaxOutageCount)
                  {
                        Send-MailMessage -Body "$body" -to $tonotification -from $fromnotification `
                        -Subject "More than $MaxOutageCount Hosts down, monitoring aborted" -SmtpServer $smtpServer
                  }
            }
      }
      while ($Exit -ne $True)
}#End     
}#Start-Monitor