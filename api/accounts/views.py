from django.contrib.auth import get_user_model
from django.contrib.auth.hashers import make_password
from django.shortcuts import render

from rest_framework import status
from rest_framework.response import Response
from rest_framework.generics import CreateAPIView, ListCreateAPIView, ListAPIView, UpdateAPIView
from rest_framework.views import APIView
from . models import User, Student, Lecturer, Department, Course, StudentQr
from . serializers import (StudentSerializer, LecturerSerializer, 
                           FullUserDetailsSerializer,FullStudentSerializer,
                           StudentQrSerializer, ChangePasswordSerializer)


default_password = '12345678'
# Create your views here.


class UserDetail(APIView):

    def get(self, request):
        try:
            print("hello")
            user = self.request.user
            print(f"{user}")
            student = User.objects.get(user_id = user.user_id)
            serializer = FullUserDetailsSerializer(student)
            return Response(serializer.data)
        except:
            return Response(
                {'error': "User not found"}, status=status.HTTP_404_NOT_FOUND
            )


class StudentCreateView(CreateAPIView):
    queryset = Student
    serializer_class = StudentSerializer

    def post(self, request):
        student_data = request.data
        student_serializer = StudentSerializer(data=student_data)
        if student_serializer.is_valid():
            print(f'student: {student_data}')

            for data in student_data:
                print(f"data - {data}")
                # create new user object
                user = get_user_model().objects.create(
                    name = data['user']['name'],
                    username = data['user']['username'],
                    password = make_password(default_password),
                    is_student = True,
                    is_active = True
                )

                Student.objects.create(
                    user = user,
                    department = Department.objects.get(dept_id = data['department']) ,
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
                    name = data['user']['name'],
                    username = data['user']['username'],
                    password = make_password(default_password),

                    is_lecturer = True,
                    is_active = True
                )

                Lecturer.objects.create(
                    user = user,
                    course = Course.objects.get(course_id = data['course']) 
                )
            return Response(lecturer_serializer.data, status=status.HTTP_201_CREATED)
        else:
            return Response(lecturer_serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class StudentQrImageView(ListCreateAPIView):
    queryset = StudentQr.objects.all()
    serializer_class = StudentQrSerializer

    def get_queryset(self):
        qs = super().get_queryset()
        request = self.request
        user = request.user
        if not user.is_authenticated:
            return StudentQr.objects.none()
        elif user.is_staff:
            return StudentQr.objects.all()
        elif user.is_student:
            return StudentQr.objects.filter(registration_no = user.username)
        else:
            return StudentQr.objects.none()
        

    # def post(self, request):
    #     data = request.data
    #     serializer = StudentQrSerializer(data=data)
    #     if serializer.is_valid():
    #         print(f"data:{data}")
    #         StudentQr.objects.create(
    #             user = get_user_model().objects.get(user_id=data['user']),
    #             qr_image = data['qr_image']
    #         )
    #         return Response(serializer.data, status=status.HTTP_201_CREATED)
    #     else:
    #         return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class StudentDetail(APIView):
    # queryset = Student.objects.all()
    # serializer_class = StudentSerializer

    # def get_queryset(self):
    #     username = self.request.query_params.get("username")
    #     # request = self.request
    #     # if not self.request.user.is_authenticated:
    #     #     return Student.objects.none()
    #     # else:
    #     return Student.objects.filter(user__username = username)
    

    def get(self, request):
        username = request.query_params.get("username")
        try:
            if username is not None:
                student = Student.objects.get(user__username = username)
                serializer = FullStudentSerializer(student)
                return Response(serializer.data)
        except:
            return Response(
                {'error': "Student not found"}, status=status.HTTP_404_NOT_FOUND
            )

        
class LecturerDetailsView(ListAPIView):
    queryset = Lecturer.objects.all()
    serializer_class = LecturerSerializer

    def get_queryset(self):
        user = self.request.user
        if not user.is_authenticated:
            return Lecturer.objects.none()
        elif user.is_staff:
            return Lecturer.objects.all()
        elif user.is_lecturer:
            return Lecturer.objects.filter(user = user)
        else:
            return Course.objects.none()


class ChangePassword(UpdateAPIView):
    queryset = User.objects.all()
    serializer_class = ChangePasswordSerializer


