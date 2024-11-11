from rest_framework import serializers
from .models import Course, Module, Quiz, Question

class QuestionSerializer(serializers.ModelSerializer):
    class Meta:
        model = Question
        fields = ['id', 'firebase_id', 'question_text', 'question_type', 'answer', 'points', 'choices']

class QuizSerializer(serializers.ModelSerializer):
    questions = QuestionSerializer(many=True, read_only=True)
    
    class Meta:
        model = Quiz
        fields = ['id', 'firebase_id', 'title', 'time_limit', 'time_unit', 'passing_score', 'questions']

class ModuleSerializer(serializers.ModelSerializer):
    quizzes = QuizSerializer(many=True, read_only=True)
    
    class Meta:
        model = Module
        fields = ['id', 'firebase_id', 'name', 'quizzes']

class CourseSerializer(serializers.ModelSerializer):
    modules = ModuleSerializer(many=True, read_only=True)
    
    class Meta:
        model = Course
        fields = ['id', 'firebase_id', 'name', 'modules', 'created_at', 'updated_at']