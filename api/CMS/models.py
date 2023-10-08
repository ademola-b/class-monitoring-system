import uuid
from django.db import models

# Create your models here.
class Course(models.Model):
    course_id = models.UUIDField(default=uuid.uuid4, primary_key=True, unique=True, editable=False)
    code = models.CharField(max_length=8)
    title = models.CharField(max_length=50)

    def __str__(self):
        return f"{self.code} - {self.title}"
    
class Department(models.Model):
    dept_id = models.UUIDField(default=uuid.uuid4, primary_key=True, unique=True, editable=False)
    deptName = models.CharField(max_length=50, unique=True)
    
    def __str__(self):
        return self.deptName
    
class Attendance(models.Model):
    att_id = models.UUIDField(default=uuid.uuid4, primary_key=True, unique=True, editable=False)
    student = models.ForeignKey("accounts.User", on_delete=models.CASCADE)
    date = models.DateTimeField(auto_now=False, auto_now_add=True)
    course = models.ForeignKey(Course, on_delete=models.CASCADE)
