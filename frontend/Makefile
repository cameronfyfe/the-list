PROFILE ?= debug

PRETTIER_FILES := "**/*.{js,svelte,json}"

.PHONY: default
default: build

###
### Standard Targets For Root Project
###
STD := fmt lint test build clean
.PHONY: ${STD}
$(filter-out clean,${STD}): node_modules

fmt:
	npx prettier --check ${PRETTIER_FILES}

lint: 
	npx eslint .

test:
	echo TODO

build:
	npm run build

clean:
	rm -rf build node_modules

###
### Project Targets
###
.PHONY: refmt
refmt:
	npx prettier --write ${PRETTIER_FILES}

node_modules: package.json
	npm install
	touch $@

.PHONY: start
start: node_modules
	npm run dev
