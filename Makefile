COMPOSE_PATH := ./srcs/docker-compose.yml
SRCDIR := ./srcs
include ./srcs/.env

.PHONY: all
all: setup
	cd $(SRCDIR) && docker-compose up --build

.PHONY: build
build:
	cd $(SRCDIR) && docker-compose build

.PHONY: up
up:
	cd $(SRCDIR) && docker-compose up

.PHONY: down
down:
	cd $(SRCDIR) && docker-compose down

.PHONY: wordpress
	cd $(SRCDIR) && docker-compose exec wordpress bash

.PHONY: nginx
	cd $(SRCDIR) && docker-compose exec nginx bash

.PHONY: mariadb
	cd $(SRCDIR) && docker-compose exec mariadb bash

.PHONY: clean
clean: down

.PHONY: fclean
fclean: clean dclean
	sudo sed -i -e "/127\.0\.0\.1	${DOMAIN_NAME}/d" /etc/hosts
	sudo rm -rf ${VOLUME_DIR}

.PHONY: re
re: clean all

.PHONY: dclean
dclean:
	@echo "[INFO] all delete docker container"
	docker stop $(shell docker ps -qa) 2>/dev/null              || :
	docker rm $(shell docker ps -qa) 2>/dev/null                || :
	docker rmi -f $(shell docker images -qa) 2>/dev/null        || :
	docker volume rm $(shell docker volume ls -q) 2>/dev/null   || :
	docker network rm $(shell docker network ls -q) 2>/dev/null || :

.PHONY: setup
setup: setup_hosts setup_volume

.PHONY: setup_volume
setup_volume:
	@echo "[INFO] setup volumes"
	@if [ ! -d ${VOLUME_DIR}/mariadb ] ; then \
		echo "[INFO] create ${VOLUME_DIR}/mariadb"; \
		sudo mkdir -p ${VOLUME_DIR}/mariadb ; \
	fi
	@if [ ! -d ${VOLUME_DIR}/wordpress ] ; then \
		echo "[INFO] create ${VOLUME_DIR}/wordpress"; \
		sudo mkdir -p ${VOLUME_DIR}/wordpress ; \
	fi

.PHONY: setup_hosts
setup_hosts:
	@echo "[INFO] setup hosts"
	@if ! grep -E "^127\.0\.0\.1\s+rmatsuka\.42\.fr" /etc/hosts > /dev/null ; then \
		sudo sh -c 'echo "127.0.0.1\trmatsuka.42.fr" >> /etc/hosts'; \
	fi
