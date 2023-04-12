function Get-CpuReport {
    $cpu = (Get-CimInstance -ClassName Win32_Processor).Name
    "CPU: $cpu"
}

function Get-OsReport {
    $os = (Get-CimInstance -ClassName Win32_OperatingSystem).Caption
    $release = (Get-CimInstance -ClassName Win32_OperatingSystem).Version
    "OS: $os $release"
}

function Get-RamReport {
    $ram = (Get-CimInstance -ClassName Win32_OperatingSystem).TotalVisibleMemorySize
    $ram = $ram * 1MB
    $available = (Get-CimInstance -ClassName Win32_OperatingSystem).FreePhysicalMemory
    $available = $available * 1MB
    "RAM: Total: $ram, Available: $available"
}

function Get-VideoReport {
    $video = "N/A" # Replace with code to fetch video information
    "Video: $video"
}

function Get-DiskReport {
    $disks = Get-CimInstance -ClassName Win32_LogicalDisk | Where-Object {$_.DriveType -eq 3}
    $diskReport = "Disks:"
    foreach ($disk in $disks) {
        $diskName = $disk.DeviceID
        $diskType = $disk.FileSystem
        $diskTotalSize = $disk.Size
        $diskFreeSpace = $disk.FreeSpace
        $diskReport += "`nName: $diskName, Type: $diskType, Total Size: $diskTotalSize, Free Space: $diskFreeSpace"
    }
    $diskReport
}

function Get-NetworkReport {
    $network = "N/A" # Replace with code to fetch network information
    "Network: $network"
}

function Generate-SystemReport {
    param (
        [Parameter(Mandatory = $false)]
        [string[]]
        $Sections = @()
    )

    $report = @()

    if (!$Sections) {
        $report += Get-CpuReport
        $report += Get-OsReport
        $report += Get-RamReport
        $report += Get-VideoReport
        $report += Get-DiskReport
        $report += Get-NetworkReport
    }
    else {
        foreach ($section in $Sections) {
            switch ($section) {
                "-System" {
                    $report += Get-CpuReport
                    $report += Get-OsReport
                    $report += Get-RamReport
                    $report += Get-VideoReport
                }
                "-Disks" {
                    $report += Get-DiskReport
                }
                "-Network" {
                    $report += Get-NetworkReport
                }
                default {
                    Write-Output "Invalid argument: $section"
                }
            }
        }
    }

    $report
}

# Parse command line arguments
$sections = @($args)
$report = Generate-SystemReport -Sections $sections
Write-Output $report