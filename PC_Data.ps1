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

# Function call to present the results of the function calls 
Get-Info -PC_Info $PC_INFO

#pausing the console to allow the user to see the info 
Pause
