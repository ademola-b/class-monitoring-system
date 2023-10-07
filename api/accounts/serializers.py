from rest_framework import serializers
from dj_rest_auth.serializers import UserDetailsSerializer, PasswordChangeSerializer

from . models import Student, Lecturer

class UserDetailsSerializer(UserDetailsSerializer):
    class Meta(UserDetailsSerializer.Meta):
        fields = [
            'pk',
            'first_name',
            'last_name',
            'username',
            'email',
            'is_staff',
            'is_student', 
            'is_lecturer',
        ]

class StudentSerializer(serializers.ModelSerializer):

    user = UserDetailsSerializer()
    
    class Meta:
        model = Student
        fields = [
            'student_id',
            'user',
            'department',
            'level'
        ]

class LecturerSerializer(serializers.ModelSerializer):

    user = UserDetailsSerializer()

    class Meta:
        model = Lecturer
        fields = [
            'lect_id',
            'user',
            'course'
        ]