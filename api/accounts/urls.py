from django.urls import path, include

from . views import StudentCreateView, LecturerCreateView


urlpatterns = [
    path('', include('dj_rest_auth.urls')),
    path('register-student/', StudentCreateView.as_view(), name='student_create'),
    path('register-lecturer/', LecturerCreateView.as_view(), name='lecturer_create') 
]
