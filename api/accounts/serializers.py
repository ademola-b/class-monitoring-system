import base64
from django.core.files.storage import default_storage
from rest_framework import serializers
from dj_rest_auth.serializers import UserDetailsSerializer, PasswordChangeSerializer

from . models import Student, Lecturer, StudentQr, User

class UserDetailsSerializer(UserDetailsSerializer):
    # pic_mem = serializers.SerializerMethodField("get_image_memory")
    class Meta(UserDetailsSerializer.Meta):
        fields = [
            'pk',
            'name',
            'username',
            'email',
            'is_staff',
            'is_student', 
            'is_lecturer',
        ]

    # def get_image_memory(request, user:User):
    #     with default_storage.open(user.profile_pic.name, 'rb') as loadedfile:
    #         return base64.b64encode(loadedfile.read())


class FullUserDetailsSerializer(UserDetailsSerializer):
    pic_mem = serializers.SerializerMethodField("get_image_memory")
    class Meta(UserDetailsSerializer.Meta):
        fields = [
            'pk',
            'name',
            'username',
            'email',
            'profile_pic',
            "pic_mem",
            'is_staff',
            'is_student', 
            'is_lecturer',
        ]

    def get_image_memory(request, user:User):
        with default_storage.open(user.profile_pic.name, 'rb') as loadedfile:
            return base64.b64encode(loadedfile.read())


class StudentSerializer(serializers.ModelSerializer):

    user = UserDetailsSerializer(required=False)
    
    class Meta:
        model = Student
        fields = [
            'student_id',
            'user',
            'department',
            'level'
        ]

class FullStudentSerializer(serializers.ModelSerializer):

    user = FullUserDetailsSerializer(required=False)
    
    class Meta:
        model = Student
        fields = [
            'student_id',
            'user',
            'department',
            'level'
        ]
       
           
class LecturerSerializer(serializers.ModelSerializer):

    user = UserDetailsSerializer(required=False)

    class Meta:
        model = Lecturer
        fields = [
            'lect_id',
            'user',
            'course'
        ]

class StudentQrSerializer(serializers.ModelSerializer):
    qr_mem = serializers.SerializerMethodField("get_image_memory")
    class Meta:
        model = StudentQr
        fields = [
            "qr_id",
            "registration_no",
            "qr_mem",
            "qr_image",
        ]

    def get_image_memory(request, qr:StudentQr):
        with default_storage.open(qr.qr_image.name, 'rb') as loadedfile:
            return base64.b64encode(loadedfile.read())

class ChangePasswordSerializer(PasswordChangeSerializer):
    old_password = serializers.CharField(required=True)