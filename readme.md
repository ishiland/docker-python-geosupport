# docker-python-geosupport [![Build Status](https://travis-ci.com/ishiland/docker-python-geosupport.svg?branch=master)](https://travis-ci.com/ishiland/docker-python-geosupport)
Spin up a Docker container to geocode NYC addresses fast and securely using [python-geosupport](https://github.com/ishiland/python-geosupport) and DCP's [Geosupport Desktop Edition](https://www1.nyc.gov/site/planning/data-maps/open-data/dwn-gde-home.page).

## What do I need?
 - [Docker](https://docs.docker.com/install/). If you never used Docker before, you may want to take a few minutes to get [familiar](https://docs.docker.com/get-started/) with it. 
 - Local storage. At the time of this writing the built docker container takes up 2.2 GB.

## Build the container
```shell
> git clone https://github.com/ishiland/docker-python-geosupport.git
> docker build -t=ishiland/geosupport docker-python-geosupport
```
## Run the container
```shell
> docker run -it ishiland/geosupport
```
This will open up the shell command inside the running container where you run [python-geosupport](https://github.com/ishiland/python-geosupport) against the installed Geosupport Desktop.
### Run with tests
```shell
> docker run -it ishiland/geosupport /bin/sh test.sh
```
