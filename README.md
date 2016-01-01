# dossier-andreas

This project contains the data and code to generate [dossier-andreas.net](http://dossier-andreas.net), a website that presents the work of Andreas (Andreas Martens), the well known German/French comics artist.

I have placed it online mainly to open up the data for others to use (open data). Secondly, it allows you to revive the website when I am no longer around to support it (which I hope to do for a long long time :)

The core data (LifeAndWork.xml) is an xml file that contains information about the albums, stories, and images Andreas created, along with information about the editions, publishers and magazines where he was published. 

If you want to use any of it, check the license file.

The project creates the many php pages of the website from just two source files: LifeAndWork.xml (data) and Style.xsl (structure and markup).

Steps to build all pages of the website:

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

I did not test all of this, you may need to be creative :) The website pages used to be static html pages. I turned them into PHP pages just to allow user comments. If you have are having trouble getting the PHP pages to work, consider generating HTML pages in stead. This will make it easier.
