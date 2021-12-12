"""Test suite for the `example_module` module
"""
from typing import Union

import pytest

import tests.context  # pylint: disable=unused-import
from python_package_template import example_module

Number = Union[int, float]


@pytest.mark.parametrize("number_1, number_2, expected", [(1, 2, 3), (5, 6, 11)])
def should_add_two_numbers(
    number_1: Number, number_2: Number, expected: Number
) -> None:
    """Given two numbers, when we add them together then we should receive the
    expected answer"""

    answer = example_module.add_two_numbers(
        number_1,
        number_2,
    )

    assert (
        answer == expected
    ), f"Expected {number_1} + {number_2} = {expected}, got {answer}"
