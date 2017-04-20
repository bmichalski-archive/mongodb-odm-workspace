FROM debian:8.6

RUN \
  apt-get update && \
  apt-get dist-upgrade -y && \
  apt-get install -y \
    php5-cli \
    php5-dev \
    php5-xdebug \
    wget \
    git \
    curl \
    vim \
    openssh-server \
    sudo \
    adduser \
    php-pear \
    make \
    pkg-config \
    libssl-dev \
    rsyslog

RUN \
  pecl install mongo-1.6.14

#Improve composer performances
RUN php5dismod xdebug

RUN \
  curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin && \
  mv /usr/bin/composer.phar /usr/bin/composer && \
  chmod u+x /usr/bin/composer

RUN \
  adduser --disabled-login --uid 1042 --gecos 'r' r && \
  usermod -a -G sudo r && \
  echo "r ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

CMD \
  touch /var/log/syslog && \
  service ssh start && \
  service rsyslog start && \
  tail -f /var/log/syslog
