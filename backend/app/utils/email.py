"""
Useful util to send mail using Flask-Mail.
"""
import re

from bs4 import BeautifulSoup
from flask import current_app, render_template
from flask_mail import Message

from app import celery, mail


def send_mail(subject, recipients, template, sender=None, **ctx):
    """
    Takes the template and renders is using jinja2 syntax. Then sends it using the send_mail_async task.
    """
    if not isinstance(recipients, (tuple, list)):
        recipients = [recipients]

    msg = Message(subject=subject, recipients=recipients, sender=sender)
    msg.html = render_template(template, **ctx)

    if current_app and current_app.config.get("TESTING"):
        return send_mail_async_task.apply([msg])

    return send_mail_async_task.delay(msg)


@celery.task(serializer="pickle")
def send_mail_async_task(msg):
    """
    Sends the message uisng Flask-Mail. If the body isn't provided. It converts the body to a plaintext style.
    :param msg:
    :return:
    """
    if not msg.body:
        plain_text = "\n".join(
            map(str.strip, BeautifulSoup(msg.html, "lxml").text.splitlines())
        )
        msg.body = re.sub(r"\n\n+", "\n\n", plain_text).strip()

    mail.send(msg)
