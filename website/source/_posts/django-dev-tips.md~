---
title: django dev tips
date: 2017-03-14 19:47:32
tags:
---

## 1. Basic Structure
----------
###1.1 One site with multiple apps
Django's primary goal is to ease the creation of complex, database-driven websites. Django emphasizes reusability and "pluggability" of components, rapid development, and the principle of don't repeat yourself. 

![enter image description here](https://image.slidesharecdn.com/djangoappdeployment-140825015610-phpapp02/95/django-app-deployment-in-azure-by-saurabh-agarwal-5-638.jpg?cb=1410754269)

Python is used throughout, even for settings files and data models. Django also provides an optional administrative create, read, update and delete interface that is generated dynamically through introspection and configured via admin models.


    INSTALLED_APPS = [
	    'django.contrib.admin',
	    'django.contrib.auth',
	    'django.contrib.contenttypes',
	    'django.contrib.sessions',
	    'django.contrib.messages',
	    'django.contrib.staticfiles',
	    'rest_framework',
	    'django.contrib.sessions',
	    'django.contrib.messages',
	    'django.contrib.staticfiles',
	    'rest_framework',
	    'rest_framework_jwt',
	    'corsheaders',
	    'api',
	]


###1.2 MVT

The **Model-View-Template (MVT)** is slightly different from MVC. In fact the main difference between the two patterns is that Django itself takes care of the Controller part (Software Code that controls the interactions between the Model and View), leaving us with the template. The template is a HTML file mixed with Django Template Language (DTL).

<i class="icon-link"></i>URLS <i class="icon-left"></i> <i class="icon-eye"></i> Views <i class="icon-left"></i> <i class="icon-shield"></i> Models </i><i class="icon-left"></i><i class="icon-briefcase">Database

![enter image description here](http://wiki.openhatch.org/images/thumb/f/fd/Mtv-diagram.png/400px-Mtv-diagram.png)

<i class="icon-link"></i>URLS <i class="icon-left"></i> <i class="icon-retweet"></i> Middlewares  <i class="icon-left"></i> <i class="icon-eye"></i> Views <i class="icon-left"></i> <i class="icon-shield"></i> Models </i><i class="icon-left"></i><i class="icon-briefcase">Database

    MIDDLEWARE = [
	    'django.contrib.sessions.middleware.SessionMiddleware',
	    'django.middleware.common.CommonMiddleware',
	    'django.middleware.csrf.CsrfViewMiddleware',
	    'django.contrib.auth.middleware.AuthenticationMiddleware',
	    'django.contrib.messages.middleware.MessageMiddleware',
	    'django.middleware.clickjacking.XFrameOptionsMiddleware',
	    'corsheaders.middleware.CorsMiddleware',
	    'django.middleware.security.SecurityMiddleware',
	    # 'api.auth.JWTAuthenticationMiddleware',
	]

###1.3 DB sync
Migrations are Django’s way of propagating changes you make to your models (adding a field, deleting a model, etc.) into your database schema. 

    $ python3 manage.py makemigrations api
    $ python3 manage.py migrate
