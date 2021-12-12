TASKS = \
	help \
	create-env \
	active-env \
	install-python-deps \
	install \
	test \
	test-coverage \
	lint \
	typecheck \
	format \
	pre-commit-install \
	pre-commit \
	pre-commit-all \
	clean \

# PHONY targets do not depend on an external file
.PHONY = $(TASKS)

# .DEFAULT_GOAL is the target that is executed when 'make' is typed
.DEFAULT_GOAL = help

# Location of application and test code
APPLICATION_DIR = src/python_package_template/
TEST_DIR = tests/

# Name of the virtual environment directory
VIRTUAL_ENV_DIRECTORY = env

# Location of the python executable
PYTHON = $(VIRTUAL_ENV_DIRECTORY)/bin/python3

# https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
	sort | \
	awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

create-env: ## Creates the virtual environment directory
	@python3 -m venv $(VIRTUAL_ENV_DIRECTORY)

activate-env: ## Activates the virtual environment
	@. ./$(VIRTUAL_ENV_DIRECTORY)/bin/activate

install-python-deps: create-env activate-env ## Install the Python dependencies in the virtual environment
	@python3 -m pip install -r requirements.txt -r requirements-dev.txt

# TODO - This is crying out for Docker...
install: install-python-deps pre-commit-install ## Install the code and pre-commit

# Run the test suite with the following options:
#  * -rxXs
#     Provide a detailed summary report.
#     https://docs.pytest.org/en/6.2.x/usage.html#detailed-summary-report
test: activate-env ## Run the full test suite
	@$(PYTHON) -m pytest -rxXs

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
	$(PYTHON) -m pytest -rxXs \
	--cov=$(APPLICATION_DIR) \
	--junitxml=test_summary.xml \
	--cov-report xml:test_coverage.xml && \
	coverage xml -o reports/coverage/test_coverage.xml

lint: ## Run linting tools on the application code
	@$(PYTHON) -m pylint $(APPLICATION_DIR) $(TEST_DIR)

typecheck: ## Run static type checking on the application code
	@$(PYTHON) -m mypy . --strict

format: lint typecheck ## Run linting and type-checking

pre-commit-install: activate-env ## Install pre-commit
	pre-commit install

pre-commit: activate-env ## Run pre-commit on staged files
	@pre-commit run

pre-commit-all: activate-env ## Run pre-commit on all files
	@pre-commit run --all-files

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
	# if [[ reports ]]; then rm -rf reports; fi
