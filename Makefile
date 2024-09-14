up: docker-up

init: docker-clear update-nginx-in-docker docker-up permissions api-env api-composer api-genrsa api-migration api-fixtures frontend-env websocket-env websocket-key websocket-install websocket-start # frontend-install frontend-build

down:
	docker-compose down --remove-orphans

docker-clear: down
	sudo rm -rf api/var/docker

docker-up:
	docker-compose up --build -d

permissions:
	sudo chmod 777 api/var
	sudo chmod 777 api/var/cache
	sudo chmod 777 api/var/cache/doctrine
	sudo chmod 777 api/var/log
	sudo chmod 777 api/var/mail
	sudo chmod 777 storage/public/video

api-env:
	rm -f api/.env
	ln -s .env.example api/.env

api-composer:
	rm -f api/composer.lock
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

update-nginx-in-docker:
	sed -i 's/^FROM nginx:.*/FROM nginx:1.27/g' api/docker/nginx.docker

pause:
	sleep 5

show-db:
	for i in `docker-compose exec api-postgres psql api api -c "SELECT tablename FROM pg_catalog.pg_tables where schemaname='public';" -t | head -n -1`; do echo "$i" ; docker-compose exec api-postgres psql api api -c "SELECT * FROM $i;"; done

websocket-env:
	rm -f websocket/.env
	ln -s .env.example websocket/.env

websocket-key:
	rm -f ./websocket/public.key
	cp ./api/public.key ./websocket/public.key

websocket-install:
	docker-compose exec websocket-nodejs npm install

websocket-start:
	docker-compose exec websocket-nodejs npm run start