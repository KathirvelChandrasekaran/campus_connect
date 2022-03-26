import 'package:campus_connect/screens/add_details.dart';
import 'package:campus_connect/screens/admin_screen.dart';
import 'package:campus_connect/screens/create_post.dart';
import 'package:campus_connect/screens/home_screen.dart';
import 'package:campus_connect/screens/login_screen.dart';
import 'package:campus_connect/screens/settings_screen.dart';
import 'package:campus_connect/screens/splash_screen.dart';
import 'package:campus_connect/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CampusConnect extends StatelessWidget {
  const CampusConnect({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final theme = ref.watch(themingNotifer);
        return MaterialApp(
          title: 'Material App',
          debugShowCheckedModeBanner: false,
          theme: theme.darkTheme ? darkTheme : lightTheme,
          initialRoute: '/',
          routes: {
            '/': (context) => const SplashScreen(),
            '/login': (context) => const LoginScreen(),
            '/home': (context) => const HomeScreen(),
            '/add_details': (context) => const AddDetailsScreen(),
            '/settings': (context) => const SettingsScreen(),
            '/admin': (context) => const AdminScreen(),
            '/createPost': (context) => const CreatePost(),
          },
        );
      },
    );
  }
}
