# dossier-andreas

This project contains the data and code to generate dossier-andreas.net.

I have placed it online mainly to make sure the data about Andreas' work is preserved when I am not around anymore.

If you want to use any of it, check the license file.

The project creates the pages of the website from just two source files: LifeAndWork.xml (data) and Style.xsl (structure and markup). 

The website will be built in the directory 'andreas' next to this project's directory on your filesystem. Make sure the 'andreas' directory exists.

Copy the directories 'php' and 'resources' into 'andreas'. Your directory structure will look like this:

 /dossier-andreas (this project)
 /andreas
     /php
     /resources
     /images
     /photos
     /shrunk_photos
     /thumbnails

In order to build it, just run

 createAndreas.bat
 
You need to have Java installed to run it.
