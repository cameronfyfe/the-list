### Backend
BE_DOCKER := ${MAKE_FLAGS}/backend-docker.flag
BE_CFG := \
	backend/Cargo.toml \
	backend/Cargo.lock
BE_SRC := $(shell find backend/src -type f -print)
BE_BLD := backend/target/${PROFILE}/the-list-backend

${BE_DOCKER}: ${BE_CFG} ${BE_SRC} ${BE_BLD}

${BE_BLD}: backend.build

### Frontend
FE_DOCKER := ${MAKE_FLAGS}/frontend-docker.flag
FE_CFG := \
	frontend/package.json \
	frontend/package-lock.json \
	frontend/rollup.config.js
FE_SRC := $(shell find frontend/src -type f -print)
FE_BLD := \
	frontend/public/build/bundle.css \
	frontend/public/build/bundle.js \
	frontend/public/build/bundle.js.map

${FE_DOCKER}: ${FE_CFG} ${FE_SRC} ${FE_BLD}

${FE_BLD}: frontend.build
