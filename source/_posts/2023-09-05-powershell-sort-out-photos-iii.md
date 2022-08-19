---
title: PowerShell 影像整理法(Ver. 20230904)
tags:
  - PowerShell
categories: PowerShell
abbrlink: 1946704350
date: 2023-09-05 21:15:42
---

時隔多個月，懶人照片整理法再次改版了…

因為照片主要是放在NAS上不是本機(也不想設定網路磁碟機)，又常常不記得是否已經同步過記憶卡裡的檔案(人越老記性越差)，只好繼續改版。

不囉嗦，改版資訊如下：

* 增加網路磁碟機路徑的判斷
* 增加是否有同步檔案的判斷

```powershell
Add-Type -AssemblyName PresentationFramework

$sourcePath = "D:\DCIM\100EOS_R"
$targetBasePath = "$env:USERPROFILE\影像整理"
$smbPath = "\\SmbPath\影像記錄"
$syncFiles = 0
$keepSourceFile = $true
$jpgFiles = ".jpg", ".jpeg"
$rawFiles = ".cr2", ".cr3"
$videoFiles = ".mp4"

#定義訊息函式(https://ss64.com/ps/messagebox.html)
function show_message {
    param(
        $msgBody = 'message'
        , $msgTitle = 'title'
        , $msgButton = 'OK'
        , $msgImage = 'None'
    )
    $Result = [System.Windows.MessageBox]::Show($msgBody, $msgTitle, $msgButton, $msgImage)

    return $Result
}

#定義搬檔函式
function move_file {
    param($SourceFile, $TargetFile, $KeepSource)

    if ((Test-Path -LiteralPath (Split-Path -LiteralPath $targetFile)) -eq $false) {
        mkdir -Path $targetPath
    }
    if ((Test-Path -LiteralPath $targetFile) -eq $false) {
        if ($keepSource -eq $true) {
            Copy-Item -Path $sourceFile -Destination $targetFile
            "Copy $sourceFile To $targetFile"
        }
        else {
            Move-Item -Path $sourceFile -Destination $targetFile
            "Move $sourceFile To $targetFile"
        }
        $global:syncFiles = $global:syncFiles + 1
    }
}

#判斷來源資料夾是否存在
if ((Test-Path -LiteralPath $sourcePath) -eq $false) {
    $result = show_message -msgBody '請檢查來源資料夾是否存在' -msgTitle '警告' -msgImage 'Warning'
    return
}

#判斷網路資料夾是否已存在
if ((Test-Path -LiteralPath $smbPath) -eq $true) {
    $targetBasePath = $smbPath
}

#迴圈處理檔案
Get-ChildItem -LiteralPath $sourcePath | ForEach-Object {
    $date = '{0:yyyy_MM_dd}' -f $_.LastWriteTime
    $year = $date.Substring(0, 4)

    #處理JPG Files
    if ($jpgFiles -contains $_.Extension) {
        $targetPath = "$targetBasePath\照片\JPG\$year\$date"
        $targetFile = [System.String]::Concat("$targetPath", '\', $_.Name)
        move_file -SourceFile $_.FullName -TargetFile $targetFile -KeepSource $keepSourceFile
    }

    #處理Raw Files
    if ($rawFiles -contains $_.Extension) {
        $targetPath = "$targetBasePath\照片\RAW\$year\$date"
        $targetFile = [System.String]::Concat("$targetPath", '\', $_.Name)
        move_file -SourceFile $_.FullName -TargetFile $targetFile -KeepSource $keepSourceFile
    }

    #處理Video Files
    if ($videoFiles -contains $_.Extension) {
        $targetPath = "$targetBasePath\影片\$date"
        $targetFile = [System.String]::Concat("$targetPath", '\', $_.Name)
        move_file -SourceFile $_.FullName -TargetFile $targetFile -KeepSource $keepSourceFile
    }

}

if ($syncFiles -gt 0) {
    $result = show_message -msgBody "本次同步 $syncFiles 個檔案" -msgTitle '資訊' -msgButton 'OK' -msgImage 'Info'
    #開啟目的資料夾
    explorer.exe $targetBasePath
}
else {
    $result = show_message -msgBody '本次無異動，檔案皆已於前次作業同步完畢，請問是否開啟目的資料夾?' -msgTitle '詢問' -msgButton 'YesNo' -msgImage 'Question'
    if ($result -eq 'Yes') {
        #開啟目的資料夾
        explorer.exe $targetBasePath
    }
}
```
