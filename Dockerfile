FROM osgeo/gdal:ubuntu-small-3.3.0

ADD ./preinstalled.R /preinstalled.R

ENV DEBIAN_FRONTEND=noninteractive

RUN set -ex \
    && apt-get update \
    && apt-get install --no-install-recommends -y \
         dirmngr gnupg apt-transport-https ca-certificates software-properties-common \
    && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9 \
    && add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/" \
    && apt-get install -y build-essential file git libxml2-dev libbz2-dev unzip \
    && apt-get install -y r-base python3 python3-dev python3-pip libsqlite3-mod-spatialite \
    && chmod -R a+w /usr/lib/R/library \
    && LIBRARY_PATH=/lib:/usr/lib /bin/sh -c "Rscript /preinstalled.R" \
    && apt-get purge -y dirmngr gnupg apt-transport-https software-properties-common \
    && apt-get purge -y libxml2-dev libbz2-dev \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*
