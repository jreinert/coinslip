FLAGS =
ifdef RELEASE
	FLAGS += --release
	YARN_SCRIPT = build
else
	YARN_SCRIPT = dev-build
endif

ifdef STATIC
	FLAGS += --static
endif

BACKEND_SOURCES = $(shell find src -type f) shard.lock
FRONTEND_SOURCES = $(shell find frontend -type f) yarn.lock webpack.config.js

bin/coinslip: $(BACKEND_SOURCES) public/index.html
	shards build $(FLAGS)

public/index.html: $(FRONTEND_SOURCES)
	yarn $(YARN_SCRIPT)

clean:
	- rm bin/coinslip
	- rm -r public/*

.PHONY: clean
