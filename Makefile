SHELL := /bin/bash

GO ?= go
BIN_DIR ?= bin
LDFLAGS ?= -s -w
CGO_ENABLED ?= 0

IPFS_DAEMON_BIN := xdao-casgrpcd-ipfs
IPFS_DAEMON_PKG := ./cmd/xdao-casgrpcd-ipfs

.PHONY: build
build: build-$(IPFS_DAEMON_BIN)

.PHONY: build-$(IPFS_DAEMON_BIN)
build-$(IPFS_DAEMON_BIN):
	@mkdir -p "$(BIN_DIR)"
	@echo "Building $(IPFS_DAEMON_BIN) -> $(BIN_DIR)/$(IPFS_DAEMON_BIN)"
	@$(if $(GOOS),GOOS=$(GOOS),) $(if $(GOARCH),GOARCH=$(GOARCH),) CGO_ENABLED=$(CGO_ENABLED) \
		$(GO) build -trimpath -ldflags "$(LDFLAGS)" -o "$(BIN_DIR)/$(IPFS_DAEMON_BIN)" "$(IPFS_DAEMON_PKG)"

# Build any cmd under ./cmd/<name>.
# Example: make build-cmd CMD=xdao-casgrpcd-ipfs
.PHONY: build-cmd
build-cmd:
	@[ -n "$(CMD)" ] || (echo "CMD is required (e.g. make build-cmd CMD=$(IPFS_DAEMON_BIN))" && exit 2)
	@mkdir -p "$(BIN_DIR)"
	@echo "Building $(CMD) -> $(BIN_DIR)/$(CMD)"
	@$(if $(GOOS),GOOS=$(GOOS),) $(if $(GOARCH),GOARCH=$(GOARCH),) CGO_ENABLED=$(CGO_ENABLED) \
		$(GO) build -trimpath -ldflags "$(LDFLAGS)" -o "$(BIN_DIR)/$(CMD)" "./cmd/$(CMD)"

.PHONY: clean
clean:
	@rm -rf "$(BIN_DIR)" dist
