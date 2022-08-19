---
title: PowerShell 影像整理法(Ver. 20221121)
tags:
  - PowerShell
categories: PowerShell
abbrlink: 1974820602
date: 2022-11-21 23:44:56
---

自從月初寫完[第一版](../powershell/20221107/668784789/)整理影像檔案的Script之後用了幾次，發現沒有想像中的好用。尤其整段Script的語法實在簡陋的令人無法接受，而且最大的敗筆就是如果要整理不同副檔名的RAW檔或是JPG檔時，居然還要再改Script，簡直是為人所詬病。

基於種種因素，於是有了底下的小改版，也當作是練習PowerShell。

```powershell
$sourcePath = "C:\DCIM"
$targetBasePath = "$env:USERPROFILE\影像整理"
$keepSourceFile = $true
$jpgFiles = ".jpg", ".jpeg"
$rawFiles = ".cr2", ".cr3"
$videoFiles = ".mp4"

#定義搬檔函式
function move_file {
    param($SourceFile, $TargetFile, $KeepSource)

    if ((Test-Path -Path (Split-Path -Path $targetFile)) -eq $false) {
        mkdir -Path $targetPath
    }
    if ((Test-Path -Path $targetFile) -eq $false) {
        if ($keepSource -eq $true) {
            Copy-Item -Path $sourceFile -Destination $targetFile
            "Copy $_ To $targetPath\$_"
        } else {
            Move-Item -Path $sourceFile -Destination $targetFile
            "Move $_ To $targetPath\$_"
        }
    }
}

#迴圈處理檔案
Get-ChildItem -Path $sourcePath | ForEach-Object {
    $date = "{0:yyyy_MM_dd}" -f $_.LastWriteTime
    $year = $date.Substring(0, 4)

    #處理JPG Files
    if ($jpgFiles -contains $_.Extension) {
        $targetPath = "$targetBasePath\照片\JPG\$year\$date"
        move_file -SourceFile $_.FullName -TargetFile "$targetPath\$_" -KeepSource $keepSourceFile
    }

    #處理Raw Files
    if ($rawFiles -contains $_.Extension) {
        $targetPath = "$targetBasePath\照片\RAW\$year\$date"
        move_file -SourceFile $_.FullName -TargetFile "$targetPath\$_" -KeepSource $keepSourceFile
    }

    #處理Video Files
    if ($videoFiles -contains $_.Extension) {
        $targetPath = "$targetBasePath\影片\$date"
        move_file -SourceFile $_.FullName -TargetFile "$targetPath\$_" -KeepSource $keepSourceFile
    }

}

#開啟目的資料夾
explorer.exe $targetBasePath
```
