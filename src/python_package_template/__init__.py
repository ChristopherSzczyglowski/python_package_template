"""
Top level package for the `python_package_template` package.

`versioneer` has automatically modified this file to initialise the module-level
`__version__` attribute
"""

from . import _version

__version__ = _version.get_versions()["version"]
