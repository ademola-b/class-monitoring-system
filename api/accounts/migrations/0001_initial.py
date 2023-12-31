# Generated by Django 4.2.6 on 2023-10-08 22:06

from django.conf import settings
from django.db import migrations, models
import django.db.models.deletion
import uuid


class Migration(migrations.Migration):

    initial = True

    dependencies = [
        ('CMS', '0001_initial'),
    ]

    operations = [
        migrations.CreateModel(
            name='User',
            fields=[
                ('password', models.CharField(max_length=128, verbose_name='password')),
                ('user_id', models.UUIDField(default=uuid.uuid4, editable=False, primary_key=True, serialize=False, unique=True)),
                ('username', models.CharField(blank=True, db_index=True, max_length=100, null=True, unique=True)),
                ('name', models.CharField(blank=True, db_index=True, max_length=100, null=True)),
                ('profile_pic', models.ImageField(upload_to='img/')),
                ('email', models.CharField(blank=True, db_index=True, max_length=100, null=True, unique=True, verbose_name='email address')),
                ('date_joined', models.DateTimeField(auto_now_add=True, verbose_name='date_joined')),
                ('last_login', models.DateTimeField(auto_now=True, null=True, verbose_name='last_login')),
                ('is_active', models.BooleanField(default=True)),
                ('is_staff', models.BooleanField(default=False)),
                ('is_superuser', models.BooleanField(default=False)),
                ('is_lecturer', models.BooleanField(default=False)),
                ('is_student', models.BooleanField(default=False)),
            ],
            options={
                'verbose_name_plural': 'Users',
                'db_table': 'User',
            },
        ),
        migrations.CreateModel(
            name='Student',
            fields=[
                ('student_id', models.UUIDField(default=uuid.uuid4, editable=False, primary_key=True, serialize=False, unique=True)),
                ('level', models.CharField(choices=[('ND I', 'ND I'), ('ND II', 'ND II'), ('HND I', 'HND I'), ('HND II', 'HND II')], default='100', max_length=7)),
                ('department', models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.CASCADE, to='CMS.department')),
                ('user', models.OneToOneField(null=True, on_delete=django.db.models.deletion.CASCADE, to=settings.AUTH_USER_MODEL)),
            ],
        ),
        migrations.CreateModel(
            name='Lecturer',
            fields=[
                ('lect_id', models.UUIDField(default=uuid.uuid4, editable=False, primary_key=True, serialize=False, unique=True)),
                ('course', models.ForeignKey(null=True, on_delete=django.db.models.deletion.CASCADE, to='CMS.course')),
                ('user', models.OneToOneField(blank=True, null=True, on_delete=django.db.models.deletion.CASCADE, to=settings.AUTH_USER_MODEL)),
            ],
        ),
    ]
