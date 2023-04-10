# Get network adapter configuration objects
$adapters = Get-CimInstance Win32_NetworkAdapterConfiguration

# Filter for enabled adapters
$enabledAdapters = $adapters | Where-Object { $_.IPEnabled -eq $true }

# Create a custom object for each adapter with the desired properties
$adapterInfo = $enabledAdapters | ForEach-Object {
    [PSCustomObject]@{
        Description = $_.Description
        Index = $_.Index
        IPAddress = $_.IPAddress -join ', '
        SubnetMask = $_.IPSubnet -join ', '
        DNSDomain = $_.DNSDomain
        DNSServer = $_.DNSServerSearchOrder -join ', '
    }
}

# Format the output as a table
$adapterInfo | Format-Table -Property Description, Index, IPAddress, SubnetMask, DNSDomain, DNSServer -AutoSize
