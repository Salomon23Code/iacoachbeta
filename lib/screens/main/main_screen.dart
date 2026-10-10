import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/ai_provider.dart';
import '../../providers/cheicking_provider.dart';
import '../../providers/choach_memory_provider.dart';
import '../../providers/coaching_profile.dart';
import '../../providers/daily_action_provider.dart';
import '../../providers/goal_provider.dart';
import '../../providers/habit_provider.dart';
import '../../providers/meal_provider.dart';
import '../../providers/user_provider.dart';
import '../../providers/weigtn_provider.dart';

import '../../theme/app_theme.dart';
import '../../widgets/animated_chat_badge.dart';
import '../coach/coach_screen.dart';
import '../home/home_screen.dart';
import '../meal/meal_screen.dart';
import '../parcours/parcours_screens.dart';
import '../profile/profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    CoachScreen(),
    MealsScreen(),
    ParcoursScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) unawaited(_loadUserData());
    });
  }

  Future<void> _loadUserData() async {
    final user = context.read<UserProvider>().currentUser;
    if (user == null) return;

    final userId = user.id;
    await Future.wait([
      context.read<WeightProvider>().loadRecords(userId),
      context.read<HabitProvider>().loadHabits(userId),
      context.read<CheckInProvider>().loadCheckIns(userId),
      context.read<GoalProvider>().loadGoal(userId),
      context.read<CoachingProfileProvider>().loadProfile(userId),
      context.read<CoachMemoryProvider>().loadMemory(userId),
      context.read<DailyActionProvider>().loadActions(userId),
      context.read<MealProvider>().loadMeals(userId),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final aiProvider = context.watch<AiProvider>();

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),

      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,

        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },

        backgroundColor: Colors.white,

        indicatorColor: AppTheme.primary.withOpacity(0.12),

        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Accueil',
          ),

          // ==========================================
          // COACH IA
          // ==========================================
          NavigationDestination(
            icon: AnimatedChatBadge(
              show: aiProvider.hasUnreadMessage,
              child: const Icon(Icons.messenger_outline_outlined),
            ),

            selectedIcon: AnimatedChatBadge(
              show: aiProvider.hasUnreadMessage,
              child: const Icon(Icons.messenger),
            ),

            label: 'Coach',
          ),

          const NavigationDestination(
            icon: Icon(Icons.restaurant_outlined),
            selectedIcon: Icon(Icons.restaurant),
            label: 'Repas',
          ),

          const NavigationDestination(
            icon: Icon(Icons.route_outlined),
            selectedIcon: Icon(Icons.route),
            label: 'Parcours',
          ),

          const NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
