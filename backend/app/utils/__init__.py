"""
Useful utils for dynamic database processing
"""
from flask_sqlalchemy.model import camel_to_snake_case


def title_case(string):
    return camel_to_snake_case(string).replace("_", " ").title()


def pluralize(name):
    if name.endswith("y"):
        # right replace 'y' with 'ies'
        return "ies".join(name.rsplit("y", 1))
    elif name.endswith("s"):
        return f"{name}es"
    return f"{name}s"
