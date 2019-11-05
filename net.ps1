<#
功能类似于 ipconfig 命令, 但 ipconfig 是bat时期的东西.
#>
function ip {
    Get-NetIPConfiguration
    ## 还有通过 wmi 接口获取网络接口信息的方法
    ## Get-WmiObject win32_networkadapterconfiguration -filter "ipenabled = 'true'"
}
