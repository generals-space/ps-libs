<#
.SYNOPSIS
Short description

.DESCRIPTION
Long description

.EXAMPLE
An example
存放路径: ~\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1

.NOTES
General notes

## golang代理设置
set http_proxy='http://162.219.127.7:3128'
set https_proxy='https://162.219.127.7:3128'
git config --global http.proxy http://162.219.127.7:3128
git config --global https.proxy https://162.219.127.7:3128

#> 

## 手动设置cmd属性中代码页为936
chcp 936

## 设置别名
## 下面这种形式也可以
## Set-Alias ll Get-ChildItem;
Set-Alias -Name ll -Value Get-ChildItem;
Set-Alias -Name dk -Value docker;
Set-Alias -Name dc -Value docker-compose;

## 加载公共函数, 有两种方法
## . .\toolkit.ps1 ## 相对路径貌似不合法
## . ~\Documents\WindowsPowerShell\toolkit.ps1;
Import-Module ~\Documents\WindowsPowerShell\toolkit.ps1;
Import-Module ~\Documents\WindowsPowerShell\env.ps1;
Import-Module ~\Documents\WindowsPowerShell\sysinfo.ps1;
Import-Module ~\Documents\WindowsPowerShell\net.ps1;
Import-Module ~\Documents\WindowsPowerShell\audio.ps1;
Import-Module ~\Documents\WindowsPowerShell\prompt.ps1;

#######################################################################################
<#
git, go get 可用, 但是只能在powershell终端中使用
#>
function enproxy {
    param ()
    
    SetEnv http_proxy http://127.0.0.1:1081;
    SetEnv https_proxy http://127.0.0.1:1081;
}
function deproxy {
    param ()
    
    SetEnv http_proxy 
    SetEnv https_proxy 
}
