from datetime import date
from django.shortcuts import get_object_or_404, render
from rest_framework.generics import ListAPIView, ListCreateAPIView
from rest_framework.response import Response
from rest_framework import status

from accounts.models import Student, User
from . models import Department, Course, Attendance
from . serializers import DepartmentSerializer, CourseSerializer, AttendanceSerializer
# Create your views here.
class DepartmentList(ListAPIView):
    queryset = Department.objects.all()
    serializer_class = DepartmentSerializer

class CourseList(ListAPIView):
    queryset = Course.objects.all()
    serializer_class = CourseSerializer

class AttendanceView(ListCreateAPIView):
    queryset = Attendance.objects.all()
    serializer_class = AttendanceSerializer

    def post(self, request):
        data = request.data
    
        try:
            # Get the student based on the username
            student = get_object_or_404(User, user_id=data['student'])
            course = Course.objects.get(course_id = data['course'])

            # Check if the student has already marked attendance for today
            existing_attendance = Attendance.objects.filter(
                date__date=date.today(),
                student=data['student'],
                course = data['course']
            ).first()

            if not existing_attendance:
                # Create a new attendance record if one does not exist
                new_attendance = Attendance.objects.create(
                    student=student,
                    course = course
                )
                serializer = AttendanceSerializer(new_attendance)
                return Response(serializer.data, status=status.HTTP_201_CREATED)
            else:
                # Attendance already marked for today
                return Response(
                    {"detail": "Attendance already marked for today"},
                    status=status.HTTP_400_BAD_REQUEST
                )

        except Student.DoesNotExist:
            return Response(
                {"detail": "Student not found"},
                status=status.HTTP_404_NOT_FOUND
            )




        # data = self.request.data
        # serializer = self.serializer_class(data=data)
        # if serializer.is_valid():
        #     try:
        #         get_att = Attendance.objects.get(date__date = date.today, student__user__username = username)

        #     except Attendance.DoesNotExist:
        #         Attendance.objects.create(
        #             student, course
        #         )