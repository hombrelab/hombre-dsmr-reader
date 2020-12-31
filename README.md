# hombre-dsmr-reader
![Docker Pulls](https://img.shields.io/docker/pulls/hombrelab/hombre-dsmr-reader) ![Docker Image Version (latest by date)](https://img.shields.io/docker/v/hombrelab/hombre-dsmr-reader) ![GitHub commit activity](https://img.shields.io/github/last-commit/hombrelab/hombre-dsmr-reader)  

The [hombre-dsmr-reader](https://hub.docker.com/repository/docker/hombrelab/hombre-dsmr-reader) image is based on the [hombre-alpine](https://hub.docker.com/repository/docker/hombrelab/hombre-alpine) image and [DSMR-reader v4.9.0](https://github.com/dennissiemensma/dsmr-reader).  
It is a customized Docker image for and by [@Hombrelab](me@hombrelab.com).

Information how to use this version of the DSMR-reader is in the [DSRM-reader documentatie (dutch)](https://dsmr-reader.readthedocs.io/nl/v3/).

Deployment examples:

Command line
```shell script
docker run \
    --name dsmr-reader \
    --detach \
    --restart unless-stopped \
    --volume /home/data/dsmr-reader/backup:/dsmr-reader/backups \
    --volume /home/data/dsmr-reader/www:/var/www/dsmrreader/static \
    --volume /home/data/dsmr-reader/logs:/var/log/nginx \
    --volume /etc/localtime:/etc/localtime:ro \
    --env PASSWORD=hombrelab \
    --env DB_HOST=postgres-db \
    --env DB_NAME=dsmrreader \
    --env DB_USER=dsmrreader \
    --env DB_PASS=dsmrreader \
    --env DSMR_USER=hombrelab \
    --env DSMR_EMAIL=me@hombrelab.com \
    --env DSMR_PASSWORD=hombrelab \
    --publish 80:80 \
    --publish 443:443 \
    hombrelab/hombre-dsmr-reader
```
Docker Compose
```yaml
    dsmr-reader:
        container_name: dsmr-reader
        restart: unless-stopped
        image: hombrelab/hombre-dsmr-reader
        volumes:
            - /home/data/dsmr-reader/backup:/dsmr-reader/backups
            - /home/data/dsmr-reader/www:/var/www/dsmrreader/static
            - /home/data/dsmr-reader/logs:/var/log/nginx
            - /etc/localtime:/etc/localtime:ro
        environment:
            - PASSWORD=hombrelab
            - DB_HOST=postgres-db
            - DB_NAME=dsmrreader
            - DB_USER=dsmrreader
            - DB_PASS=dsmrreader
            - DSMR_USER=hombrelab
            - DSMR_EMAIL=me@hombrelab.com
            - DSMR_PASSWORD=hombrelab
        ports:
            - 80:80
            - 443:443
        depends_on:
            - postgres-db
```