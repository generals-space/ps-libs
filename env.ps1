#######################################################################################

<#
获取环境变量列表.
默认为用户级别, 如需查看系统级别, 需要添加 sys 参数(注意这是函数参数, 而不是命令行选项...)
[System.Environment]::GetEnvironmentVariables() 的可选范围有3个:
Machine, Process, User, 暂时还不清楚 Process 表示的具体范围, 可能精确到某个进程???
#>
function GetEnvs {
    param (
        $scope ## 默认为空
    )
    if ($scope -eq 'sys') {
        [System.Environment]::GetEnvironmentVariables("machine");
    } else {
        [System.Environment]::GetEnvironmentVariables("user");
    }
}

<#
获取指定的环境变量值.
默认为用户级别, 如需查看系统级别, 需要添加 sys 参数(注意这是函数参数, 而不是命令行选项...)
#>
function GetEnv {
    param (
        ## 目标变量名, 默认为 path
        $key='path', 
        ## 环境变量级别
        $scope='user' 
    )
    if ($scope -eq 'sys') {
        [System.Environment]::GetEnvironmentVariable($key, "machine");
    } else {
        [System.Environment]::GetEnvironmentVariable($key, "user");
    }
}

function SetEnv {
    param (
        $key = '',
        $val = '',
        $scope = 'user'
    )
    ## 将 val 设置为空表示将此环境变量删除.
    ## if (($key -eq '') -or ($val -eq '')) {
    if ($key -eq '') {
        return
    }
    if ($scope -eq 'sys') {
        [System.Environment]::SetEnvironmentVariable($key, $val, "machine");
    } else {
        [System.Environment]::SetEnvironmentVariable($key, $val, "user");
    }
}

#######################################################################################

<#
查看 Path 环境变量. 
默认查看用户级别, 如需查看系统级别, 需要添加 sys 参数(注意这是函数参数, 而不是命令行选项...)
#>
function PathList {
    param (
        $scope = 'user'
    )
    if ($scope -eq 'sys') {
        $Paths = [System.Environment]::GetEnvironmentVariable("path", "machine");
    } else {
        $Paths = [System.Environment]::GetEnvironmentVariable("path", "user");
    }
    $Paths -split ";"
}

<#
新增一个 Path 环境变量, 这里只设置用户级别而不是系统级别.
#>
function PathAdd {
    param (
        $TargetPath = ''
    )
    if ($TargetPath -eq ''){
        return;
    } 

    $Paths = [System.Environment]::GetEnvironmentVariable("path", "user");
    $NewPaths = ($Paths + ';' + $TargetPath);
    [System.Environment]::SetEnvironmentVariable("path", $NewPaths, "user");
}

<#
从用户级别的 Path 环境变量中移除一个成员.
#>
function PathDel {
    param (
        $TargetPath
    )
    if ($TargetPath -eq ''){
        return;
    } 

    $Paths = [System.Environment]::GetEnvironmentVariable("path", "user");
    $PathArray = ($Paths -split ";")
    ## 构造空数组.
    $NewPathArray = @()
    ## powershell 中的 for/foreach 循环是表达式, 与管道操作 foreach-object 是两回事.
    foreach ($Path in $PathArray) {
        if ($Path -ne $TargetPath) {
            $NewPathArray += $Path;
        }
    }
    $NewPaths = ($NewPathArray -join ';')
    [System.Environment]::SetEnvironmentVariable("path", $NewPaths, "user");
}