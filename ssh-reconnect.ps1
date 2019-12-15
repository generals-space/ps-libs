<#
Register-ScheduledJob -Name cronJob -FilePath ~\Documents\WindowsPowerShell\ssh-reconnect.ps1

$cronTrigger = New-JobTrigger -Once -RepeatIndefinitely -At (Get-Date) -RepetitionInterval (New-TimeSpan -Seconds 60)

Add-JobTrigger -Name cronJob -Trigger $cronTrigger
#>

<#
获取ssh进程状态
#>
function get_ssh_proc {
    param (
        $target
    )
    return Get-WmiObject win32_process -filter "name = 'ssh.exe' and commandline like '%$target%'"
}

$exist = (get_ssh_proc forward-ssh | Measure-Object).Count
if ($exist -eq 0) {
    ## 本来想尝试使用 start-job 启动ssh的后台进程的, 
    ## 但是创建的job对象总是很快就变成`Completed`状态, 无法持续存在.
    ## 也尝试过 {& ssh forward-ssh >console.out 2>console.err},
    ## 仍然没用, 于是换用 start-process, 用效.
    ## 参考文章 [Start a detached background process in PowerShell](https://stackoverflow.com/questions/25023458/start-a-detached-background-process-in-powershell)
    ##
    ## start-job -scriptblock {ssh forward-ssh}
    Start-Process ssh -ArgumentList 'forward-ssh' -WindowStyle Hidden
}

$exist = (get_ssh_proc forward-rdp | Measure-Object).Count
if ($exist -eq 0) {
    ## start-job -scriptblock {ssh forward-rdp}
    Start-Process ssh -ArgumentList 'forward-rdp' -WindowStyle Hidden
}

$exist = (get_ssh_proc forward-vnc | Measure-Object).Count
if ($exist -eq 0) {
    ## start-job -scriptblock {ssh forward-vnc}
    Start-Process ssh -ArgumentList 'forward-vnc' -WindowStyle Hidden
}
