# dossier-andreas

This project contains the data and code to generate dossier-andreas.net.

I have placed it online mainly to make sure the data about Andreas' work is preserved when I am not around anymore.

If you want to use any of it, check the license file.

The project creates the many php pages of the website from just two source files: LifeAndWork.xml (data) and Style.xsl (structure and markup).

Steps to build:

* Create a directory 'andreas' next to this project's directory.
* Copy or symlink the contents of 'site' into your new 'andreas' directory

Your directory structure should look like this:
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

In order to build the php files in '/andreas/andreas', run

 createAndreas.bat

That should do it. (I did not test it)
