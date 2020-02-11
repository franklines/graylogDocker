#!/bin/bash
set -e

function confCred() 
{
    if [[ -z $1 ]];
    then 
        TEMP_PASS=$(pwgen -s1 32 | tee -a /var/log/graylog-server/tmp-pass.log);
        GRAYLOG_PASS=$(echo ${TEMP_PASS} | shasum -a 256);
        GRAYLOG_SECRETPEPPER=$(pwgen -N 1 -s 96);
        sed -i "/root_password_sha2/c\root_password_sha2 = ${GRAYLOG_PASS}" /etc/graylog/server/server.conf;
        sed -i "/password_secret/c\password_secret = ${GRAYLOG_SECRETPEPPER}" /etc/graylog/server/server.conf;
    else
        GRAYLOG_PASS=$(echo -n $1 | sha256sum | cut -d' ' -f1);
        GRAYLOG_SECRETPEPPER=$(pwgen -N 1 -s 96);
        sed -i "/root_password_sha2/c\root_password_sha2 = ${GRAYLOG_PASS}" /etc/graylog/server/server.conf;
        sed -i "/password_secret/c\password_secret = ${GRAYLOG_SECRETPEPPER}" /etc/graylog/server/server.conf;
    fi
}

function confMongo()
{
    if [[ ! -z $1 ]];
    then
    # username:password@server
        sed -i "/mongodb_uri = mongodb:\/\/localhost\/graylog/c\mongodb_uri = mongodb://$1:27017/graylog" /etc/graylog/server/server.conf;
    fi
}

function confElastic()
{
    if [[ ! -z $1 ]];
    then
    #elasticsearch_hosts = http://node1:9200,http://user:password@node2:19200
        sed -i "/elasticsearch_hosts/c\elasticsearch_hosts = $1" /etc/graylog/server/server.conf;
    fi
}

function confHttpBind()
{
    if [[ -z $1 ]];
    then
        sed -i "/http_bind_address \= 127.0.0.1/c\http_bind_address \= 0.0.0.0:9000" /etc/graylog/server/server.conf;
    else
        sed -i "/http_bind_address \= 127.0.0.1/c\http_bind_address \= $1:9000" /etc/graylog/server/server.conf;
    fi
}

confCred ${GRAYLOG_PASS}

confMongo ${MONGO_INFO};

confElastic ${ES_INFO};

confHttpBind ${HTTP_BIND}

/etc/init.d/graylog-server start

tail -F /var/log/syslog