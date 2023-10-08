from django.shortcuts import render
from rest_framework.generics import ListAPIView

from . models import Department, Course
from . serializers import DepartmentSerializer, CourseSerializer
# Create your views here.
class DepartmentList(ListAPIView):
    queryset = Department.objects.all()
    serializer_class = DepartmentSerializer

class CourseList(ListAPIView):
    queryset = Course.objects.all()
    serializer_class = CourseSerializer