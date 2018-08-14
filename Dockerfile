FROM python:3.6-alpine

# Set the Geosupport version
ENV geosupport_version=18b

# install python-geosupport
RUN pip install python-geosupport

# Download and extract geosupport
RUN apk update \
  && apk add curl \
  && apk add unzip \
  && curl https://www1.nyc.gov/assets/planning/download/zip/data-maps/open-data/gdelx_$geosupport_version.zip -O -J -L \
  && unzip gdelx_$geosupport_version.zip -d geosupport \
  && rm gdelx_$geosupport_version.zip

# set the environmental variables for Geosupport
ENV GEOFILES /geosupport/version-$geosupport_version/fls
ENV LD_LIBRARY_PATH /geosupport/version-$geosupport_version/lib/

# Define default command.
CMD ["/bin/sh"]