---
title: Django Production Configuration
date: 2017-03-14 20:50:29
tags: [hbwang,Django，deploy]
---


Django + uWSGI + Nginx + SSL

Install [uWSGI](https://uwsgi-docs.readthedocs.io/en/latest/) by

	$ sudo pip install uwsgi

Edit configuration in uwsgi.ini

	[uwsgi]
	# variables
	projectname = license
	projectdomain = example.com
	# base = /var/www/django_website
	
	# config
	master = true
	protocol = uwsgi
	# virtualenv = env
	env = DJANGO_SETTINGS_MODULE=%(projectname).production
	module = %(projectname).wsgi
	socket = 127.0.0.1:2017
	chmod-socket = 666
	vacuum = true
	daemonize = /var/log/uwsgi/%(projectname).log
	http = :8080

Start uWSGI server by 

	$ uwsgi uwsgi.ini

Configuration of nginx

	upstream django {
	    # server unix:///path/to/proj1/site1/site1.socket; # for a file socket
	    server 127.0.0.1:4918; # for a web port socket (we'll use this first)
	}
	
	server {
	    listen      8000;
	    server_name example.com;
	    charset     utf-8;
	
	    client_max_body_size 75M;
	
	    location /media  {
	        alias ~/django_website/media;
	    }

		location /static {
	        alias ~/django_website/static;
	    }
	
	    location / {
	        uwsgi_pass  django;
	        include /etc/nginx/uwsgi_params;
	        include /etc/nginx/mime.types;
	    }
	}
  
	
