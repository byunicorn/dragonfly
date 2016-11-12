---
title: hexo auto send email script
date: 2016-11-11 20:50:09
tags: [zmzhang,hexo]
---

继续上次的自动部署hexo的脚本之后又想要部署的同时给website的各位发送邮件的功能；所以在自动部署的脚本中增加了发邮件和屏幕截图的模块

show me the code:
<!-- more -->


```
	#!/usr/bin/python
# -*- coding: utf-8 -*-
import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from email.mime.application import MIMEApplication
from email.MIMEImage import MIMEImage
import sys
import os
import re
import urllib2
import screenShot
import getpass


# mail config and image website constant
mail_host = "smtp.gmail.com"
mail_user = "your send email account@gmail.com"
mail_pass = r"emailpassword"
mail_subtitle = getpass.getuser() + " Have New Article"
send_to_email_list = ["toEmail1@gmail.com", "toEmail2@gmail.com"]
#set screenshot site
screenshot_website = 'http://yt-dragonfly.tech/dragonfly'
screenshot_image = 'screenshot.png'


if len(sys.argv) > 1:
	mail_subtitle = getpass.getuser() + "'s new article: " + sys.argv[1]
	print mail_subtitle
	pass


# 生成website screenshot
s = screenShot.Screenshot()
s.capture( screenshot_website, screenshot_image)

# 如名字所示Multipart就是分多个部分
msg = MIMEMultipart('related')
msg["Subject"] = mail_subtitle
msg["From"] = mail_user
msg["To"] = ";".join(send_to_email_list)
msg.preamble = mail_subtitle

#Encapsulate the plain and HTML versions of the message body in an
# 'alternative' part , so message agents can decide which they want to display.
msgAlternative = MIMEMultipart('alternative')
msg.attach(msgAlternative)

 # ---这是文字部分---
# msgText = MIMEText('This is the alternative plain text message.')
# msg.attach(msgText)

# reference the image in the IMG SRC attribute by the ID given below
msgText = MIMEText('<br><img src="cid:image1"><br>', 'html', 'utf-8')
msgAlternative.attach(msgText)

# read IMG in the folder
fp = open('website.png')
msgImage = MIMEImage(fp.read())
fp.close()
os.remove(screenshot_image)

# define IMG ID as referenced above
msgImage.add_header('Content-ID', '<image1>')
msg.attach(msgImage)

# ---这是附件部分---
# xls类型附件
# part = MIMEApplication(open('billing.xls', 'rb').read())
# part.add_header('Content-Disposition', 'attachment', filename="billing.xls")
# msg.attach(part)


s = smtplib.SMTP_SSL(mail_host)  # 连接smtp邮件服务器,端口默认是25
s.login(mail_user, mail_pass)  # 登陆服务器
s.sendmail(mail_user, send_to_email_list, msg.as_string())  # 发送邮件
s.close()


```

友情提示：请勿使用163 ，qq等邮箱。。。总是会出现554 错误，原因是服务器判定你发的邮件为垃圾邮件。。。

接下来是网站图片截图，两种可选方式，可以使用selenium + chromedriver 来截图，并且可以添加对js代码的操作，但是这种方法会打开chrmoe浏览器；另一种方法是使用PyQt库：

```
#!/usr/bin/python
import sys
import time
from PyQt4.QtCore import *
from PyQt4.QtGui import *
from PyQt4.QtWebKit import *

class Screenshot(QWebView):
    def __init__(self):
        self.app = QApplication(sys.argv)
        QWebView.__init__(self)
        self._loaded = False
        self.loadFinished.connect(self._loadFinished)

    def capture(self, url, output_file):
        self.load(QUrl(url))
        self.wait_load()
        # set to webpage size
        frame = self.page().mainFrame()
        self.page().setViewportSize(frame.contentsSize())
        # render image
        image = QImage(self.page().viewportSize(), QImage.Format_ARGB32)
        painter = QPainter(image)
        frame.render(painter)
        painter.end()
        print 'saving', output_file
        image.save(output_file)

    def wait_load(self, delay=0):
        # process app events until page loaded
        while not self._loaded:
            self.app.processEvents()
            time.sleep(delay)
        self._loaded = False

    def _loadFinished(self, result):
        self._loaded = True

s = Screenshot()

s.capture('http://baidu.com', 'blog.png')


```