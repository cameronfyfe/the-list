PROFILE ?= debug


.PHONY: default
default: build

###
### Standard Targets For Root Project
###
.PHONY: fmt
fmt:
	cargo fmt -- --check

.PHONY: lint
lint:
	cargo clippy -- --deny warnings

.PHONY: test
test:
	cargo test -Z unstable-options --profile=${PROFILE}

.PHONY: build
build:
	cargo build -Z unstable-options --profile=${PROFILE}

.PHONY: clean
clean:
	cargo clean

###
### Project Targets
###
.PHONY: refmt
refmt:
	cargo fmt
