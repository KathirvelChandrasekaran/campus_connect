import 'package:campus_connect/screens/login_screen.dart';
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
          },
        );
      },
    );
  }
}
