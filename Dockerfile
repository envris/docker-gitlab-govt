FROM ubuntu:trusty
MAINTAINER Aaron Nicoli <aaronnicoli@gmail.com>

RUN echo 'APT::Install-Recommends 0;' >> /etc/apt/apt.conf.d/01/norecommends \
 && echo 'APT::Install-Suggests 0;' >> /etc/apt/apt.conf.d/01/norecommends \
 && apt-get update \
 && apt-get install -y vim.tiny wget sudo net-tools ca-certificates unzip \
 && rm -rf /var/lib/apt/lists/*
