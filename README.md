# python_package_template
[![ChristopherSzczyglowski-python_package_template](https://circleci.com/gh/ChristopherSzczyglowski/python_package_template.svg?style=svg)](https://app.circleci.com/pipelines/github/ChristopherSzczyglowski/python_package_template)
[![codecov](https://codecov.io/gh/ChristopherSzczyglowski/python_package_template/branch/main/graph/badge.svg?token=4MDXVLL47F)](https://codecov.io/gh/ChristopherSzczyglowski/python_package_template)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Code style: black](https://img.shields.io/badge/code%20style-black-000000.svg)](https://github.com/psf/black)

| Parameter    | Value        |
| :---         | :----:       |
| OS           | Linux/WSL 2 |
| Python       | > 3.8        |
| Build system | `setuptools` |

Provides a minimal template for a Python package repository.

## Usage
This repository provides the basic setup to enable a Setup> Test > Build > Document > Deploy workflow.

**Setup**
```python
# Create and activate the environment
python3 -m venv env
source env/bin/activate

# Install dependencies
python3 -m pip install -r requirements.txt
python3 -m pip install -r requirements-dev.txt
```

**Test**
```python
# Make sure we are in the virtual environment
source env/bin/activate

# Run all tests usuing the `pytest` package
python3 -m pytest tests
```

**Build**
```python
# Make sure we are in the virtual environment
source env/bin/activate

# Build using `setuptools`
python3 setup.py sdist bdist_wheel
```

**Document**
```bash
# Make sure we are in the virtual environment
source env/bin/activate

# Auto-document the Python package
#   - Creates the `modules.rst` file in `docs/source`
sphinx-apidoc -f -o docs/source src/python_package_template

# Build the HTML version of the documentation
sphinx-build -b html docs/source docs/build

```

**Deploy**
```bash
# Test jobs locally using the CircleCI CLI
circleci local execute -c .circleci/config.yml --job setup-env
```


## Setup
This package uses `venv` to manage dependencies.

Create a virtual environment called `env`

    python3 -m venv env

Activate the environment

    source env/bin/activate

To install the developer dependencies

    python3 -m pip install -r requirements-dev.txt

To install the package dependencies

    python3 -m pip install -r requirements.txt

### Developer Tools
This repository uses the following developer tools:

* [pre-commit](https://pre-commit.com/): `pre-commit` is provided as a developer dependency. To install pre-commit use `pre-commit install` and then run on all files using `pre-commit run --all-files`
* [CircleCI](https://circleci.com/): Continuous Integration is provided by CircleCI. The [CircleCI CLI](https://circleci.com/docs/2.0/local-cli/) can be used to debug CI jobs locally.
* [pylint](https://pypi.org/project/pylint/): Linting is provided by `pylint`
* [mypy](https://pypi.org/project/mypy/): Static type checking is provided by `mypy`
* [bandit](https://pypi.org/project/bandit/): Code security is provided by `bandit`
* [safety](https://pypi.org/project/safety/): `safety` is used to scan dependencies for vulnerabilities.

An example `settings.json` for VS Code is provided below:
```
{
    "python.pythonPath": "./env/bin/python3.9",
    "editor.formatOnSave": true,
    "python.formatting.provider": "black",
    "python.linting.enabled": true,
    "python.linting.lintOnSave": true,
    "python.linting.pylintEnabled": true,
    "python.linting.pylintArgs": [
        "--enable=E,F,C,R,W"
    ],
    "python.linting.mypyEnabled": true,
    "python.linting.banditEnabled": true,
    "python.testing.pytestEnabled": true,
}
```

## Test
Testing is provided by `pytest` and test files are defined in the `tests` directory.

To run all tests

    python3 -m pytest tests

The pytest setup can be heavily customised. See the [pytest docs](https://docs.pytest.org/en/6.2.x/example/index.html) for more information.

## Build
Packaging is provided by `setuptools`.

To build the source (`.tar.gz`) and distribution (`.whl`) archives

    python3 setup.py sdist bdist_wheel

This will create the source (`.tar.gz`) and distribution (`.whl`) archives in the `dist` directory.

The package can be installed from these archives using
```bash
# Install from the source archive
python3 -m pip install path_to_the_source_archive.tar.gz
```
```bash
# Install from the distribution archive
python3 -m pip install path_to_the_distribution_archive.whl
```

The [setuptools documentation](https://packaging.python.org/guides/distributing-packages-using-setuptools/#packaging-your-project) provides details on the differences between the source and distribution archives.

## Document
Documentation is provided by [Sphinx](https://www.sphinx-doc.org/en/master/usage/quickstart.html).

To create the documentation for the Python package automatically we use the
[sphinx-autodoc](https://www.sphinx-doc.org/en/master/usage/extensions/autodoc.html#module-sphinx.ext.autodoc) extension

    sphinx-apidoc -f -o docs/source src/python_package_template

This allows Sphinx to automatically traverse the contents of the python package
found at `src/python_package_template` and construct the ReStructuredText `.rst` file
from the docstrings.

This repository uses [napoleon extension](https://www.sphinx-doc.org/en/master/usage/extensions/napoleon.html)
to convert docstrings into ReStructuredText format. We have favoured the
[Google Style for writing docstrings](https://google.github.io/styleguide/pyguide.html#38-comments-and-docstrings)
over the `numpy` style but this is purely a matter of personal taste.

The HTML version of the documentation can be built using

    sphinx-build -b html docs/source docs/build

This will create several html files in the `docs/build` directory. To view the
docs in a web browser simply open the `docs/build/index.html` file.

## Deploy
Deployment is a term used loosely to describe the act of hosting the code remotely on
GitHub, running Continuous Integration (CI), monitoring code health and versioning the code.

For more information of CI/CD checkout the [CI/CD Checklist and associated sources](https://github.com/users/ChristopherSzczyglowski/projects/1).
### Continuous Integration
This repository uses CircleCI to provide continuous integration.

The following jobs are defined in the [CircleCI config file](./.circleci/config.yml):

* `setup-env`: Sets up the virtual environment for the CI jobs
* `pre-commit`: Runs pre-commit on all files in the repository
* `linting`: Runs linters on the code files
* `security`: Run DevSecOps tools on the code files and checks dependencies for vulnerabilities.
* `unit-tests`: Run the test framework
* `build-dist`: Builds the distribution files and stores the artifacts
* `build-docs`: Builds the documentation and stores the artifacts

We use the [fan-out/fan-in workflow](https://circleci.com/docs/2.0/workflows/#fan-outfan-in-workflow-example) strategy to maximise concurrency.

![CircleCI workflow diagram for python_package_template repository](https://github.com/ChristopherSzczyglowski/python_package_template/blob/main/docs/source/_static/circleci_workflow_diagram.PNG?raw=true)

The CI jobs `setup-env` and `pre-commit` can be tested locally using the the CircleCI CLI (requires Docker). The other jobs use caching to persist the dependency data between jobs, which is currently unsupported by the CircleCI CLI.

The following resources will assist first time installation for Docker and CircleCI CLI:

* Docker
    * [Install Docker Engine on Ubuntu](https://docs.docker.com/engine/install/ubuntu/)
    * [Docker Desktop WSL 2 backend](https://docs.docker.com/docker-for-windows/wsl/)
* CircleCI CLI
    * [Getting Started with the CircleCI CLI](https://circleci.com/docs/2.0/local-cli-getting-started/)
    * [Using the CircleCI Local CLI](https://circleci.com/docs/2.0/local-cli/)

### Code Metrics
Code health is monitored using [CodeCov](https://about.codecov.io/) and the settings can be found in the [CodeCov configuration file](./codecov.yml).

### Versioning
This repository uses [versioneer](https://github.com/python-versioneer/python-versioneer) for
versioning and adheres to the [Semantic Versioning style](https://semver.org/).

See [setup.cfg](setup.cfg), [setup.py](setup.py) and [versioneer.py](versioneer.py)
for examples of how `versioneer` is incorporated into the Python package.

Specific instructions on how to set up `versioneer` can be found in
[INSTALL.md](https://github.com/python-versioneer/python-versioneer/blob/master/INSTALL.md)
on the versioneer GitHub.

#### Security Warning
Using `versioneer` introduces some low severity security vulnerabilities in the
codebase as reported by `bandit`, namely
[B101](https://bandit.readthedocs.io/en/latest/plugins/b101_assert_used.html),
[B404](https://bandit.readthedocs.io/en/latest/blacklists/blacklist_imports.html#b404-import-subprocess)
and [B603](https://bandit.readthedocs.io/en/latest/plugins/b603_subprocess_without_shell_equals_true.html).

In order for security checks to pass in CI we have explicitly ignored the warnings
from bandit for the files `versioneer.py` and `src/python_package_template/_version.py` using
the `# nosec` annotation. We have also updated the `.bandit` config file to ignore assert statements in these files.

We favour a targetted approach over a blanket skipping of these tests so that we
can still expose security vulnerabilities related to these errors downstream
during development. This decision is effectively a decision to trust the
developers of `versioneer` that they are not acting maliciously. If you disagree
with these changes feel free to revert the changes made in these files.

### GitHub Actions

[TODO - Read up on this for automatic versioning](https://eridem.net/version-bumping-changelog-script-tips-for-your-ci-cd-pipelines)

## License
MIT

## Authors

* Christopher Szczyglowski

Inspired by the [python_pack_and_doc](https://github.com/chryswoods/python_pack_and_doc) repository by @chryswoods.
