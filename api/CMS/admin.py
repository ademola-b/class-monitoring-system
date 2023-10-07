from django.contrib import admin

from . models import *

# Register your models here.
models = [Course, Department, Attendance]

for model in models:
    admin.site.register(model)