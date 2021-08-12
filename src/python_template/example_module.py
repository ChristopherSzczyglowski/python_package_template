"""Example module

This is a module docstring...
"""

from typing import Union


def add_two_numbers(number_1: Union[float, int], number_2: Union[float, int]) -> float:
    """Adds two numbers and returns the answer

    Args:
        number_1: The first number
        number_2: The second number

    Returns:
        The sum of the two numbers
    """

    return number_1 + number_2
