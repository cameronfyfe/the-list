PROFILE ?= debug
TAG_PREFIX ?= dev-

MAKE := $(MAKE) --no-print-directory

MAKE_FLAGS := ./tmp/make-flags
MONGO_DB := ./tmp/mongodb

CONTAINERS := backend frontend mongo
phony-docker-images := $(patsubst %,%-docker, ${CONTAINERS})

.PHONY: default
default: build

.PHONY: all
all: | fmt lint test build ${phony-docker-images}

.PHONY: release
release:
	$(MAKE) all PROFILE=release TAG_PREFIX=

###
### Targets For Building Project Codebases
###
PROJECTS := backend frontend

fmt := $(addsuffix .fmt,${PROJECTS})
lint := $(addsuffix .lint,${PROJECTS})
test := $(addsuffix .test,${PROJECTS})
build := $(addsuffix .build,${PROJECTS})
clean := $(addsuffix .clean,${PROJECTS})

.PHONY: fmt ${fmt} lint ${lint} test ${test} build ${build} clean ${clean}

fmt: ${fmt} root-fmt
lint: ${lint}
test: ${test}
build: ${build}
clean: ${clean} root-clean

${fmt} ${lint} ${test} ${build} ${clean}: PROFILE=${PROFILE}

CD_MAKE = echo ""; cd $* && pwd; echo " =>" && ${MAKE} 
  
${fmt}: %.fmt:
	@${CD_MAKE} fmt
${lint}: %.lint:
	@${CD_MAKE} lint
${test}: %.test:
	@${CD_MAKE} test
${build}: %.build:
	@${CD_MAKE} build
${clean}: %.clean:
	@${CD_MAKE} clean

###
### Targets For Building Docker Containers
###
.PHONY: ${phony-docker-images}
${phony-docker-images}: %: ${MAKE_FLAGS}/%.flag

.PHONY: run
run: ${docker-images}

docker-images := $(patsubst %,${MAKE_FLAGS}/%-docker.flag, ${CONTAINERS})
-include docker.d.mk

${docker-images}: ${MAKE_FLAGS}/%-docker.flag: %/Dockerfile .version | ${MAKE_FLAGS}
	source ./.version && \
	cd $* && \
		docker build \
			--build-arg PROFILE=${PROFILE} \
			--tag the-list/$*:${TAG_PREFIX}$$VERSION \
			--tag the-list/$*:${TAG_PREFIX}latest \
			. && \
	cd - && \
		touch $@

###
### Misc.
###
DIRS := ${MAKE_FLAGS} ${MONGO_DB}

${DIRS}:
	mkdir -p $@

.PHONY: root-fmt
root-fmt:
	for a in $(shell find . -type f -name "*.nix"); do \
		nixfmt --check $$a; \
	done

.PHONY: root-refmt
root-refmt:
	for a in $(shell find . -type f -name "*.nix"); do \
		nixfmt $$a; \
	done

.PHONY: root-clean
root-clean:
	rm -rf ${DIRS}
