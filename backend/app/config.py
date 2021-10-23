"""
The flask env configurations for the entire flask project.
The different configurations are combined into dic with development, production, and testing objects.
"""
# coding=utf-8
import datetime
import os

from dotenv import load_dotenv, find_dotenv

basedir = os.path.abspath(os.path.dirname(os.path.dirname(__file__)))
ENV_FILE = find_dotenv()
if ENV_FILE:
    load_dotenv(ENV_FILE)
LOCAL_ENV_FILE = find_dotenv(".env.local")
if LOCAL_ENV_FILE:
    load_dotenv(LOCAL_ENV_FILE)


class Config(object):
    """
    Initial Configurations for the Flask App
    """

    CSRF_ENABLED = True
    DEBUG = False
    SECRET_KEY = os.environ.get("SECRET_KEY", "TEST_SECRET_KEY")
    expires = datetime.timedelta(days=30)

    SQLALCHEMY_DATABASE_URI = "sqlite:///" + basedir + "/main.db"
    SQLALCHEMY_TRACK_MODIFICATIONS = False

    CELERY_UTC_ENABLE = True

    SQLALCHEMY_POOL_TIMEOUT = None
    STATIC_FOLDER = os.path.join(basedir, "static/public/")
    PRODUCTION = False


class DevelopmentConfig(Config):
    """
    Developmental Configurations
    """

    DEBUG = True
    LOCALE_DEFAULT = "en_US"


class ProductionConfig(Config):
    """
    Production Configurations
    """

    PRODUCTION = True
    DEBUG = False
    LOCALE_DEFAULT = "en_US.utf8"
    JWT_COOKIE_SECURE = True


class TestingConfig(Config):
    """
    Testing Configurations
    """

    TESTING = True
    CSRF_ENABLED = False
    SQLALCHEMY_DATABASE_URI = "sqlite://"


config = {
    "development": DevelopmentConfig,
    "production": ProductionConfig,
    "testing": TestingConfig,
}
