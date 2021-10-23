"""
User based models such as Users, Friends, Followers, UserRole.
"""
# coding=utf-8
import string
import re

from app import db


class User(db.Model):
    __table_args__ = {"extend_existing": True}
    id = db.Column(db.Integer, primary_key=True, unique=True)
    photo_group = db.Column(db.String, primary_key=True, unique=True)
