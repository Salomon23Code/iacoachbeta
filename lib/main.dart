import 'package:flutter/material.dart';
import 'package:iacoachbeta/providers/ai_provider.dart';
import 'package:iacoachbeta/providers/cheicking_provider.dart';
import 'package:iacoachbeta/providers/choach_memory_provider.dart';
import 'package:iacoachbeta/providers/coaching_profile.dart';
import 'package:iacoachbeta/providers/conversation_provider.dart';
import 'package:iacoachbeta/services/api_service.dart';
import 'package:iacoachbeta/providers/daily_action_provider.dart';
import 'package:iacoachbeta/providers/goal_provider.dart';
import 'package:iacoachbeta/providers/habit_provider.dart';
import 'package:iacoachbeta/providers/meal_provider.dart';
import 'package:iacoachbeta/providers/shopping_provider.dart';
import 'package:iacoachbeta/providers/weigtn_provider.dart';
import 'package:iacoachbeta/screens/splash/splash_screen.dart';
import 'package:provider/provider.dart';

import 'providers/user_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(apiService: ApiService()),
        ),

        ChangeNotifierProvider(
          create: (_) => CoachingProfileProvider(apiService: ApiService()),
        ),

        ChangeNotifierProvider(create: (_) => GoalProvider()),

        ChangeNotifierProvider(
          create: (_) => WeightProvider(apiService: ApiService()),
        ),

        ChangeNotifierProvider(
          create: (_) => HabitProvider(apiService: ApiService()),
        ),

        ChangeNotifierProvider(
          create: (_) => CheckInProvider(apiService: ApiService()),
        ),

        ChangeNotifierProvider(
          create: (_) => CoachMemoryProvider(apiService: ApiService()),
        ),

        ChangeNotifierProvider(
          create: (_) => ConversationProvider(apiService: ApiService()),
        ),

        ChangeNotifierProvider(
          create: (_) => AiProvider(apiService: ApiService()),
        ),
        ChangeNotifierProvider(
          create: (_) => DailyActionProvider(apiService: ApiService()),
        ),

        ChangeNotifierProvider(
          create: (_) => MealProvider(apiService: ApiService()),
        ),

        ChangeNotifierProvider(
          create: (_) => ShoppingProvider(apiService: ApiService()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'AI Coach',

      theme: ThemeData(
        useMaterial3: true,

        scaffoldBackgroundColor: const Color(0xFFF8F8F3),

        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF006B57),
          primary: const Color(0xFF006B57),
        ),

        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
        ),

        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: Color(0xFFE2E8E5)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: Color(0xFF006B57), width: 1.5),
          ),
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF006B57),
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 54),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ),

      home: const SplashScreen(),
    );
  }
}
