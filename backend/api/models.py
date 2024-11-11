from django.db import models
from django.contrib.auth.models import AbstractUser
from django.utils.translation import gettext_lazy as _

class User(AbstractUser):
    class UserType(models.TextChoices):
        ADMIN = 'admin', _('Admin')
        STUDENT = 'student', _('Student')
        TEACHER = 'teacher', _('Teacher')
        PARENT = 'parent', _('Parent')

    user_type = models.CharField(
        max_length=10,
        choices=UserType.choices,
        default=UserType.STUDENT
    )
    firebase_uid = models.CharField(max_length=128, unique=True, null=True)
    profile_picture = models.URLField(null=True, blank=True)

    def __str__(self):
        return f"{self.get_full_name()} ({self.user_type})"

class Student(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE)
    registration_number = models.CharField(max_length=50, unique=True)
    class_level = models.CharField(max_length=50)
    parent = models.ForeignKey('Parent', on_delete=models.SET_NULL, null=True, related_name='children')

    def __str__(self):
        return f"{self.user.get_full_name()} - {self.registration_number}"

class Teacher(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE)
    specialization = models.CharField(max_length=100)
    courses = models.ManyToManyField('Course', related_name='teachers')

    def __str__(self):
        return self.user.get_full_name()

class Parent(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE)
    phone_number = models.CharField(max_length=20)

    def __str__(self):
        return self.user.get_full_name()

class Course(models.Model):
    name = models.CharField(max_length=255)
    description = models.TextField(blank=True)
    created_by = models.ForeignKey(User, on_delete=models.CASCADE, related_name='courses_created')
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    students = models.ManyToManyField(Student, through='CourseEnrollment', related_name='enrolled_courses')
    is_active = models.BooleanField(default=True)
    firebase_id = models.CharField(max_length=128, unique=True, null=True)

    def __str__(self):
        return self.name

class CourseEnrollment(models.Model):
    student = models.ForeignKey(Student, on_delete=models.CASCADE)
    course = models.ForeignKey(Course, on_delete=models.CASCADE)
    enrolled_date = models.DateTimeField(auto_now_add=True)
    completed = models.BooleanField(default=False)
    completion_date = models.DateTimeField(null=True, blank=True)

    class Meta:
        unique_together = ['student', 'course']

class Module(models.Model):
    course = models.ForeignKey(Course, on_delete=models.CASCADE, related_name='modules')
    name = models.CharField(max_length=255)
    description = models.TextField(blank=True)
    order = models.IntegerField(default=0)
    is_active = models.BooleanField(default=True)
    firebase_id = models.CharField(max_length=128, unique=True, null=True)

    class Meta:
        ordering = ['order']

    def __str__(self):
        return f"{self.course.name} - {self.name}"

class Quiz(models.Model):
    module = models.ForeignKey(Module, on_delete=models.CASCADE, related_name='quizzes')
    title = models.CharField(max_length=255)
    time_limit = models.IntegerField()
    time_unit = models.CharField(max_length=50)
    passing_score = models.IntegerField(default=75)
    is_active = models.BooleanField(default=True)
    created_at = models.DateTimeField(auto_now_add=True)
    firebase_id = models.CharField(max_length=128, unique=True, null=True)

    def __str__(self):
        return f"{self.module.name} - {self.title}"

class Question(models.Model):
    class QuestionType(models.TextChoices):
        TRUE_FALSE = 'trueFalse', _('True/False')
        SINGLE_ANSWER = 'singleAnswer', _('Single Answer')
        SELECTION = 'selection', _('Selection')

    quiz = models.ForeignKey(Quiz, on_delete=models.CASCADE, related_name='questions')
    question_text = models.TextField()
    question_type = models.CharField(max_length=20, choices=QuestionType.choices)
    answer = models.TextField()
    points = models.IntegerField()
    choices = models.JSONField(null=True, blank=True)  # Pour stocker la liste des choix
    firebase_id = models.CharField(max_length=128, unique=True, null=True)

    def __str__(self):
        return f"{self.quiz.title} - {self.question_text[:50]}"

class QuizAttempt(models.Model):
    student = models.ForeignKey(Student, on_delete=models.CASCADE)
    quiz = models.ForeignKey(Quiz, on_delete=models.CASCADE)
    start_time = models.DateTimeField(auto_now_add=True)
    end_time = models.DateTimeField(null=True)
    score = models.IntegerField(null=True)
    is_completed = models.BooleanField(default=False)

    class Meta:
        unique_together = ['student', 'quiz']

class QuestionResponse(models.Model):
    attempt = models.ForeignKey(QuizAttempt, on_delete=models.CASCADE, related_name='responses')
    question = models.ForeignKey(Question, on_delete=models.CASCADE)
    student_answer = models.TextField()
    is_correct = models.BooleanField()
    points_earned = models.IntegerField()

class TP(models.Model):
    module = models.ForeignKey(Module, on_delete=models.CASCADE, related_name='tps')
    title = models.CharField(max_length=255)
    description = models.TextField()
    due_date = models.DateTimeField(null=True, blank=True)
    max_points = models.IntegerField(null=True)
    is_active = models.BooleanField(default=True)
    firebase_id = models.CharField(max_length=128, unique=True, null=True)

    def __str__(self):
        return f"{self.module.name} - {self.title}"

class TPSubmission(models.Model):
    tp = models.ForeignKey(TP, on_delete=models.CASCADE, related_name='submissions')
    student = models.ForeignKey(Student, on_delete=models.CASCADE)
    submitted_files = models.JSONField()  # URLs des fichiers stockés dans Firebase
    comment = models.TextField(blank=True)
    submission_date = models.DateTimeField(auto_now_add=True)
    grade = models.IntegerField(null=True)
    graded_by = models.ForeignKey(Teacher, on_delete=models.SET_NULL, null=True)
    graded_at = models.DateTimeField(null=True)

    class Meta:
        unique_together = ['tp', 'student']