### face_platform 1.8 idea 配置
1. open `ficus/website/face/face_platform/java_website`
2. Project Settings - Modules
	- add Web
		- Deplyment Descriptors Path
		`your position/ficus/website/face/face_platform/java_website/src/main/webapp/WEB-INF/web.xml`
		- Web Resource Directories
		`your position/ficus/website/face/face_platform/java_website/src/main/webapp`
	- add Spring
		- New Application Context
3. Project Setting - Libraries
	- add - java
	`your position/ficus/website/face/face_platform/java_website/lib`
4. Project Setting - Artifacts
	- add Web Application : exploded  From Modules
5. Run/Debug Configurations
	- add Tomcat Server local
		- Server / HTTP port : 10110
		- Deployment / add Artifact / Application context: /face