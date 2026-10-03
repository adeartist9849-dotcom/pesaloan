import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pesaloan/src/app.dart';
import 'package:pesaloan/src/core/constants/app_constants.dart';
import 'package:pesaloan/src/core/network/dio_client.dart';
import 'package:pesaloan/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load environment variables
  await dotenv.load(fileName: '.env');
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Initialize Dio client with base URL
  DioClient.initialize(baseUrl: dotenv.env['API_BASE_URL'] ?? AppConstants.defaultApiBaseUrl);
  
  runApp(
    const ProviderScope(
      child: PesaLoanApp(),
    ),
  );
}