---
title: 將Windows預設輸入法改成以 ENG (英文)
tags:
  - PowerShell
  - Windows
  - 輸入法
categories: PowerShell
abbrlink: 3990464666
date: 2023-09-05 21:54:16
---

自從微軟很好心地將中文版Windows預設輸入法設定為作業系統內建的「微軟新注音」輸入法後，導致幾乎無論是要做什麼事情都要先切換為英數再開始輸入指令，實在不勝其擾。還好皇天不負苦心人，讓我找到可以快速設定的方式！保哥提供了一個[多語言輸入法設定技巧：使用 Windows PowerShell 快速建立](https://blog.miniasp.com/post/2020/03/19/Devs-must-setup-multi-language-input-method)的方法(偉哉保哥~ 善哉保哥~)，但每每換一台電腦就要重新Google一次，最終還是決定自行收編了。

```powershell
$UserLanguageList = New-WinUserLanguageList -Language "zh-TW"
$UserLanguageList.Add("en-US")
Set-WinUserLanguageList -LanguageList $UserLanguageList -Force
Set-WinDefaultInputMethodOverride -InputTip "0409:00000409" #將預設輸入法改成以 ENG (英文) 為主要輸入法！
```
