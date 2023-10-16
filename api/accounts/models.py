import uuid
from django.contrib.auth import get_user_model
from django.contrib.auth.models import AbstractUser, AbstractBaseUser, BaseUserManager
from django.db import models


from CMS.models import Course, Department

level_choices = [
    ('ND I', 'ND I'),
    ('ND II', 'ND II'),
    ('HND I', 'HND I'),
    ('HND II', 'HND II')
]

# Create your models here.
class UserManager(BaseUserManager):
    def create_user(self, username, name, password=None):
        if username is None:
            raise ValueError('Username is required')
        
        if name is None:
            raise ValueError('Name is required')
        
        if password is None:
            raise ValueError('Password is required')
        
        user = self.model(
            username = username,
            name = name.title().strip()
        )

        user.set_password(password)
        user.save(using = self._db)

        return user
    
    def create_superuser(self, username, name, password=None):
        user = self.create_user(
            username = username,
            name = name,
            password = password
        )

        user.is_staff = True
        user.is_superuser = True
        user.is_active = True
        user.save(using = self._db)

        return user

class User(AbstractBaseUser):
    user_id = models.UUIDField(default=uuid.uuid4, primary_key=True, unique=True, editable=False)
    username = models.CharField(max_length=100, db_index=True, unique=True, blank=True, null=True)
    name = models.CharField(max_length=100, db_index=True, blank=True, null=True)
    profile_pic = models.ImageField(upload_to='img/', default="static/default.jpg")
    email = models.CharField(max_length=100, db_index=True, unique=True, verbose_name='email address', null=True, blank=True)
    date_joined = models.DateTimeField(
        verbose_name='date_joined', auto_now_add=True)
    last_login = models.DateTimeField(
        verbose_name='last_login', auto_now=True, null=True)
    is_active = models.BooleanField(default=True)
    is_staff = models.BooleanField(default=False)
    is_superuser = models.BooleanField(default=False)
    is_lecturer = models.BooleanField(default=False)
    is_student = models.BooleanField(default=False)

    USERNAME_FIELD = 'username'
    REQUIRED_FIELDS = ['name']

    objects = UserManager()

    def _str_(self):
        return f'{self.username}'

    def has_perm(self, perm, obj=None):
        return self.is_staff

    def has_module_perms(self, app_label):
        return True

    class Meta:
        db_table = 'User'
        verbose_name_plural = 'Users'


class Student(models.Model):
    student_id = models.UUIDField(default=uuid.uuid4, primary_key=True, unique=True, editable=False)
    user = models.OneToOneField(get_user_model(), null=True, on_delete=models.CASCADE)
    department = models.ForeignKey(Department, on_delete=models.CASCADE, null=True, blank=True)
    level = models.CharField(max_length=7, choices=level_choices, default='100')

    def __str__(self):
        return f"{self.user.username}"

class StudentQr(models.Model):
    qr_id = models.UUIDField(default=uuid.uuid4, unique=True, editable=False, primary_key=True)
    registration_no = models.CharField(max_length=30, null=True)
    qr_image = models.ImageField(upload_to='img/qr_code/')

    def __str__(self):
        return f"{self.registration_no}"

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

