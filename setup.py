"""Setup script for the python_package_template

Based on the example provided by chryswoods:
    https://github.com/chryswoods/python_pack_and_doc/blob/devel/setup.py
"""

from setuptools import setup

import versioneer

with open("requirements.txt") as fp:
    install_requires = fp.read().strip().split("\n")

with open("requirements-dev.txt") as fp:
    dev_requires = fp.read().strip().split("\n")

setup(
    install_requires=install_requires,
    extras_require={
        "dev": dev_requires,
    },
    entry_points={
        "console_scripts": [
            "entry-point = python_package_template.scripts.main:cli",
        ],
    },
    version=versioneer.get_version(),  # type: ignore
    cmdclass=versioneer.get_cmdclass(),  # type: ignore
)
