<#
Register-ScheduledJob -Name cronJob -FilePath ~\Documents\WindowsPowerShell\ssh-reconnect.ps1

$cronTrigger = New-JobTrigger -Once -RepeatIndefinitely -At (Get-Date) -RepetitionInterval (New-TimeSpan -Seconds 60)

Add-JobTrigger -Name cronJob -Trigger $cronTrigger
#>

<#
获取本机 ssh 进程状态
#>
function get_ssh_proc {
    param (
        $ssh_target
    )
    return Get-WmiObject win32_process -filter "name = 'ssh.exe' and commandline like '%$ssh_target%'"
}
<#
get_ssh_proc 上面是通过验证本地上的 ssh 进程存在以判断映射端口存在且正常的. 
但是在 win10 环境下, 本地的 ssh 隧道进程存在, 但中转服务器上的端口已经不在了.
这里我们通过 ssh 到中转服务器上执行命令进行查询, 作为判断依据.
#>
function get_ssh_port {
    param (
        $ssh_port
    )
    ## 使用 $var 变量的字符串需要使用双引号包裹.
    $port_list = ssh forwarder "netstat -an | grep -v grep | grep $ssh_port"
    return ($port_list | Measure-Object).Count
}

$exist = (get_ssh_proc forward-ssh | Measure-Object).Count
if ($exist -eq 0) {
    ## 本来想尝试使用 start-job 启动ssh的后台进程的, 
    ## 但是创建的job对象总是很快就变成`Completed`状态, 无法持续存在.
    ## 也尝试过 {& ssh forward-ssh >console.out 2>console.err},
    ## 仍然没用, 于是换用 start-process, 有效.
    ## 参考文章 [Start a detached background process in PowerShell](https://stackoverflow.com/questions/25023458/start-a-detached-background-process-in-powershell)
    ##
    ## start-job -scriptblock {ssh forward-ssh}
    Start-Process ssh -ArgumentList 'forward-ssh' -WindowStyle Hidden
} else {
    ## 如果进程存在, 则需要进一步验证端口映射是否成功, 否则杀掉该 ssh 进程
    if (get_ssh_port 10002 -eq 0) {
        $pid = (get_ssh_proc forward-ssh).ProcessId
        Stop-Process $pid
    }
}
<#
本机是家庭版, 不支持启动远程连接.

$exist = (get_ssh_proc forward-rdp | Measure-Object).Count
if ($exist -eq 0) {
    ## start-job -scriptblock {ssh forward-rdp}
    Start-Process ssh -ArgumentList 'forward-rdp' -WindowStyle Hidden
} else {
    ## 如果进程存在, 则需要进一步验证端口映射是否成功, 否则杀掉该 ssh 进程
    if (get_ssh_port 10003 -eq 0) {
        $pid = (get_ssh_proc forward-rdp).ProcessId
        Stop-Process $pid
    }
}
#>

$exist = (get_ssh_proc forward-vnc | Measure-Object).Count
if ($exist -eq 0) {
    ## start-job -scriptblock {ssh forward-vnc}
    Start-Process ssh -ArgumentList 'forward-vnc' -WindowStyle Hidden
} else {
    ## 如果进程存在, 则需要进一步验证端口映射是否成功, 否则杀掉该 ssh 进程
    if (get_ssh_port 10003 -eq 0) {
        $pid = (get_ssh_proc forward-vnc).ProcessId
        Stop-Process $pid
    }
}
