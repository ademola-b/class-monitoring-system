from rest_framework import serializers
from dj_rest_auth.serializers import UserDetailsSerializer, PasswordChangeSerializer

from . models import Student

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