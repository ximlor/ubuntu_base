FROM ubuntu:18.04

# Set Environment Variables
RUN DEBIAN_FRONTEND=noninteractive

# Set Timezone
ARG TZ=UTC
ENV TZ ${TZ}
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Back up the original file
RUN mv /etc/apt/sources.list /etc/apt/sources.list.bak

# Change Mirror and install require
ADD ./sources.list.ubuntu /etc/apt
RUN mv /etc/apt/sources.list.ubuntu  /etc/apt/sources.list && \
    release=$(cat /etc/lsb-release |grep CODENAME |awk -F= '{print $2}') && \
    sed -i "s/{release}/$release/" /etc/apt/sources.list && \
    apt-get -y update

RUN apt-get update && \
    apt-get install -y --allow-downgrades --allow-remove-essential --allow-change-held-packages git curl wget locales

# Set Encoding
RUN locale-gen en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV LC_CTYPE=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV TERM xterm

# Clean up
RUN apt-get remove && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

