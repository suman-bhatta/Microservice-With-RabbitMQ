from celery import shared_task

@shared_task
def send_welcome_email(username):
    print(f"[x] Sending welcome email to {username}")
