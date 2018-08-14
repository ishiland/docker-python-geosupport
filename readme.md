# Docker for python-geosupport
Run Geosupport locally on any operating system
 
## How does it work?
This project spins up a Docker container that allows you to geocode NYC addresses fast and securely using [python-geosupport](https://github.com/ishiland/python-geosupport) and DCP's [Geosupport Desktop Edition](https://www1.nyc.gov/site/planning/data-maps/open-data/dwn-gde-home.page).

## What do I need?
 - [Docker](https://docs.docker.com/install/). If you never used Docker before, you may want to take a few minutes to get [familiar](https://docs.docker.com/get-started/) with it. 
 - Local storage. At the time of this writing the built docker image takes up about 2 GB.

## How to run it
 - clone the repo
 - optional: set the `geosupport_version` in the `Dockerfile`. Default is `18b`
 - build the container `docker build -t=geosupport .`
 - run the container with `docker run -it geosupport` 
 