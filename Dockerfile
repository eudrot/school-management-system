FROM php:8.2-cli

# Install tools
RUN apt-get update && apt-get install -y git unzip libsqlite3-dev && docker-php-ext-install pdo_sqlite mbstring

# Copy code
COPY . /app
WORKDIR /app

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer install --no-dev

# Setup Database and Fix Permissions (This is the magic fix!)
RUN touch database/database.sqlite
RUN chmod -R 777 storage bootstrap/cache

# Generate Key and Migrate
RUN php artisan key:generate
RUN php artisan migrate --force

# Start Server
EXPOSE 10000
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=10000"]
