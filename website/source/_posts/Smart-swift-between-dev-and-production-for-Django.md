---
title: Smart swift between dev and production for Django
date: 2017-03-14 20:48:59
tags: [hbwang]
---


- **settings.py** for dev environment parameters
- **production.py** for production environment parameters, which will overwrite **settings.py**:

		from license.settings import *
		import os
	
		DEBUG = False
		LICENSE_PRESALE_URL = os.environ['DJANGO_LICENSE_URL']

Start dev server by **manage.py**:

	os.environ.setdefault("DJANGO_SETTINGS_MODULE", "license.settings")

The production server is powered by uWSGI, in **uwsgi.ini**:

	env = DJANGO_SETTINGS_MODULE=%(projectname).production

