from rest_framework import serializers
from accounts.serializers import UserDetailsSerializer
from  accounts.models import User, Student
from . models import Department, Course, Attendance

class DepartmentSerializer(serializers.ModelSerializer):
    class Meta:
        model = Department
        fields = [
            'dept_id',
            'deptName'
        ]

class CourseSerializer(serializers.ModelSerializer):
    class Meta:
        model = Course
        fields = "__all__"

class UserMini(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = [
            "name",
            "username"
        ]

class AttendanceSerializer(serializers.ModelSerializer):    
    class Meta:
        model = Attendance
        fields = [
            "att_id",
            "student",
            "date",
            "course"
        ]

class AttendanceReportSerializer(serializers.ModelSerializer):
    student = UserDetailsSerializer()
    course = CourseSerializer()

    class Meta: 
        model = Attendance
        fields = [
            "date",
            "student",
            "course"
        ]
        
        
       
        
    
        