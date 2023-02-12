TASKS = \
	help \
	create-env \
	test \
	test-coverage \
	lint \
	typecheck \
	format \
	clean \

# PHONY targets do not depend on an external file
.PHONY = $(TASKS)

# .DEFAULT_GOAL is the target that is executed when 'make' is typed
.DEFAULT_GOAL = help

# Location of application and test code
APPLICATION_DIR = src/python_package_template/
TEST_DIR = tests/

# https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
	sort | \
	awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

# Run the test suite with the following options:
#  * -rxXs
#     Provide a detailed summary report.
#     https://docs.pytest.org/en/6.2.x/usage.html#detailed-summary-report
test: ## Run the full test suite
	@python3 -m pytest -rxXs

# Run the test suite with the following options:
#  * -rxXs
#     Provide a detailed summary report.
#     https://docs.pytest.org/en/6.2.x/usage.html#detailed-summary-report
#
#  * --cov=$(APPLICATION_DIR)
#     Request coverage of the code in the  application directory
#
#  * --junitxml=test_summary.xml
#     Define the file name and format for the coverage report
#
#  * --cov-report xml:test_coverage.xml
#     Requests an XML-formatted coverage report named test_coverage.xml
test-coverage: ## Run the full test suite and generate coverage reports
	@mkdir reports/coverage --parents && \
	python3 -m pytest -rxXs \
	--cov=$(APPLICATION_DIR) \
	--junitxml=test_summary.xml \
	--cov-report xml:test_coverage.xml && \
	coverage xml -o reports/coverage/test_coverage.xml

lint: ## Run linting tools on the application code
	@python3 -m pylint $(APPLICATION_DIR) $(TEST_DIR)

typecheck: ## Run static type checking on the application code
	@python3 -m mypy . --strict

format: lint typecheck ## Run linting and type-checking

# Run `bandit` on the repository
#
# Additional args:
# * -r:
#   Recurse over the directory contents
# * -x:
#   Exclude the `./env` directory
# * -s:
#   Skip the B101 tests (assert_used)
security-application: ## Checks for vulnerabilities in application code
	@bandit -r -x ./env -s B101 .

security-dependency: ## Checks for vulnerabilities in dependencies
	@pip freeze | safety check --stdin --ignore=51457

security: security-application security-dependency ## Runs security tools

build-dist: ## Build the distribution archives
	@python3 -m pip install wheel && \
	python3 setup.py sdist bdist_wheel

# Automatically builds the documentation
#
# Steps:
#   - Build dynamic docmentation from the docstrings in the Python
#     files and modules found in `src/python_package_template`
#   - Build the static documentation files in `docs/source`
#
# Additional args for `sphinx-apidoc`:
#   * -f:
#     Force `apidoc` to overwrite files
#   * -o:
#     The target directory for the auto-generated docs
#
# Additional args for `sphinx-build`
#   * -b:
#     The type of documentation to create
build-docs: ## Build the documentation
	@sphinx-apidoc -f -o docs/source $(APPLICATION_DIR) && \
	sphinx-build -b html docs/source docs/build

# TODO - Something like this would be better
# FILES_TO_CLEAN = (test_summary.xml test_coverage.xml .coverage)
# for file in ${FILES_TO_CLEAN[@]}; do
# 	if [[ -f file ]]; then rm file; fi
# done
clean: ## Remove any artifacts created by the make targets
	@echo "Need to figure out how to get this working!"
	# if [[ -f test_summary.xml ]]; then rm test_summary.xml; fi && \
	# if [[ -f test_coverage.xml ]]; then rm test_coverage.xml; fi && \
	# if [[ -f .coverage ]]; then rm .coverage; fi && \
	# if [[ reports ]]; then rm -rf reports; fi && \
	# if [[ build ]]; then rm -rf build; fi && \
	# if [[ dist ]]; then rm -rf dist; fi && \
	# if [[ docs/build ]]; then rm -rf docs/build; fi
