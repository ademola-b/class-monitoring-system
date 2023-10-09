from django.urls import path, include

from . views import (StudentCreateView, LecturerCreateView, 
                     StudentQrImageView, StudentDetail)


urlpatterns = [
    path('', include('dj_rest_auth.urls')),
    # path('user/<str:username>/', UserDetail.as_view(), name='user_detail'),
    path('register-student/', StudentCreateView.as_view(), name='student_create'),
    path('register-lecturer/', LecturerCreateView.as_view(), name='lecturer_create'),
    path('save-qr/', StudentQrImageView.as_view(), name="student_qr"),
    path('student-detail/<str:username>/', StudentDetail.as_view(), name="student_detail")
]
