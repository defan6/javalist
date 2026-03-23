include .env
export

SHELL := /bin/bash

export PROJECT_ROOT := $(CURDIR)
DOCKER_COMPOSE := docker compose -f $(PROJECT_ROOT)/infra/docker-compose.yaml


env-up:
	$(DOCKER_COMPOSE) up -d postgres

env-down:
	$(DOCKER_COMPOSE) down postgres

env-cleanup:
	@read -p "Clean data? [y/N]: " ans; \
	if [ "$$ans" = "y" ]; then \
		$(DOCKER_COMPOSE) down postgres && \
		echo "${PROJECT_ROOT}" && \
		rm -rf ${PROJECT_ROOT}/out/pgdata && \
		echo "Done"; \
	fi;

env-port-forward:
	$(DOCKER_COMPOSE) up -d port-forwarder

env-port-close:
	$(DOCKER_COMPOSE) down port-forwarder

migrate-create:
	$(DOCKER_COMPOSE) run --rm liquibase \
		--changeLogFile=changelog/db.changelog-master.yaml \
		--logLevel=info

migrate-up:
	$(DOCKER_COMPOSE) run --rm liquibase update

migrate-down:
	$(DOCKER_COMPOSE) run --rm liquibase rollbackCount 1

migrate-status:
	$(DOCKER_COMPOSE) run --rm liquibase status --verbose

migrate-history:
	$(DOCKER_COMPOSE) run --rm liquibase history

app-run:
	./gradlew bootRun

app-build:
	./gradlew clean build

app-test:
	./gradlew test

app-clean:
	./gradlew clean