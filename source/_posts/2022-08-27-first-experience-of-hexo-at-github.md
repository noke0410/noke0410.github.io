---
title: GitHub Pages + Hexo 初體驗
abbrlink: 2298528788
date: 2022-08-27 00:19:28
tags:
  - GitHub
  - Hexo
categories: Hexo
---

# 前言

雖然很早以前就已經知道可以利用 [GitHub Pages](https://pages.github.com/) 建立 Blog 站台，也許是不擅文字表達的關係，但從未想過要自己試著建立一個 Blog 去記綠這些年所學到的東西。直到最近開始嘗試，有一種彷彿又回到了新手村的感覺，不斷地在嚐試的過程中跌倒又站起來。身為一個菜八巴，在參考了許多文章之後，決定跟隨多數人的腳步採用 [GitHub](https://github.com/) + [Hexo](https://hexo.io/zh-tw/) 的架構進行 Blog 站台的架設。

# Hexo

## 安裝需求

在安裝 Hexo 前必須先確認電腦已經安裝下列軟體：

- [Node.js](http://nodejs.org/)
- [Git](http://git-scm.com/)

## 安裝 Hexo

確認 Node.js 跟 Git 都已經安裝完畢之後就可以透過 npm 開始進行 Hexo 的安裝。

```bash
npm install -g hexo-cli
```

## 建立 Blog

Hexo 安裝完畢後，參考[官方文件](https://hexo.io/zh-tw/docs/setup)執行下列指令，Hexo 會在指定資料夾中建立所有需要的檔案。

```bash
hexo init Blog
cd Blog
npm install
```

依序執行到這一個步驟結束，基本上就已經建立好一個附帶 [Hello World](/Hexo/20220818/1243066710/) 最基礎的 Blog 了，接下來就可以進一步針對 <font color="red">\_config.yml</font> 進行網站的設定。

## 網站設定

依據[官方文件](https://hexo.io/zh-tw/docs/configuration)所述，可以針對網站的 title(網站標題)、description(網站的描述)、keywords(網站的關鍵字)、language(網站使用的語言)、author(作者)、theme(網站使用的主題名稱)以及 deploy(佈署設定)等等諸多不同類型的屬性進行設定。

## 網站主題(Theme)

官網裡提供的[主題](https://hexo.io/themes/)樣式多得令人感到眼花撩亂，不知該如何下手，經過一輪調查最終選定 [NexT](https://theme-next.js.org/)，好處是 NexT 本身就提供四種主題風格可以任君挑選，並且支援深色模式及多重語言，加上官方提供完整的[教學](https://theme-next.js.org/docs/getting-started/)可以輕鬆地完成安裝與設定，完全深得工程師的心。

## 在 GitHub Pages 上部署 Hexo

同樣地，可以參考[官方文件](https://hexo.io/zh-tw/docs/github-pages)開始進行設定。但必須先在 GitHub 建立好名為 username.github.io 的儲存庫(Repository)，並前往 Settings > Pages > Source，將 branch 改為 gh-pages 後儲存，設定完畢之後就可以參考[一鍵部署](https://hexo.io/docs/one-command-deployment)的部份去修改 <font color="red">\_config.yml</font>。

由於希望除了 Blog 的功能之外，還要做到可以將整份 Hexo 備份到同一個儲存庫，所以針對這個儲存庫的分支(Branch)做了一個簡單的規劃如下：

| 分支(Branch) | 分支功用          |
| :----------- | :---------------- |
| master       | 備份 Hexo         |
| gh-pages     | GitHub Pages 使用 |

### 安裝 [hexo-deployer-git](https://github.com/hexojs/hexo-deployer-git)

```bash
npm install hexo-deployer-git --save
```

### 修改 \_config.yml

修改 deploy 內容如下：

```bash
deploy:
  type: git
  repo: https://github.com/<username>/<project>
  # example, https://github.com/hexojs/hexojs.github.io
  branch: gh-pages
```

## 同時更新及備份 Hexo

先前有提到希望可以同時更新及備份 Hexo，設定完 Blog 頁面的相關設定後，還需要設定備份的部份。

### 備份設定

```bash
git init # 建立本地儲存庫
git remote add origin https://github.com/<username>/<username>.github.io.git # 連接 Github 儲存庫
```

建立本地儲存庫之後，在 Hexo 目錄會出現一個 .git 目錄，這個目錄是一個被隱藏的項目。如果要看連接 Github 儲存庫有沒有成功，可以到 /.git/config 這個檔案查看。確認本地儲存庫及 Github 儲存庫都設定都正常後，即可將檔案部署到 GitHub 上。

```bash
git add . # 將新增/異動的檔案加入索引區
git commit -m "更新訊息" # 將索引區內的檔案 commit 成更新版本
git push -u origin master # 部署到 Github 上
```

### 建立指令檔

建立一個指令檔(depoly.ps1)，將以下內容複製到檔案中儲存。

```powershell
cd {absolute_path}
git add .
git commit --amend --no-edit
git push -f
hexo cl # 刪除已經生成的 public 資料夾
hexo d -g # 根據新內容生成 public 資料夾，並部署上線
```

完成之後，就可以透過執行以下指令達到發佈文章的同時順便進行備份的目的。

```powershell
powershell -file depoly.ps1
```
