---
title: Django HTML Template Email
date: 2017-03-14 20:47:22
tags: [hbwang,Django]
---

Create HTML template **email.html**:

	Hello <strong>{{ username }}</strong> - your account is activated.

You can then send an e-mail using the template by making use of get_template, like this:
	
	from django.core.mail import EmailMultiAlternatives
	from django.template.loader import get_template
	from django.template import Context
	
	htmly     = get_template('email.html')
	
	d = Context({ 'username': username })
	
	subject, from_email, to = 'hello', 'from@example.com', 'to@example.com'
	html_content = htmly.render(d)
	msg = EmailMultiAlternatives(subject, 'text content', from_email, [to])
	msg.attach_alternative(html_content, "text/html")
	msg.send()

Send attachment file like this:

	message.attach('design.png', img_data, 'image/png')
	message.attach("ficus_license", bytes(license_file.text, "utf-8"))
	message.attach_file('/images/weather_map.png')
