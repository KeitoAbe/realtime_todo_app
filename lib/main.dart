import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'my_app.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: '.env');
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
      url: dotenv.get('SUPABASE_URL'), anonKey: dotenv.get('SUPABASE_KEY'));
  final supabase = Supabase.instance.client;
  runApp(MyApp(supabase: supabase));
}
