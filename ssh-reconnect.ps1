<#
Register-ScheduledJob -Name cronJob -FilePath ~\Documents\WindowsPowerShell\ssh-reconnect.ps1

$cronTrigger = New-JobTrigger -Once -RepeatIndefinitely -At (Get-Date) -RepetitionInterval (New-TimeSpan -Seconds 60)

Add-JobTrigger -Name cronJob -Trigger $cronTrigger
#>


## @function:   获取本机 ssh 转发进程对象
function get_ssh_proc {
    param (
        ## 转发进程名, 一般为 forward-XXX
        $ssh_proc
    )
    return Get-WmiObject win32_process -filter "name = 'ssh.exe' and commandline like '%$ssh_proc%'"
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

## @function:   保持转发进程的存在
function keep_alive {
    param (
        ## 转发进程名, 一般为 forward-XXX
        $ssh_proc,
        ## 映射端口号
        $ssh_port
    )
    $exist = (get_ssh_proc $ssh_proc | Measure-Object).Count
    if ($exist -eq 0) {
        ## 本来想尝试使用 start-job 启动ssh的后台进程的, 
        ## 但是创建的job对象总是很快就变成`Completed`状态, 无法持续存在.
        ## 也尝试过 {& ssh $ssh_proc >console.out 2>console.err},
        ## 仍然没用, 于是换用 start-process, 有效.
        ## 参考文章 [Start a detached background process in PowerShell](https://stackoverflow.com/questions/25023458/start-a-detached-background-process-in-powershell)
        ##
        ## start-job -scriptblock {ssh $ssh_proc}
        Start-Process ssh -ArgumentList "$ssh_proc" -WindowStyle Hidden
    } else {
        ## 如果进程存在, 则需要进一步验证端口映射是否成功, 否则杀掉该 ssh 进程
        if (get_ssh_port $ssh_port -eq 0) {
            $pid = (get_ssh_proc $ssh_proc).ProcessId
            Stop-Process $pid
        }
    }
}

keep_alive forward-ssh
keep_alive forward-vnc
