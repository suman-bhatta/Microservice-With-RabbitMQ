import logging
from celery import shared_task

logger = logging.getLogger(__name__)

@shared_task
def send_welcome_email(username):
    logger.info(f"[x] Sending welcome email to {username}")
