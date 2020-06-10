# Get-WmiObject无法获取进程信息

参考文章

1. [Powershell: Get-WmiObject win32_process -ComputerName 无法获得远程机器进程](https://zhidao.baidu.com/question/502748251.html)
2. [win32_process $_.CommandLine returning blank while I'm not an admin](https://social.technet.microsoft.com/Forums/scriptcenter/en-US/5eb197e2-aeeb-4eb6-9e5b-9f90966e5d79/win32process-commandline-returning-blank-while-im-not-an-admin?forum=ITCG)

某次端口映射失败, 但 forward 进程在进程管理器中明明存在. 在调试时发现从命令通过 `Get-WmiObject` 命令无法获取到 forward 的进行信息(但是重新创建进程仍然失败).

当时有考虑过是 win 进程管理器太垃圾, 与实际的进程信息不符, 后来查到通过普通 powershell 与管理员的 powershell 创建的进程是不同的, 普通用户无法操作管理员创建的进程...

至于参考文章1中要加的`-Credential`参数, 会弹出对话框让用户输入账号密码信息, 不适用于我们的场景...

ssh再出这种幺蛾子真的要换了.
