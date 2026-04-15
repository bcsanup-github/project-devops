from django.contrib import admin
from django.urls import path, include
from django.http import JsonResponse

# This matches what your React app is looking for!
def api_status(request):
    return JsonResponse({
        "status": "success", 
        "message": "Backend API is running perfectly, mate!"
    })

urlpatterns = [
    path('admin/', admin.site.urls), # Standard path: http://35.154.88.133:8000/admin/
    path('api/status/', api_status, name='api_status'), 
    path('', include('django_prometheus.urls')),
]