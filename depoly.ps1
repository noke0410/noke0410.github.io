git add .
git commit --amend --no-edit
git push -f
hexo cl # 刪除已經生成的 public 資料夾
hexo d -g # 根據新內容生成 public 資料夾，並部署上線
