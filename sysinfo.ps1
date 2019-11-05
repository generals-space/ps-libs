<#
获取系统信息(版本类型, 版本号)
#>
function sysinfo {
    Get-WmiObject -Class Win32_OperatingSystem | 
        Format-List Caption,Organization,Version,BuildNumber,SerialNumber,RegisteredUser
}

<#
获取内存总量及使用数量等信息
## 单位为1mb
#>
function free {
    ## Win32_PhysicalMemory 获取的是物理内存条的信息, 
    ## 如果机器上装了多个内存条, 那 $capacity 的结果可能有多行,
    ## 而我们需要计算ta们的和...

    ## $capacity = (Get-WmiObject -Class Win32_PhysicalMemory).capacity
    ## ## Measure-Object 用于计算管道数据, $capacity 用换行分隔, 
    ## ## 其实也可以计算空格分隔的数据(即单行数据).
    ## $sum = ($capacity | Measure-Object -Sum).sum
    ## $sum = $sum / 1mb

    ## ...不过貌似如下语句直接就可以得到内存总量了啊.
    $sum = (Get-WmiObject -Class win32_OperatingSystem).TotalVisibleMemorySize

    $osData = Get-WmiObject -Class Win32_OperatingSystem
    $available = $osData.FreePhysicalMemory ## 这里的单位直接就是mb
    $used = $sum - $available

    'Sum:       {0} MB' -f $sum
    'Used:      {0} MB' -f $used
    'Available: {0} MB' -f $available
    'Percent:   {0:P}'  -f ($used / $sum)
}

<#
CPU核心数及使用率
#>
function cpu {
    $processorInfo = (Get-WmiObject -Class Win32_Processor)
    $physicalCores = $processorInfo.NumberOfCores
    $logicalCores = $processorInfo.NumberOfLogicalProcessors
    $percent = $processorInfo.LoadPercentage
    'Physical Cores: {0}' -f $physicalCores
    'Logical Cores:  {0}' -f $logicalCores
    'Usage Percent:  {0}' -f $percent
}