from django.urls import path, include

from . views import DepartmentList, CourseList, AttendanceView, GenerateAttendanceListView
urlpatterns = [
    path('departments/', DepartmentList.as_view(), name="departments"),
    path('courses/', CourseList.as_view(), name="courses"),
    path('mark-attendance/', AttendanceView.as_view(), name="attendance"),
    path('report/', GenerateAttendanceListView.as_view(), name="attendance report"),
]
