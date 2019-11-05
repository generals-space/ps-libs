# ps-libs

基于powershell的常用工具库(很多都收集于网上, 但都经过验证, 且在注释中保留了出处).

入口文件为 [Microsoft.PowerShell_profile.ps1](./Microsoft.PowerShell_profile.ps1), 将其放置在 `~\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1`, 以实现类似`.bashrc`一样的功能. 

可用于windows桌面版的远程控制, 正好win10自带了ssh功能, 很多操作比远程桌面要方便.

目前实现的功能有:

1. [prompt.ps1](./prompt.ps1);
    - 命令提示符美化
2. [env.ps1](./env.ps1);
    - 环境变量及PATH变量的修改函数
3. [net.ps1](./net.ps1);
    - 简陋的`ip link show`命令
4. [sysinfo.ps1](./sysinfo.ps1);
    - 查看系统信息: 系统版本, CPU, 内存等使用状态及占比
5. [audio.ps1](./audio.ps1);
    - 控制音量
6. [tookit.ps1](./toolkit.ps1);
    - `md5sum`: 计算文件md5值
    - `wget`: 下载文件

> **只用作学习与交流**.
