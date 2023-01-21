##@ General

.PHONY: help
help: ## Display this help.
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_0-9-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

##@ Tools

BIN_DIR ?= bin
HUGO := $(BIN_DIR)/hugo
HUGO_VERSION ?= 0.110.0

tool_version_file = $(BIN_DIR)/.version_$(subst $(BIN_DIR)/,,$(1))_$(2)

$(BIN_DIR)/.version_%:
	@version_file=$@; rm -f $${version_file%_*}*
	@touch $@

.PHONY: clean-bin
clean-bin: ## Clean all tool binaries.
	rm -rf $(BIN_DIR)/*

HUGO_ARCHIVE := https://github.com/gohugoio/hugo/releases/download/v$(HUGO_VERSION)/hugo_extended_$(HUGO_VERSION)_$(shell uname -s | tr '[:upper:]' '[:lower:]')-$(shell uname -m | sed 's/x86_64/amd64/;s/aarch64/arm64/').tar.gz
ifeq ($(shell uname -s),Darwin)
	HUGO_ARCHIVE := https://github.com/gohugoio/hugo/releases/download/v$(HUGO_VERSION)/hugo_extended_$(HUGO_VERSION)_darwin-universal.tar.gz
endif

$(HUGO): $(call tool_version_file,$(HUGO),$(HUGO_VERSION)) ## Install the hugo tool.
	curl -Lo - "$(HUGO_ARCHIVE)" | tar xzmf - -C bin hugo
