# Dockerfile
FROM php:7.4-apache

# Copier le code source PHP
COPY ./backend /var/www/html/

# Activer le module rewrite d'Apache
RUN a2enmod rewrite

# Installez les dépendances MySQL pour PHP
RUN docker-php-ext-install mysqli

# Définir le répertoire de travail
WORKDIR /var/www/html



