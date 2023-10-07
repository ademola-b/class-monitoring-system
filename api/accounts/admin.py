from django.contrib import admin
from django.contrib.auth.admin import UserAdmin

from . models import User, Student, Lecturer

# Register your models here.
class UserAdmin(UserAdmin):
    list_display = ('username', 'email', 'is_student', 'is_lecturer', 'is_active')
    search_fields = ('username',)
    ordering = ('username',)
    readonly_fields = ('date_joined', 'last_login',)

    fieldsets = (
        ('User Information', {'fields': ('username', 'password', 'first_name', 'last_name', 'email', 'profile_pic')}),
        ('Permissions', {'fields': (
            'is_student', 'is_lecturer', 'is_staff', 'is_superuser', 'is_active')}),
        ('Important dates', {'fields': ('last_login', 'date_joined')}),
        
    )

    add_fieldsets = (
        ('Login Details', {
            'classes': ('wide',),
            'fields': ('username', 'password1', 'password2'),
        }),
    )

admin.site.register(User, UserAdmin)

models = [Student, Lecturer]
for model in models:
    admin.site.register(model)