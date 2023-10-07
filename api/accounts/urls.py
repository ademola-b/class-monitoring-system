from django.urls import path, include

from . views import StudentCreateView


urlpatterns = [
    path('', include('dj_rest_auth.urls')),
    path('register/', StudentCreateView.as_view(), name='student_create')

    
]
