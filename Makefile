#
# Ethan Mick
# 2015
#

test:
	./node_modules/mocha/bin/_mocha --compilers coffee:coffee-script/register ./test


cov:
	./node_modules/mocha/bin/_mocha --compilers coffee:coffee-script/register --require ./node_modules/blanket-node/bin/index.js -R travis-cov ./test/

report:
	WINSTON=error ./node_modules/mocha/bin/_mocha --compilers coffee:coffee-script/register --require ./node_modules/blanket-node/bin/index.js -R html-cov > coverage.html ./test/unit ./test/integration
	open coverage.html

lint:
	./node_modules/coffeelint/bin/coffeelint ./lib ./server.coffee

check-dependencies:
	./node_modules/david/bin/david.js

compile:
	./node_modules/coffee-script/bin/coffee --output bin --compile lib/

all:
	$(MAKE) unit
	$(MAKE) cov
	$(MAKE) lint
	$(MAKE) check-dependencies

.PHONY: all test clean unit integration
