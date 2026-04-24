FROM php:8.2-cli

RUN apt update && apt install -y git unzip curl libzip-dev zip npm
RUN docker-php-ext-install pdo pdo_mysql zip

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /app

COPY . .

RUN composer install
RUN npm install && npm run build || true

RUN cp .env.example .env || true
RUN php artisan key:generate || true

EXPOSE 8090

CMD php artisan serve --host=0.0.0.0 --port=8090
