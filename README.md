# dossier-andreas

This project contains the data and code to generate dossier-andreas.net.

I have placed it online mainly to make sure the data about Andreas' work is preserved when I am not around anymore.

If you want to use any of it, check the license file.

The project creates the many php pages of the website from just two source files: LifeAndWork.xml (data) and Style.xsl (structure and markup).

Steps to build:

* Create a directory 'andreas' next to this project's directory.
* Copy or symlink the contents of 'site' into your new 'andreas' directory

Your directory structure should look like this (it may be located in any directory on your file system):
```
 /dossier-andreas (this project)
 /andreas
     favicon.ico
     /andreas
         /php
         /resources
         /images
         /photos
         /shrunk_photos
         /thumbnails
```

* Have Java installed an make sure the command 'java' is available from the commandline.

* Make the following script executable and run it:

 createAndreas.bat

This creates 'index.html' in /andreas and a series of PHP files in /andreas/andreas.

The file index.html is the base file of the site.

(I did not test all of this)
