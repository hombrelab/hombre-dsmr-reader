# Dockerfile: hombre-dsmr-reader

FROM hombrelab/hombre-alpine AS builder

# clone dsmr-reader
RUN apk add --no-cache \
    git \
    && git clone --branch v3.12 https://github.com/dsmrreader/dsmr-reader.git /dsmr-reader \
    && cp /dsmr-reader/dsmrreader/provisioning/django/postgresql.py /dsmr-reader/dsmrreader/settings.py

FROM hombrelab/hombre-python

ARG version

LABEL version="${version}"
LABEL description="Customized DSMR Reader Docker image"
LABEL maintainer="Hombrelab <me@hombrelab.com>"
LABEL inspiration="getting things done my way"

ENV DSMR_USER admin
ENV DSMR_EMAIL root@localhost
ENV DSMR_PASSWORD admin

ENV DB_HOST dsmrdb
ENV DB_USER dsmrreader
ENV DB_PASS dsmrreader
ENV DB_NAME dsmrreader

# install postgres client en nginx
RUN apk add --no-cache \
    socat \
    postgresql-client \
    nginx \
    supervisor \
    && mkdir /dsmr-reader /app

# change workdir and copy the dsmr-reader folder into the final image
WORKDIR /dsmr-reader

COPY --from=builder /dsmr-reader .

# install all dependencies and remove install libraries
RUN apk add --no-cache --virtual .build-dependencies \
    build-base \
    postgresql-dev \
    && pip install -r ./dsmrreader/provisioning/requirements/base.txt \
    && pip install -r ./dsmrreader/provisioning/requirements/postgresql.txt \
    && apk del .build-dependencies

RUN rm -f /etc/nginx/conf.d/default.conf \
    && mkdir -p /run/nginx/ \
    && mkdir -p /var/www/dsmrreader/static \
    && cp ./dsmrreader/provisioning/nginx/dsmr-webinterface /etc/nginx/conf.d/dsmr-webinterface.conf \
    && ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

EXPOSE 80 443

# install first-run script
COPY ./app/init.sh /app/init.sh
COPY ./app/supervisord.ini /etc/supervisor.d/supervisord.ini

RUN chmod +x /app/init.sh

CMD ["/app/init.sh"]
