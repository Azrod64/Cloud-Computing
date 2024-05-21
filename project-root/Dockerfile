# Utiliser l'image officielle PHP
FROM php:7.4-apache

# Copier les fichiers backend dans le répertoire de l'application
COPY ./backend /var/www/html

# Installez les dépendances MySQL pour PHP
RUN docker-php-ext-install mysqli