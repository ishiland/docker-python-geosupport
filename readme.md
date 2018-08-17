# Docker for python-geosupport [![Build Status](https://travis-ci.com/ishiland/docker-python-geosupport.svg?branch=master)](https://travis-ci.com/ishiland/docker-python-geosupport)
Spin up a Docker container to geocode NYC addresses fast and securely using [python-geosupport](https://github.com/ishiland/python-geosupport) and DCP's [Geosupport Desktop Edition](https://www1.nyc.gov/site/planning/data-maps/open-data/dwn-gde-home.page).

## What do I need?
 - [Docker](https://docs.docker.com/install/). If you never used Docker before, you may want to take a few minutes to get [familiar](https://docs.docker.com/get-started/) with it. 
 - Local storage. At the time of this writing the built docker image takes up 2.2 GB.

## How to run it
 - clone the repo
 - build the image `docker build -t=geosupport .`
 - run the container with `docker run -it geosupport` 

#### Tests
Run `docker run -it geosupport /bin/sh test.sh` . This will run tests on the master branch of `python-geosupport` using the Alpine Linux image.

