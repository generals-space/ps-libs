<#
计算目标文件的md5值
#>
function md5sum {
    param (
        ## 目标文件路径
        $filepath
    )
    ## 可用算法类型(即`-algorithm`选项): 
    ## SHA1 | SHA256 | SHA384 | SHA512 | MACTripleDES | MD5 | RIPEMD160
    get-filehash -algorithm md5 $filepath;
}

## 先移除 wget 别名, Alias 是一个驱动, 类似于 env
## 可以通过 ls Alias: 查看其中的成员列表.
del Alias:\wget
<#
用于下载文件
#>
function wget {
    param (
        $url
    )
    ## 构造url对象
    $urlObj = ([System.Uri]$url);
    ## 获取下载到本地的文件名
    $filename = [System.IO.Path]::GetFileName($urlObj.LocalPath);
    if($filename -eq ''){
        $filename = 'index.html';
    }
    ## 开始下载
    Invoke-WebRequest -uri $url -outfile $filename;
}
