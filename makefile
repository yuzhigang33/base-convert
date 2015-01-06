TESTS = $(shell find tests -type f -name *test-*)
NPM_INSTALL_TEST = PYTHON=`which python2.6` NODE_ENV=test npm install
NPM_INSTALL_PRODUCTION = PYTHON=`which python2.6` NODE_ENV=production npm install

-TESTS := $(sort $(TESTS))
-JS_TESTS := $(patsubst %.coffee, %.js, $(-TESTS))

-BIN_MOCHA := ./node_modules/.bin/mocha
-BIN_COFFEE := ./node_modules/coffee-script/bin/coffee
-BIN_ISTANBUL := ./node_modules/.bin/istanbul

-COVERAGE_DIR := ./out/test
-COVERAGE_TESTS := $(addprefix $(-COVERAGE_DIR),$(-TESTS))
-COVERAGE_TESTS := $(-COVERAGE_TESTS:.coffee=.js)

default: release
-common-pre: clean -npm-install

test: -common-pre
	@echo $(-TESTS)
	@$(-BIN_MOCHA) \
		--compilers coffee:coffee-script/register \
		--reporter tap \
		$(-TESTS)

-release-pre: clean
	@echo 'release pre'
	@mkdir out out/release
	@cd out/release
	@rsync -av . ./out/release --exclude-from ./.rsyncignore
	@$(NPM_INSTALL_TEST) coffee-script
	@$(-BIN_COFFEE) -cb out/release
	@find ./out/release -name "*.coffee" -exec rm -rf {} \;

release: -release-pre
	@cd out/release && $(NPM_INSTALL_PRODUCTION)
	@echo 'make release done'

-pre-test-cov: -common-pre
	@echo 'copy files'
	@mkdir -p $(-COVERAGE_DIR)

	@rsync -av . $(-COVERAGE_DIR) --exclude-from ./.rsyncignore
	@rsync -av ./node_modules $(-COVERAGE_DIR)
	@rsync -av ./tests $(-COVERAGE_DIR)
	@$(-BIN_COFFEE) -cb out/test
	@find ./out/test -path ./out/test/node_modules -prune -o -name "*.coffee" -exec rm -rf {} \;

test-cov: -pre-test-cov
	@cd $(-COVERAGE_DIR) && \
		$(-BIN_ISTANBUL) cover ./node_modules/.bin/_mocha -- -u bdd -R tap --compilers coffee:coffee-script/register $(patsubst $(-COVERAGE_DIR)%, %, $(-COVERAGE_TESTS)) && \
	  $(-BIN_ISTANBUL) report html

-npm-install:
	@$(NPM_INSTALL_TEST)

clean:
	@echo 'clean'
	@rm -rf out
