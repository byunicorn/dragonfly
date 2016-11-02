#!/bin/bash

if [ -z "$1" ]
then
echo "Error: 请输入文件名！"
exit
fi

#my github user name and password
user='Sebastian1011'
pswd='1234567890a'

# generate html template
hexo generate

/usr/bin/expect << EOF
set timeout 30
spawn hexo deploy
expect {
	"*es/no" {send "yes\r";exp_continue}
	"Username*" {send "$user\r";exp_continue}
	"Password*" {send "$pswd\r"}	
}
expect eof
EOF


# deploy website
#hexo deploy

#git push md5 files to master
cd ../
git add -A
git commit -m "$1"

/usr/bin/expect << EOF
set timeout 30
spawn git push
expect {
	"*es/no" {send "yes\r";exp_continue}
	"Username*" {send "$user\r";exp_continue}
	"Password*" {send "$pswd\r"}	
}
expect eof
EOF




