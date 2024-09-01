time: 5:06:00

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
docker-compose exec api-php-cli composer require 'psr/http-server-handler' 'psr/http-server-middleware'

docker-compose exec api-php-cli composer install
```

### миграция БД
```
docker-compose exec api-php-cli composer app migrations:migrate
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
