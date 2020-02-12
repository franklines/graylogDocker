FROM ubuntu:20.04
LABEL maintainer="Franklin Escobar"
LABEL github="https://github.com/franklines"

RUN apt-get update && \
    apt-get install -y \
    apt-transport-https \
    openjdk-8-jre-headless \
    uuid-runtime \
    pwgen \
    wget 

RUN wget https://packages.graylog2.org/repo/packages/graylog-3.2-repository_latest.deb -O /root/graylog-3.2-repository_latest.deb && \
    dpkg -i /root/graylog-3.2-repository_latest.deb && \
    apt-get update && \
    apt-get install -y graylog-server

COPY docker-entrypoint.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]