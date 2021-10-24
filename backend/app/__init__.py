"""
The initial set and configuration for a flask app. This creates the app via the flask blueprint model to improve
modularity.
"""
import logging
import os

from flask import Flask, render_template
from flask_sqlalchemy import SQLAlchemy
from app.config import config, Config
db = SQLAlchemy()
logger = logging.getLogger(__name__)

from app.models.user import User

def load_initial_users(db):
    images = ["Obama.jpg", "Meng.jpg", "Joe.jpg", "Jennifer.jpg"]
    for image in images:
        user1 = User(photo_name=image, green_badge=False, student_name=image[:-3], email=image[:-3] + "@berkeley.edu", major=image[:-3], student_details="Student loves being " + image[:-3])
        db.session.add(user1)
        db.session.commit()

    user1 = User(photo_name="yousef.jpg", green_badge=True, student_name="yousef", email="yousef@berkeley.edu", major="eecs", student_details="Student loves being " + "yousef")
    db.session.add(user1)
    db.session.commit()

    user2 = User(photo_name="daniel_won.jpg", green_badge=True, student_name="daniel_won", email="daniel_won@berkeley.edu", major="eecs", student_details="Student loves being " + "daniel_won")
    db.session.add(user2)
    db.session.commit()

def create_app(config_name=None, db_ref=None) -> Flask:
    if not config_name:
        config_name = os.getenv("FLASK_ENV", "development")
    app = Flask(__name__)
    app_config = config[config_name]
    app.config.from_object(app_config)
    app.static_folder = config[config_name].STATIC_FOLDER
    if db_ref is None:
        db.init_app(app)
        db.reflect(app=app)
    else:
        db_ref.init_app(app)
        db_ref.reflect(app=app)
    with app.app_context():
        db.create_all()
        if len(User.query.all()) == 0:
            load_initial_users(db)
    configure_blueprints(app, app_config)
    configure_hook(app, config)
    configure_error_handlers(app)

    with app.app_context():
        db.create_all()
    return app


def configure_blueprints(flask_app: Flask, config: Config):
    from app.main import main

    flask_app.register_blueprint(main)


def configure_hook(app, config):
    pass


def configure_error_handlers(app):
    @app.errorhandler(404)
    def page_not_found(error):
        return render_template("errors/404.html"), 404
