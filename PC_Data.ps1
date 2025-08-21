# Double-Space: This function adds 2 new line characters
function Add-Space{
    "`n `n"
}

# Get-Info: This function compiles all the PC info and displays the results 
function Get-Info{
    param ([string[]]$PC_Info)
    $Result =""
    foreach ($info in $PC_Info){
        $Result += $info + $(Add-Space)
    }
    return $Result

}

# Calculating Express service Code 
function Get-ExpressServiceCode {
    param (
        [Parameter(Mandatory = $true)]
        [string]$ServiceTag
    )

    # Dell service tags are base-36 (0–9, A–Z)
    $chars = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    $esc = 0

    foreach ($c in $ServiceTag.ToUpper().ToCharArray()) {
        $esc = ($esc * 36) + $chars.IndexOf($c)
    }

    return $esc
}
# write a blank line
write-host

#List containing all the PC Info
$PC_INFO = New-Object System.Collections.ArrayList

# PC/Device Name 
$PC_INFO.Add("PC Name: " + (Get-WmiObject -Class Win32_ComputerSystem).Name)| Out-Null

#Serial Number 
$PC_INFO.Add("Serial Number: " +  (Get-WmiObject -Class Win32_Bios).SerialNumber)| Out-Null
 
#IpAddress
$PC_INFO.Add("IPAddress: "+(Get-NetIPConfiguration).IPv4Address[0].IPAddress)| Out-Null
 
#Model 
$PC_INFO.Add("Model: "+ (Get-WmiObject -Class Win32_ComputerSystem).Model) | Out-Null

#OS
$PC_INFO.Add("OS: " + (Get-CimInstance Win32_OperatingSystem).Caption) | Out-Null
 
#Processor
$PC_INFO.Add("Processor: " + (Get-CimInstance -ClassName Win32_Processor).Name ) | Out-Null

#Ram
$PC_INFO.Add("Ram: " + ((Get-WmiObject -Class Win32_ComputerSystem).TotalPhysicalMemory / 1GB).ToString("N2") + "GB") | Out-Null

#Hardrive(s)
foreach ($drive in Get-CimInstance Win32_DiskDrive) {
    $sizeGB = [math]::Round($drive.Size / 1GB, 2)
    $PC_INFO.Add("Drive: $($drive.Model) : $sizeGB GB") | Out-Null
}

#Exp Service Code 
$ServiceTag = (Get-CimInstance -ClassName Win32_BIOS).SerialNumber
$PC_INFO.Add("Exp Service Code: $(Get-ExpressServiceCode -ServiceTag $ServiceTag)") | Out-Null

# Function call to present the results of the function calls 
Get-Info -PC_Info $PC_INFO

#pausing the console to allow the user to see the info 
Pause
