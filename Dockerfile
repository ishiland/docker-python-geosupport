FROM jfloff/alpine-python:3.6

# Setting ENV variable from the result of a command does not seem possible here. Need to get child directory name of unzipped geosupport folder. 
# for example: GEO_PATH=$(echo "$(find /$INSTALL_DIR -type d -name *$GEO_VERSION*)") does not work
ENV GEOFILES="/geosupport-install/version-18b_18.2/fls/"\
    LD_LIBRARY_PATH="/geosupport-install/version-18b_18.2/lib/${LD_LIBRARY_PATH}"\
    GEO_VERSION=18b

# Download and extract geosupport
RUN apk update \
  && apk add curl \
  && apk add unzip \
  && curl https://www1.nyc.gov/assets/planning/download/zip/data-maps/open-data/gdelx_$GEO_VERSION.zip -O -J -L \
  && unzip gdelx_$GEO_VERSION.zip -d geosupport-install \
  && rm gdelx_$GEO_VERSION.zip

RUN pip install python-geosupport

ADD ./scripts/test.sh test.sh

# Define default command.
CMD ["/bin/sh"]
