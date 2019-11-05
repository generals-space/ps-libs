<#
设置命令提示符(彩色)
#>
Push-Location (Split-Path -Path $MyInvocation.MyCommand.Definition -Parent);
function global:prompt {
    $realLASTEXITCODE = $Global:LASTEXITCODE;
    $hostline = " $env:Username@$env:UserDomain ";
    
    $hostColor = [ConsoleColor]::DarkGreen;
    Write-Host $hostline -ForegroundColor White -BackgroundColor $hostColor -NoNewLine;

    $realFolderName = (Get-Item $pwd.ProviderPath).Name;
    
    if ($pwd.ProviderPath -eq $env:UserProfile) {
        $folderName = '~';
    } else {
        $folderName = $realFolderName;
    }

    Write-Host " $folderName " -ForegroundColor White -BackgroundColor DarkGray -NoNewline;

    $Global:LASTEXITCODE = 0;

    Write-Host '$' -ForegroundColor White -NoNewline;
    Write-Output " ";
}
Pop-Location;

