import uuid
from django.contrib.auth import get_user_model
from django.contrib.auth.models import AbstractUser
from django.db import models


from CMS.models import Course, Department


level_choices = [
    ('100', '100'),
    ('200', '200'),
    ('300', '300'),
    ('400', '400')
]

# Create your models here.
class User(AbstractUser):
    user_id = models.UUIDField(
        default=uuid.uuid4, primary_key=True, unique=True, editable=False)
    email = models.CharField(max_length=100, db_index=True,
                             unique=True, verbose_name='email address', blank=True)
    profile_pic = models.ImageField(upload_to='img/')
    is_student = models.BooleanField(default=False, help_text="designates whether the user is a student")
    is_lecturer = models.BooleanField(default=False, help_text="designates whether the user is a lecturer")


class Student(models.Model):
    student_id = models.UUIDField(default=uuid.uuid4, primary_key=True, unique=True, editable=False)
    user = models.OneToOneField(get_user_model(), null=True, on_delete=models.CASCADE)
    department = models.ForeignKey(Department, on_delete=models.CASCADE)
    level = models.CharField(max_length=5, choices=level_choices, default='100')

    def __str__(self):
        return f"{self.user.username}"

class Lecturer(models.Model):
    lect_id = models.UUIDField(default=uuid.uuid4, primary_key=True, unique=True, editable=False)
    user = models.OneToOneField(User, on_delete=models.CASCADE, blank=True, null=True)
    course = models.ForeignKey(Course, null=True, on_delete=models.CASCADE)

    def __str__(self):
        return f"{self.user.username} - {self.course.code}"

from django.contrib.auth import get_user_model
from django.contrib.auth.backends import ModelBackend

class EmailBackend(ModelBackend):
    def authenticate(self, request, username=None, password=None, **kwargs):
        UserModel = get_user_model()
        try:
            user = UserModel.objects.get(username=username)
        except UserModel.DoesNotExist:
            try:
                user = UserModel.objects.get(email=username)
            except UserModel.DoesNotExist:
                # Run the default password hasher once to reduce the timing
                # difference between an existing and a nonexistent user (#20760).
                UserModel().set_password(password)
            else:
                if user.check_password(password) and self.user_can_authenticate(user):
                    return user
        else:
            if user.check_password(password) and self.user_can_authenticate(user):
                return user

