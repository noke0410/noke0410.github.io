---
title: PowerShell 影像整理法
tags:
  - PowerShell
categories: PowerShell
abbrlink: 668784789
date: 2022-11-07 22:54:46
---

自從拍照開始儲存Raw檔後，整理照片/影片就變成一件非常麻煩的事情。一直以來都習慣先手動將照片從記憶卡中複製出來，並依據拍攝日期個別建立資料夾存放，然後再依據下面的結構備份至NAS裡。

| 根目錄 | 子目錄 |
| ------ | ------ |
| 照片 | JPG \ yyyy \ yyyy_mm_dd |
| 照片 | RAW \ yyyy \ yyyy_mm_dd |
| 影片 | yyyy_mm_dd |

然而，如此一來就變成非常的費時又秏工，身為一個~~懶惰的~~挨踢人怎麼可能允許長時間都是如此的人工作業，想睡時還會不小心弄錯。自從聽到Nokia把「科技始終來自於人性」這句話拿來當廣告的經典slogan之後，就一直被~~懶人~~我奉為圭臬，心中一直想著有朝一日一定要寫一個好用的小工具，後來接觸到[PowerShell](https://learn.microsoft.com/zh-tw/powershell/scripting/overview?view=powershell-7.2)這好用的東西，於是就有了底下這段Script幫我解決整理影像上的困擾。

```powershell
$sourcePath = "C:\DCIM"
$targetBasePath = "$env:USERPROFILE\影像整理"
$jpgFile = "*.jpg"
$rawFile = "*.cr3"
$videoFile = "*.mp4"

Get-ChildItem -Path $sourcePath | ForEach-Object {
    $date = "{0:yyyy_MM_dd}" -f $_.LastWriteTime
    $year = $date.Substring(0, 4)

    #處理JPG Files
    if ($_.Extension -like $jpgFile) {
        $targetPath = "$targetBasePath\照片\JPG\$year\$date"
        if (!(Test-Path $targetPath)) {
            mkdir -Path $targetPath
        }
        if (!(Test-Path "$targetPath\$_")) {
            Move-Item -Path $_.FullName -Destination "$targetPath\$_"
            "Move $_ To $targetPath\$_"
        }
    }

    #處理Raw Files
    if ($_.Extension -like $rawFile) {
        $targetPath = "$targetBasePath\照片\RAW\$year\$date"
        if (!(Test-Path $targetPath)) {
            mkdir -Path $targetPath
        }
        if (!(Test-Path "$targetPath\$_")) {
            Move-Item -Path $_.FullName -Destination "$targetPath\$_"
            "Move $_ To $targetPath\$_"
        }
    }

    #處理Video Files
    if ($_.Extension -like $videoFile) {
        $targetPath = "$targetBasePath\影片\$date"
        if (!(Test-Path $targetPath)) {
            mkdir -Path $targetPath
        }
        if (!(Test-Path "$targetPath\$_")) {
            Move-Item -Path $_.FullName -Destination "$targetPath\$_"
            "Move $_ To $targetPath\$_"
        }
    }

}

explorer.exe $targetBasePath
```