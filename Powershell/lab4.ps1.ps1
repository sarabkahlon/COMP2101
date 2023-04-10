"############## System Hardware Description ###############"
gwmi win32_computersystem 

"########### Operating system name and version number ###########"
""
gwmi win32_operatingsystem |    
    select-object @{n='Opearting System Name'; e={$_.caption}}, Version

"########### Processor description with speed, number of core, and sizes of L1, L2 and L3 cache ##########"
""
gwmi win32_processor |    
    select-object @{n='Processor Type'; e={$_.caption}}, Name,     
        @{n="MaxClockSpeed in GHz"; e={$_.MaxClockSpeed/1000}}, NumberOfCores,       
        @{n="L1 Cache Size"; e={switch($_.L1CacheSize){$null{$stat="NA"} 0{$stat="0"}}; $stat}},      
        @{n="L2 Cache Size"; e={switch($_.L2CacheSize){$null{$stat="NA"} 0{$stat="0"}}; $stat}},
        @{n="L3 Cache Size"; e={switch($_.L3CacheSize){$null{$stat="NA"} 0{$stat="0"}}; $stat}}

"########### Summary of RAM installed with the vendor, description, size, bank and slot for each DIMM ###########"
$storagecapacity = 0
gwmi -class win32_physicalmemory | 
    foreach {
        new-object -TypeName psobject -Property @{  
        Vendor =$_.manufacture
        Description = $_.description       
        #"Speed in MHz" =$_.speed                                                          
        "Size in GB" = $_.capacity/1gb
        Bank = $_.banklabel                              
        Slot = $_.devicelocator                  
    }                 
$storagecapacity += $_.capacity/1gb} |
    format-table -auto @{n='Vendor';e={ if ($_.manufacturer) {$_.manufacturer} else {"VMWare"} } }, description, "Size in GB", Bank, Slot
"Total RAM is ${storagecapacity} GB"

"########## Physical Disk Drives with vendor, model, size and space usage ##########"
$diskdrives = Get-CIMInstance CIM_diskdrive

  foreach ($disk in $diskdrives) {
      $partitions = $disk|get-cimassociatedinstance -resultclassname CIM_diskpartition
      foreach ($partition in $partitions) {
            $logicaldisks = $partition | get-cimassociatedinstance -resultclassname CIM_logicaldisk
            foreach ($logicaldisk in $logicaldisks) {
                     new-object -typename psobject -property @{Manufacturer=$disk.Manufacturer
                                                               Location=$partition.deviceid
                                                               Drive=$logicaldisk.deviceid
                                                               "Size(GB)"=$logicaldisk.size / 1gb -as [int]
                                                               }
           }
      }
  }

"########### Video card vendor, description, and current screen resolution ###########"
gwmi win32_videocontroller | 
    format-list @{n="Video Card Vendor"; e={$_.AdapterCompatibility}}, Description,
    @{n="Current Screen Resolution"; e={$_.VideoModeDescription}}