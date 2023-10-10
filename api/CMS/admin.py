from django.contrib import admin

from . models import *

# Register your models here.
models = [Course, Department]

class AttendanceAdmin(admin.ModelAdmin):
    fieldsets = [
        ('Student Info', {'fields': ['student', 'course']}),
        ('Date Info', {'fields': ['date']}),
    ]
    readonly_fields = ('date',)

admin.site.register(Attendance, AttendanceAdmin)

for model in models:
    admin.site.register(model)