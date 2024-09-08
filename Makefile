up: docker-up

init: docker-clear docker-up permissions api-env api-composer api-genrsa api-migration api-fixtures frontend-env # frontend-install frontend-build

down:
	docker-compose down --remove-orphans

docker-clear: down
	sudo rm -rf api/var/docker

docker-up:
	docker-compose up --build -d

permissions:
	sudo chmod 777 api/var
	sudo chmod 777 api/var/cache
	sudo chmod 777 api/var/log
	sudo chmod 777 api/var/mail
	sudo chmod 777 storage/public/video

api-env:
	rm -f api/.env
	ln -s .env.example api/.env

api-composer:
	docker-compose exec api-php-cli composer require 'psr/http-server-handler' 'psr/http-server-middleware' 'lcobucci/jwt:3.3.3'
	docker-compose exec api-php-cli composer install

api-genrsa:
	docker-compose exec api-php-cli openssl genrsa -out private.key 2048
	docker-compose exec api-php-cli openssl rsa -in private.key -pubout -out public.key

api-migration:
	docker-compose exec api-php-cli composer app migrations:migrate --no-interaction

api-fixtures:
	docker-compose exec api-php-cli composer app fixtures:load

frontend-env:
	rm -f frontend/.env.local
	ln -s .env.local.example frontend/.env.local

# frontend-install:
# 	docker-compose exec frontend-nodejs npm install

# frontend-build:
# 	docker-compose exec frontend-nodejs npm run build

show-db:
	for i in `docker-compose exec api-postgres psql api api -c "SELECT tablename FROM pg_catalog.pg_tables where schemaname='public';" -t | head -n -1`; do echo "$i" ; docker-compose exec api-postgres psql api api -c "SELECT * FROM $i;"; done
