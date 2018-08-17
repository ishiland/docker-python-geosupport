#!/bin/sh
FROM alpine:3.7

# VERSIONS
ENV ALPINE_VERSION=3.7 \
    PYTHON_VERSION=3.6.5

# Unable to set GEOFILES and LD_LIBRARY_PATH based on defined geosupport_version. Need additional logic to
# get the name of the `version-18b_` directory.
ENV PYTHON_PATH=/usr/lib/python$PYTHON_VERSION \
    PATH="/usr/lib/python$PYTHON_VERSION/bin/:${PATH}" \
    GEOFILES="/geosupport/version-18b_18.2/fls/"\
    LD_LIBRARY_PATH="/geosupport/version-18b_18.2/lib/${LD_LIBRARY_PATH}"\
    geosupport_version=18b

# The below python dependencies borrowed from https://github.com/jfloff/alpine-python/blob/master/3.6/Dockerfile
ENV PACKAGES="\
    dumb-init \
    musl \
    libc6-compat \
    linux-headers \
    build-base \
    bash \
    git \
    ca-certificates \
"

ENV PYTHON_BUILD_PACKAGES="\
    readline-dev \
    zlib-dev \
    bzip2-dev \
    sqlite-dev \
    libressl-dev \
"

RUN set -ex ;\
    # find MAJOR and MINOR python versions based on $PYTHON_VERSION
    export PYTHON_MAJOR_VERSION=$(echo "${PYTHON_VERSION}" | rev | cut -d"." -f3-  | rev) ;\
    export PYTHON_MINOR_VERSION=$(echo "${PYTHON_VERSION}" | rev | cut -d"." -f2-  | rev) ;\
    # replacing default repositories with edge ones
    echo "http://dl-cdn.alpinelinux.org/alpine/v$ALPINE_VERSION/community" >> /etc/apk/repositories ;\
    echo "http://dl-cdn.alpinelinux.org/alpine/v$ALPINE_VERSION/main" >> /etc/apk/repositories ;\
    # Add the packages, with a CDN-breakage fallback if needed
    apk add --no-cache $PACKAGES || \
        (sed -i -e 's/dl-cdn/dl-4/g' /etc/apk/repositories && apk add --no-cache $PACKAGES) ;\
    # Add packages just for the python build process with a CDN-breakage fallback if needed
    apk add --no-cache --virtual .build-deps $PYTHON_BUILD_PACKAGES || \
        (sed -i -e 's/dl-cdn/dl-4/g' /etc/apk/repositories && apk add --no-cache --virtual .build-deps $PYTHON_BUILD_PACKAGES) ;\
    # turn back the clock -- so hacky!
    echo "http://dl-cdn.alpinelinux.org/alpine/v$ALPINE_VERSION/main/" > /etc/apk/repositories ;\
    # use pyenv to download and compile specific python version
    git clone --depth 1 https://github.com/pyenv/pyenv /usr/lib/pyenv ;\
    PYENV_ROOT=/usr/lib/pyenv /usr/lib/pyenv/bin/pyenv install $PYTHON_VERSION ;\
    # move specific version to correct path delete pyenv, no longer needed
    mv /usr/lib/pyenv/versions/$PYTHON_VERSION/ $PYTHON_PATH ;\
    rm -rfv /usr/lib/pyenv ;\
    # change the path on the header of every file from PYENV_ROOT to PYTHON_PATH
    cd $PYTHON_PATH/bin/ && sed -i "s+/usr/lib/pyenv/versions/$PYTHON_VERSION/+$PYTHON_PATH/+g" * ;\
    # delete binary "duplicates" and replace them with symlinks
    # this also optimizes space since they are actually the same binary
    rm -f $PYTHON_PATH/bin/python$PYTHON_MAJOR_VERSION \
          $PYTHON_PATH/bin/python$PYTHON_MINOR_VERSION \
          $PYTHON_PATH/bin/python$PYTHON_MAJOR_VERSION-config \
          $PYTHON_PATH/bin/python$PYTHON_MINOR_VERSION-config ;\
    ln -sf $PYTHON_PATH/bin/python $PYTHON_PATH/bin/python$PYTHON_MAJOR_VERSION ;\
    ln -sf $PYTHON_PATH/bin/python $PYTHON_PATH/bin/python$PYTHON_MINOR_VERSION ;\
    ln -sf $PYTHON_PATH/bin/python-config $PYTHON_PATH/bin/python$PYTHON_MAJOR_VERSION-config ;\
    ln -sf $PYTHON_PATH/bin/python-config $PYTHON_PATH/bin/python$PYTHON_MINOR_VERSION-config ;\
    # delete files to to reduce container size
    find /usr/lib/python$PYTHON_VERSION -depth \( -name '*.pyo' -o -name '*.pyc' -o -name 'test' -o -name 'tests' \) -exec rm -rf '{}' + ;\
    # remove build dependencies and any leftover apk cache
    apk del --no-cache --purge .build-deps ;\
    rm -rf /var/cache/apk/*

# Download and extract geosupport
RUN apk update \
  && apk add curl \
  && apk add unzip \
  && curl https://www1.nyc.gov/assets/planning/download/zip/data-maps/open-data/gdelx_$geosupport_version.zip -O -J -L \
  && unzip gdelx_$geosupport_version.zip -d geosupport \
  && rm gdelx_$geosupport_version.zip

RUN pip install python-geosupport

ADD ./test.sh test.sh

# Define default command.
CMD ["/bin/sh"]
