FROM php:8.2-cli
RUN apt-get update && apt-get install -y git unzip libsqlite3-dev && docker-php-ext-install pdo_sqlite mbstring
COPY . /app
WORKDIR /app
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer install --no-dev
RUN touch database/database.sqlite
RUN php artisan key:generate
RUN php artisan migrate --force
EXPOSE 1000
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=1000"]
