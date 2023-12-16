import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'realtime_todo_app.dart';

class MyApp extends StatelessWidget {
  final SupabaseClient supabase;
  const MyApp({Key? key, required this.supabase}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'リアルタイムTodoアプリ',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RealtimeTodoApp(title: 'リアルタイムTodoアプリ', supabase: supabase),
      debugShowCheckedModeBanner: false,
    );
  }
}
