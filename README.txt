docker-trac
===========

https://94.177.253.187/blog/docker-trac

Sept-Oct 2016 Bitelxux

This is a dockerized trac server.

Batteries included:

- CodeExampleMacro
- GitHubSyncPlugin
- Graphviz
- PlantUML
- SensitiveTickets
- SimpleMultiproject
- TracAccountManager
- TracFullBlogPlugin
- TracIncludeMacro
- TracPathTheme
- TracTocMacro
- TracWikiExtras
- TracWikiPrintPlugin
- TracWysiwyg
- etc.

Installation
------------

* If you want to build the image:

docker build -t="bitelxux/trac" .


* Run the container

docker run -d -p 443:443 -v trac:/var/trac --add-host dockerhost:<dockerhostip> --name trac bitelxux/trac

* Test the container

Point your preferred browser to https://<yourip|name> and enjoy !!

* Login into the running container

docker exec -it trac bash

 .. note:
    Should you not feel like building the image or you have any problem building it, you can directly run the container:
   
    docker run -d -p 443:443 -v trac:/var/trac --add-host dockerhost:<dockerhostip> --name trac bitelxux/trac


    It will download the prebuilt image and run the container



