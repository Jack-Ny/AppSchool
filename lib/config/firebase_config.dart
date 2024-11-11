import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class FirebaseConfig {
  static Future<void> init() async {
    try {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          // Remplacez ces valeurs par celles de votre projet Firebase
          apiKey: "votre_api_key",
          authDomain: "votre_auth_domain",
          projectId: "votre_project_id",
          storageBucket: "votre_storage_bucket",
          messagingSenderId: "votre_messaging_sender_id",
          appId: "votre_app_id",
        ),
      );
    } catch (e) {
      if (kDebugMode) {
        print('Erreur d\'initialisation Firebase: $e');
      }
    }
  }
}
