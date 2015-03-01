#
# Ethan Mick
# 2015
#

unit:
	./node_modules/mocha/bin/_mocha --compilers coffee:coffee-script/register ./test/unit

integration:
	./node_modules/mocha/bin/_mocha --compilers coffee:coffee-script/register ./test/integration

cov:
	./node_modules/mocha/bin/_mocha --compilers coffee:coffee-script/register --require ./node_modules/blanket-node/bin/index.js -R travis-cov ./test/

report:
	WINSTON=error ./node_modules/mocha/bin/_mocha --compilers coffee:coffee-script/register --require ./node_modules/blanket-node/bin/index.js -R html-cov > coverage.html ./test/unit ./test/integration
	open coverage.html

lint:
	./node_modules/coffeelint/bin/coffeelint ./lib ./server.coffee

check-dependencies:
	./node_modules/david/bin/david.js

all:
	$(MAKE) unit
	$(MAKE) cov
	$(MAKE) lint
	$(MAKE) check-dependencies

.PHONY: all test clean unit integration
