FROM php:8.2-fpm

COPY .env /var/www/.env

RUN apt-get update && apt-get install -y  \
    libmagickwand-dev \
    --no-install-recommends \
    && pecl install imagick \
    && docker-php-ext-enable imagick \
    && docker-php-ext-install pdo_mysql

#utile pour les requetes composer distantes
RUN apt-get install -y git zip nano

RUN pecl install xdebug-3.2.2
RUN docker-php-ext-enable xdebug

#Composer option 1 - installera la meme verion que votre version de composer sur
# COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

RUN  echo "    IdentityFile /root/.ssh/id_rsa" >> /etc/ssh/ssh_config

RUN echo 'alias start-agent=eval "($ssh-agent -s)"' >> ~/.bashrc
RUN echo 'alias add-key=ssh-add ~/.ssh/id_rsa' >> ~/.bashrc

#Composer option 2 - Derniere version de composer s'harmonisant avec la version de php - Préférable meme version de composer (option 1)
# https://stackoverflow.com/questions/51324721/how-to-install-specified-version-of-composer (Pour une version spécifique)
# https://packagist.org/packages/composer/composer#2.2.21
RUN php -r "readfile('http://getcomposer.org/installer');" | php -- --install-dir=/usr/bin/ --filename=composer --version=2.5.8

# Rouler cette commande manuellement pour uniformiser les dépendances de composer avec PHP si votre php n'est pas la même version que le projet
# et assurez vous de faire vos commandes avec docker-compose exec app (distantes)
# docker-compose exec app composer update php --with-all-dependencies

# Installer les cles ssh et ajouter a agent
# en ssh sur la machine eval "$(ssh-agent -s)"
# ssh-add ~/.ssh/id_rsa # la cle ~/.ssh/docker_rsa doit etre cree sur votre poste car elle est map avec le BE

#Create
