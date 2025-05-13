from django.http import JsonResponse
from .tasks import send_welcome_email

# Create your views here.

def register_user(request):
    if request.method != 'POST':
        return JsonResponse({"error": "Invalid request method. Use POST."}, status=405)
    username = request.POST.get('username', 'Guest')
    send_welcome_email.delay(username)
    return JsonResponse({"message": f"User {username} registered!"})
