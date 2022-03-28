#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ PHP8 base ~~~~~~~~~~~~~~~~~~~~~~~~
FROM php:8.1-fpm-buster

ARG TARGETARCH

ENV DEBIAN_FRONTEND=noninteractive \
    CONSUL_TEMPLATE_VERSION=0.27.1 \
    GOREPLACE_VERSION=1.1.2


RUN apt-get update -y;

RUN apt-get install zstd supervisor nginx logrotate libzip-dev libyaml-dev musl-dev wget unzip -q -y && \
    wget https://github.com/FriendsOfPHP/pickle/releases/download/v0.7.7/pickle.phar && \
    wget https://releases.hashicorp.com/consul-template/${CONSUL_TEMPLATE_VERSION}/consul-template_${CONSUL_TEMPLATE_VERSION}_linux_${TARGETARCH}.zip \
    -O /tmp/consul-template.zip && \
    wget --quiet -O /usr/local/bin/go-replace https://github.com/webdevops/go-replace/releases/download/${GOREPLACE_VERSION}/gr-64-linux && \
    chmod +x /usr/local/bin/go-replace;

# Copy configs for PHP
COPY configs/php/php.ini /etc/php8.1/php.ini
COPY configs/php/fpm/php-fpm.conf /usr/local/etc/php-fpm.conf
COPY configs/php/fpm/www.conf /usr/local/etc/php-fpm.d/www.conf
COPY configs/php/fpm/zz-docker.conf /usr/local/etc/php-fpm.d/zz-docker.conf
# kostyl
COPY configs/arm-fix.sh /etc/arm-fix.sh

# Install additional PHP extensions
RUN php pickle.phar install igbinary --quiet  && \
    php pickle.phar install zstd --quiet  && \
    php pickle.phar install redis --quiet  && \
    php pickle.phar install xdebug --quiet && \
    php pickle.phar install yaml --quiet && \
    docker-php-ext-enable igbinary zstd redis yaml && \
    docker-php-ext-install zip pcntl

RUN docker-php-source extract && \
    chmod +x /etc/arm-fix.sh && \
    /etc/arm-fix.sh && \
    docker-php-ext-install sockets

# Install composer
RUN curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer

# Copy necessary configuration files
COPY configs/supervisor/conf.d/* /etc/supervisor/conf.d/
COPY configs/supervisor/supervisord.conf /etc/supervisor/supervisord.conf

COPY configs/logrotate/logrotate.d/* /etc/logrotate.d/
COPY configs/logrotate/logrotate.conf /etc/logrotate.conf
COPY configs/cron.daily/logrotate /etc/periodic/daily/logrotate

#Copy nginx configuration files
RUN rm /etc/nginx/sites-enabled/default
COPY configs/nginx/ /etc/nginx/

#Copy entrypoint
COPY ./entrypoint.sh /entrypoint.sh
COPY ./entrypoint.d/* /entrypoint.d/

#Copy consul-template
RUN unzip /tmp/consul-template.zip -d /usr/local/bin/ && \
    chmod +x /usr/local/bin/consul-template

RUN mkdir -p /var/log/supervisor && \
    chmod +x /etc/periodic/daily/logrotate && \
    chmod 0700 /entrypoint.sh && chmod 0755 -R /entrypoint.d/; \
    mkdir -p /var/log/messages; \
    # PHP configuration
    mkdir -p /var/log/php && \
    mkdir -p /run/php &&  \
    chmod 0700 /run/php;

#Cleanup to reduce image size
RUN rm pickle.phar
RUN rm -rf /tmp/*

#Change application directory from /var/www/html to /app
RUN mkdir /app
WORKDIR /app

EXPOSE 80

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/bin/supervisord", "-n"]

RUN touch /tmp/image_version_0.0.8
