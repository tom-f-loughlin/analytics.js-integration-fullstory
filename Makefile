#
# Binaries.
#

ESLINT = node_modules/.bin/eslint
KARMA = node_modules/.bin/karma

#
# Files.
#

SRCS_DIR = lib
SRCS = $(shell find $(SRCS_DIR) -type f -name "*.js")
TESTS_DIR = test
TESTS = $(shell find $(TESTS_DIR) -type f -name '*.test.js')

#
# Task config.
#
KARMA_FLAGS ?= 
BROWSERS ?= chrome

KARMA_CONF = karma.conf.js

GREP ?= .

#
# Chore tasks.
#

# Install node dependencies.
node_modules: package.json $(wildcard node_modules/*/package.json)
	npm install
	touch $@

# Remove temporary files and build artifacts.
clean:
	rm -rf build.js
.PHONY: clean

# Remove temporary files, build artifacts, and vendor dependencies.
distclean: clean
	rm -rf components node_modules
.PHONY: distclean

#
# Build tasks.
#

# Build shortcut.
.DEFAULT_GOAL = test

#
# Test tasks.
#

# Lint JavaScript source.
lint: node_modules
	$(ESLINT) $(SRCS) $(TESTS)
.PHONY: lint

# Test locally in PhantomJS.
test-phantomjs: node_modules
	$(KARMA) start $(KARMA_FLAGS) --browser PhantomJS $(KARMA_CONF) --single-run
.PHONY: test

# Test locally in the browser.
test-browser: node_modules
	$(KARMA) start $(KARMA_FLAGS) --browser $(BROWSERS) $(KARMA_CONF)
.PHONY: test-browser

# Test shortcut.
test: lint test-phantomjs
.PHONY: test
