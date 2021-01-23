FROM php:7.4.14-buster

ENV DEBIAN_FRONTEND=noninteractive


RUN \
sed -i "s@deb.debian.org@mirrors.huaweicloud.com@g" /etc/apt/sources.list && \
sed -i "s@security.debian.org@mirrors.huaweicloud.com@g" /etc/apt/sources.list && \
apt-get clean && \
apt-get update && \
apt-get -y upgrade && \
apt-get install \
locales \
ca-certificates \
curl \
vim \
psmisc \
procps \
iproute2 \
tree \
net-tools \
git \
zip \
unzip \
-yq


RUN \
    curl -fksSL -o /tmp/composer-setup.php https://getcomposer.org/installer && \
    curl -fksSL -o /tmp/composer-setup.sig https://composer.github.io/installer.sig && \
    php -r "if (hash('SHA384', file_get_contents('/tmp/composer-setup.php')) !== trim(file_get_contents('/tmp/composer-setup.sig'))) { unlink('/tmp/composer-setup.php'); echo 'Invalid installer' . PHP_EOL; exit(1); }" && \
    php /tmp/composer-setup.php --no-ansi --install-dir=/usr/local/bin --filename=composer && \
    rm -rf /tmp/composer-setup.php



RUN git clone https://github.com/qwqcode/ArtalkServerPhp.git

WORKDIR ArtalkServerPhp
RUN /usr/local/bin/composer install --ignore-platform-reqs


EXPOSE 23366

VOLUME /ArtalkServerPhp/data


CMD ["php","-S","0.0.0.0:23366","-t","public"]