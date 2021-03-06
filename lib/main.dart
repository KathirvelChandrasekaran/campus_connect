import 'package:campus_connect/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async => {
      WidgetsFlutterBinding.ensureInitialized(),
      await dotenv.load(fileName: '.env'),
      await Firebase.initializeApp(),
      Supabase.initialize(
        url: dotenv.env["SUPABASE_URL"],
        anonKey: dotenv.env["SUPABASE_ANON_KEY"],
        authCallbackUrlHostname: dotenv.env["SUPABASE_CALLBACK_URL"],
      ),
      runApp(
        const ProviderScope(
          child: CampusConnect(),
        ),
      )
    };
