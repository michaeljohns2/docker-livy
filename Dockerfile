FROM debian:jessie
MAINTAINER michaeljohns2

## Fork from tobilg <https://github.com/tobilg/docker-livy>
## Updates to use python 2.7 support in livy (tobilg doesn't include any python)
## Note: needed to switch to `debian:jessie` due to issue using overlay in centos host when using `ubuntu:trusty`
## Therefore, not using ubuntu repos, meaning dropped the following used by tobilg:
##  (1) `R List`
##  (2) Mesos 

## Packages

# Add backports for java 8 support (https://github.com/OpenTreeOfLife/germinator/wiki/Debian-upgrade-notes:-jessie-and-openjdk-8)
RUN echo 'deb http://http.debian.net/debian jessie-backports main' >> /etc/apt/sources.list

## Updated:
#   (1) openjdk-7-jdk to openjdk-8-jdk
## Added:
#   (1) sudo, not included in jessie by default
#   (2) python 2.7
#   (3) vim
#   (4) curl
## Removed:
#   (1) libjansi-java
#   (2) libsvn1
#   (3) libcurl3
#   (4) libsasl2-modules 
RUN apt-get update && \
    apt-get install -y \
    sudo \
    python \
    vim \
    curl \
    wget \
    git \
    openjdk-8-jdk \
    maven
   
#UNCOMMENT TO REMOVE DOWNLOADED PACKAGES
#RUN rm -rf /var/lib/apt/lists/*

## Overall ENV vars
ENV SPARK_VERSION 1.6.1
ENV LIVY_BUILD_VERSION livy-server-0.3.0-SNAPSHOT 

## Set lz (download) path for Spark
ENV SPARK_LZ_PATH /apps/lz/spark

## Set install path for Livy
ENV LIVY_APP_PATH /apps/$LIVY_BUILD_VERSION

## Set build path for Livy
ENV LIVY_BUILD_PATH /apps/build/livy

## Set Hadoop config directory
ENV HADOOP_CONF_DIR /etc/hadoop/conf

## Set Spark home directory
ENV SPARK_HOME /usr/local/spark

## Spark ENV vars
ENV SPARK_VERSION_STRING spark-$SPARK_VERSION-bin-hadoop2.6
ENV SPARK_DOWNLOAD_URL http://d3kbcqa49mib13.cloudfront.net/$SPARK_VERSION_STRING.tgz

## Download and unzip Spark
RUN mkdir -p $SPARK_LZ_PATH && \
    cd $SPARK_LZ_PATH && \
    wget $SPARK_DOWNLOAD_URL && \
    mkdir -p $SPARK_HOME && \
    tar xvf $SPARK_VERSION_STRING.tgz -C /tmp && \
    cp -rf /tmp/$SPARK_VERSION_STRING/* $SPARK_HOME && \
    rm -rf -- /tmp/$SPARK_VERSION_STRING

#UNCOMMENT TO REMOVE SPARK LZ ARTIFACTS
#RUN rm -rf $SPARK_LZ_PATH

## Clone Livy repository
RUN mkdir -p /apps/build && \
    cd /apps/build && \
	git clone https://github.com/cloudera/livy.git && \
	cd $LIVY_BUILD_PATH && \
    mvn -DskipTests -Dspark.version=$SPARK_VERSION clean package && \
    unzip $LIVY_BUILD_PATH/assembly/target/$LIVY_BUILD_VERSION.zip -d /apps 

#UNCOMMENT TO REMOVE LIVY BUILD ARTIFACTS
#RUN rm -rf $LIVY_BUILD_PATH

#UNCOMMENT TO ADD `upload` DIR (LEAVE TO DRIVE VIA DOCKER RUN)
#RUN mkdir -p $LIVY_APP_PATH/upload
	
# Add custom files, set permissions
ADD entrypoint.sh .

RUN chmod +x entrypoint.sh

# Expose port
EXPOSE 8998

ENTRYPOINT ["/entrypoint.sh"]
