from django.http import JsonResponse
from .tasks import send_welcome_email

# Create your views here.

def register_user(request):
    username = request.GET.get('username', 'Guest')
    send_welcome_email.delay(username)
    return JsonResponse({"message": f"User {username} registered!"})
