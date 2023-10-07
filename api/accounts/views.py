from django.contrib.auth import get_user_model
from django.contrib.auth.hashers import make_password
from django.shortcuts import render

from rest_framework import status
from rest_framework.response import Response
from rest_framework.generics import CreateAPIView, ListCreateAPIView
from . models import Student, Lecturer
from . serializers import StudentSerializer, LecturerSerializer


default_password = '12345678'
# Create your views here.

class StudentCreateView(CreateAPIView):
    queryset = Student
    serializer_class = StudentSerializer

    def post(self, request):
        student_data = request.data
        student_serializer = StudentSerializer(data=student_data, many=True)
        if student_serializer.is_valid():
            print(f'student: {student_data}')

            for data in student_data:
                print(f"data - {data}")
                # create new user object
                user = get_user_model().objects.create(
                    first_name = data['user']['first_name'],
                    last_name = data['user']['last_name'],
                    username = data['user']['username'],
                    password = make_password(default_password),
                    is_student = True,
                    is_active = True
                )

                Student.objects.create(
                    user = user,
                    department = data['department'],
                    level = data['level']
                )
            return Response(student_serializer.data, status=status.HTTP_201_CREATED)
        else:
            return Response(student_serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class LecturerCreateView(CreateAPIView):
    queryset = Lecturer
    serializer_class = LecturerSerializer

    def post(self, request):
        lecturer_data = request.data
        lecturer_serializer = LecturerSerializer(data=lecturer_data, many=True)
        if lecturer_serializer.is_valid():
            print(f'lecturer: {lecturer_data}')

            for data in lecturer_data:
                print(f"data - {data}")
                # create new user object
                user = get_user_model().objects.create(
                    first_name = data['user']['first_name'],
                    last_name = data['user']['last_name'],
                    username = data['user']['username'],
                    password = make_password(default_password),
                    email = data['user']['email'],
                    is_lecturer = True,
                    is_active = True
                )

                Lecturer.objects.create(
                    user = user,
                    course = data['course']
                )
            return Response(lecturer_serializer.data, status=status.HTTP_201_CREATED)
        else:
            return Response(lecturer_serializer.errors, status=status.HTTP_400_BAD_REQUEST)
