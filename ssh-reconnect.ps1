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
    star-job -scriptblock {ssh forward-ssh}
}

$exist = (get_ssh_proc forward-rdp | Measure-Object).Count
if ($exist -eq 0) {
    star-job -scriptblock {ssh forward-rdp}
}
