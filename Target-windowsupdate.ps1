$continue = $true

#Checks for presence of PSWindowsUpdate module and installs if missing
$status = $null
$status = Get-InstalledModule -Name PSWindowsUpdate
if ($status -eq $null) {
    Set-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU -Name "UseWUServer" -Value 0
    Get-Service -Name wuauserv | Restart-Service
    install-Module PSWindowsUpdate
    import-Module PSWindowsUpdate
    }

#Displays available Windows updates
Set-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU -Name "UseWUServer" -Value 0
Get-Service -Name wuauserv | Restart-Service
Write-host ""
Write-host "Available Windows updates:" -ForegroundColor Yellow
Write-host ""
Get-windowsupdate
Write-host ""


#Prompts user for specific KBArticle to install, or to install all available
while ($continue -eq $true) {
    $KB = Read-host "To install, enter name of KBArticleID (KB########), or type 'all' to install all availible"
    switch -Regex ($KB) {
        'KB\d\d\d\d\d\d\d' {
            Set-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU -Name "UseWUServer" -Value 0
            Get-Service -Name wuauserv | Restart-Service
            #write-host "Testing : case 1"
            get-windowsupdate -KBArticleID "$KB" -Install
            $continue = $false
            }
        all {Set-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU -Name "UseWUServer" -Value 0
            Get-Service -Name wuauserv | Restart-Service
            #Write-host "Testing: case 2"
            get-windowsupdate -Install
            $continue = $false
            }    
        Default {
            Write-host ""
            Write-host "Please enter valid format (KB#######) or type 'all'" -foregroundcolor DarkYellow
            Write-host ""
            }
        }
    }