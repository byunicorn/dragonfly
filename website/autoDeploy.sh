#!/bin/bash

if [ -z "$1" ]
then
echo "Error: 请输入文件名！"
exit
fi

# generate html template
hexo generate
# deploy website
hexo deploy

#git push md5 files to master
cd ../
git add -A
git commit -m "$1"

git push



