# Graylog Docker Image built on Ubuntu 20.04 base

[![N|Solid](https://i.imgur.com/O01MUnd.png)](https://hub.docker.com/repository/docker/fescobar94/graylog)

The following repo hosts a Docker image for Graylog 3.2 using Ubuntu 20.04 as the base image. Please see below for install/configuration details.

## Configuration
You can set any of the following environmental values to configure your Graylog container.
| Environment Variable | Value |
| ------ | ------ |
| GRAYLOG_PASS | <Password for admin user> |
| ES_INFO | <ElasticSearch endpoint> |
| MONGO_INFO | <MongoDB partial string> |
| HTTP_BIND | <HTTP bind port> |

**NOTE:** If `GRAYLOG_PASS` is not set, a random admin password will be generated and stored in:
`/var/log/graylog-server/tmp-pass.log`. 

You can see a `MONGO_INFO` and `ES_INFO` example in the docker-compose.yml file. 

For MongoDB specify the following:
`-e MONGO_INFO="username:password@server"`

For ElasticSearch specify the following:
`-e ES_INFO="http://server:9200"`

## Example standalone run

```bash
sudo docker run -d --name graylog -e GRAYLOG_PASS=admin123 -e MONGO_INFO="graylog:password123@mongodb" -e ES_INFO="http://elasticsearch:9200" -p 9000:9000 --network graylog-net fescobar94/graylog:latest
```

## Docker Compose
To deploy a local test setup using docker-compose run the following:
```bash
sudo docker-compose -f docker-compose.yml up -d
```
