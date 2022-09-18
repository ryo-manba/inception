COMPOSE_PATH := ./srcs/docker-compose.yml
include ./srcs/.env

.PHONY: all
all: setup
	docker-compose -f $(COMPOSE_PATH) up --build

.PHONY: build
build:
	docker-compose -f $(COMPOSE_PATH) build

.PHONY: up
up:
	docker-compose -f $(COMPOSE_PATH) up

.PHONY: down
down:
	docker-compose -f $(COMPOSE_PATH) down

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
