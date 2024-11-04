// lib/main.dart
import 'package:app_school/screens/admin/admin_dashboard.dart';
import 'package:app_school/screens/auth/create_new_password_screen.dart';
import 'package:app_school/screens/auth/forgot_password_screen.dart';
import 'package:app_school/screens/auth/login_screen.dart';
import 'package:app_school/screens/courses/courses_screen.dart';
import 'package:app_school/screens/profile/profile_screen.dart';
import 'package:app_school/screens/ranks/ranks_screen.dart';
import 'package:app_school/screens/student/edit_profile_screen.dart';
import 'package:app_school/screens/student/quiz/student_quiz_screen.dart';
import 'package:app_school/screens/student/student_course_detail_screen.dart';
import 'package:app_school/screens/student/student_courses_screen.dart';
import 'package:app_school/screens/student/student_dashboard.dart';
import 'package:app_school/screens/student/student_profile_screen.dart';
import 'package:app_school/screens/student/student_ranks_screen.dart';
import 'package:app_school/screens/student/student_tp_screen.dart';
import 'package:app_school/screens/student/student_xcode_screen.dart';
import 'package:app_school/screens/xcode/xcode_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'constants/colors.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Forcer l'orientation portrait
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Personnaliser la barre d'état
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TPsc',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primaryBlue,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          color: Colors.transparent,
          iconTheme: IconThemeData(color: AppColors.textDark),
        ),
        // Configuration des boutons par défaut
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryBlue,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        // Configuration du texte par défaut
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: AppColors.textDark),
          bodyMedium: TextStyle(color: AppColors.textDark),
        ),
      ),
      // Routes initiales
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/login': (context) => const LoginScreen(),
        '/forgot-password': (context) => const ForgotPasswordScreen(),
        '/create-password': (context) => const CreateNewPasswordScreen(),

        //Routes admin
        '/admin-dashboard': (context) => const AdminDashboard(),
        '/admin/courses': (context) => const CoursesScreen(),
        '/admin/xcode': (context) => const XCodeScreen(),
        '/admin/ranks': (context) => const RanksScreen(),
        'admin/profile': (context) => const ProfileScreen(),

        // Routes Etudiants
        '/student-dashboard': (context) => const StudentDashboard(),
        '/student/courses': (context) => const StudentCoursesScreen(),
        '/student/xcode': (context) => const StudentXCodeScreen(),
        '/student/ranks': (context) => const StudentRanksScreen(),
        '/student/profile': (context) => const StudentProfileScreen(),
        '/student/edit-profile': (context) => const EditStudentProfileScreen(),
        '/student/course-detail': (context) => StudentCourseDetailScreen(
              courseTitle: ModalRoute.of(context)!.settings.arguments as String,
            ),
        '/student/quiz': (context) {
          final args = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;
          return StudentQuizScreen(
            moduleTitle: args['title']!,
            courseTitle: args['courseTitle']!,
          );
        },
        '/student/tp': (context) {
          final args = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;
          return StudentTPScreen(
            moduleTitle: args['title']!,
            courseTitle: args['courseTitle']!,
          );
        },

        // Routes professeurs
        // Routes parents
      },
      // Gestionnaire de routes pour les routes non définies
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => const SplashScreen(),
        );
      },
    );
  }
}
