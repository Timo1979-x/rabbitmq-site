time: 4:48:00

## Работа с PHP backend'ом
Сначала запустить контейнеры:
```
docker-compose up --build -d
```

### установка зависимостей
```
rm api/composer.lock # зависимости, прописанные в lock-файле, сейчас конфликтуют
docker-compose exec api-php-cli composer require 'psr/http-server-handler' # Этой зависимости сейчас не хватает
docker-compose exec api-php-cli composer install
```

### тестирование
```
docker-compose exec api-php-cli composer test
```

### список пользовательских команд
```
docker-compose exec api-php-cli composer app
```

### миграция БД
```
docker-compose exec api-php-cli composer app migrations:migrate
```

### заполнение тестовыми данными
```
docker-compose exec api-php-cli composer app fixtures:load
```