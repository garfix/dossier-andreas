# dossier-andreas

This project contains the data and code to generate [dossier-andreas.net](http://dossier-andreas.net), a website that presents the work of Andreas (Andreas Martens), the well known German/French comics artist.

The "site" map also contains the directories "ai" and "software_architecture". These are some of my other projects. They are old projects, but there are many links to them on the internet (especially to "software_architecture"). I should have placed them on a different domain, but I didn't. And now, because of the links, I don't want to move them anymore.

I have placed it online mainly to open up the data for others to use (open data). Secondly, it allows you to revive the website when I am no longer around to support it (which I hope to do for a long long time :)

The core data (LifeAndWork.xml) is an xml file that contains information about the albums, stories, and images Andreas created, along with information about the editions, publishers and magazines where he was published.

If you want to use any of it, check the license file.

The project creates the many php pages of the website from just two source files: LifeAndWork.xml (data) and Style.xsl (structure and markup).

## Document root

The document root of the website should be the `site` directory.

## Build the site

Have Java installed an make sure the command 'java' is available from the commandline. For instance:

    sudo apt install default-jre

Execute the script

    ./createAndreas.bat

This creates the PHP files that form the site, in`site/andreas`.

## Etc

The website pages used to be static html pages. I turned them into PHP pages just to allow user comments. If you have are having trouble getting the PHP pages to work, consider generating HTML pages in stead. This will make it easier.
