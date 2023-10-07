from django.shortcuts import render

from rest_framework.generics import CreateAPIView
from . models import Student
from . serializers import StudentSerializer


default_password = '12345678'
# Create your views here.
class StudentCreateView(CreateAPIView):
    queryset = Student
    serializer_class = StudentSerializer