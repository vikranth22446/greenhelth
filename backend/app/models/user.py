"""
User based models such as Users, Friends, Followers, UserRole.
"""
# coding=utf-8
import string
import re

from app import db
import datetime

class User(db.Model):
    __table_args__ = {"extend_existing": True}
    student_id = db.Column(db.Integer, primary_key=True, unique=True)
    photo_name = db.Column(db.String)
    green_badge = db.Column(db.Boolean)
    student_name = db.Column(db.String)
    email = db.Column(db.String)
    major = db.Column(db.String)
    student_details = db.Column(db.String)
    vaccinated = db.Column(db.DateTime, default=datetime.datetime.utcnow)

class History(db.Model):
    history_id = db.Column(db.Integer, primary_key=True, unique=True)
    student_id = db.Column(db.Integer)
    detected_time = db.Column(db.DateTime, default=datetime.datetime.utcnow)
    status = db.Column(db.String)
    