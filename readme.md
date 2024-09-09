## Что это
Повторение курса Дмитрия Елисеева по созданию сайта на docker+nginx+php+doctrine+postresql+kafka+rabbitmq+mailhog

file:Сайт_с_RabbitMQ_17.10.2018_19-25-33
time: 1:44:00

## Работа с PHP backend'ом
Сначала запустить контейнеры:
```
docker-compose up --build -d
```

### установка зависимостей
```
# зависимости, прописанные в lock-файле, сейчас конфликтуют:
rm api/composer.lock

# Этих зависимостей сейчас не хватает:
docker-compose exec api-php-cli composer require 'psr/http-server-handler' 'psr/http-server-middleware' 'lcobucci/jwt:3.3.3'

docker-compose exec api-php-cli composer install
```

### миграция БД
```
docker-compose exec api-php-cli composer app migrations:migrate  --no-interaction
```

### заполнение тестовыми данными
```
docker-compose exec api-php-cli composer app fixtures:load
```

### тестирование
```
docker-compose exec api-php-cli composer test
```

### список пользовательских команд
```
docker-compose exec api-php-cli composer app
```

### Послать сообщение в kafka
```
docker-compose exec api-php-cli composer app kafka:demo:produce
    или
docker-compose exec api-php-cli php bin/app.php kafka:demo:produce

docker-compose exec api-php-cli composer app kafka:demo:consume
    или
docker-compose exec api-php-cli php bin/app.php kafka:demo:consume
```

### посмотреть содержимое БД
```
docker-compose exec api-postgres psql api api -c 'select * from user_users;'

for i in `docker-compose exec api-postgres psql api api -c "SELECT tablename FROM pg_catalog.pg_tables where schemaname='public';" -t | head -n -1`; do echo "$i" ; docker-compose exec api-postgres psql api api -c "SELECT * FROM $i;"; done
```

### Воссоздать private.key/public.key для работы oauth2
```
openssl genrsa -out api/private.key 2048
openssl rsa -in api/private.key -pubout > api/public.key
```
