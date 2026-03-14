FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    php \
    php-fpm \
    php-mysql \
    php-xml \
    php-mbstring \
    curl \
    mariadb-client \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /run/php

COPY tools/setup.sh /setup.sh

RUN chmod +x /setup.sh

ENTRYPOINT ["/setup.sh"]
