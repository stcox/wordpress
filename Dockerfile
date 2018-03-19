FROM wordpress:php7.2-fpm

RUN apt-get update && apt-get install -y \
        libicu-dev \
        libmagickwand-dev \
        libsodium-dev \
        nano \
        sudo less mysql-client \
        redis-tools \
        --no-install-recommends && rm -r /var/lib/apt/lists/* \

    && pecl install redis-3.1.4 imagick-3.4.3 libsodium-2.0.10 \
    && docker-php-ext-enable redis imagick sodium \
    && docker-php-ext-install -j$(nproc) exif gettext intl sockets zip

RUN curl -o /bin/wp-cli.phar https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
COPY wp-su.sh /bin/wp
RUN chmod +x /bin/wp-cli.phar

COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["php-fpm"]
