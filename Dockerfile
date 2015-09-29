FROM ubuntu:trusty
MAINTAINER Aaron Nicoli <aaronnicoli@gmail.com>

RUN wget https://github.com/tianon/gosu/releases/download/1.4/gosu-amd64 -O /usr/local/bin/gosu
RUN chmod +x /usr/local/bin/gosu

RUN apt-get update && apt-get install -y libpam-krb5 libkrb5-dev
