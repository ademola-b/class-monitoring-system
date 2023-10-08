from django.urls import path, include

from . views import DepartmentList, CourseList
urlpatterns = [
    path('departments/', DepartmentList.as_view(), name="departments"),
    path('courses/', CourseList.as_view(), name="courses"),
]
