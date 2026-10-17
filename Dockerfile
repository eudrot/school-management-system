FROM php:8.2-cli

# 1. Install system dependencies (Split into steps to prevent crashes)
RUN apt-get update --fix-missing
RUN apt-get install -y libsqlite3-dev

# 2. Install PHP extensions
RUN docker-php-ext-install pdo_sqlite mbstring

# 3. Copy your code
COPY . /app
WORKDIR /app

# 4. Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer install --no-dev

# 5. Setup Database and Permissions
RUN touch database/database.sqlite
RUN chmod -R 777 storage bootstrap/cache

# 6. Laravel Setup
RUN php artisan key:generate
RUN php artisan migrate --force

# 7. Start Server
EXPOSE 10000
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=10000"]
