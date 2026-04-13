from django.contrib import admin
from django.urls import path, include
from django.http import JsonResponse

# A simple view to return a success message
def api_root(request):
    return JsonResponse({"status": "success", "message": "Backend API is running perfectly, mate!"})

urlpatterns = [
    path('api/admin/', admin.site.urls),
    path('', include('django_prometheus.urls')),
    path('', api_root, name='api_root'), # This catches the root URL
]