import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'my_home_page.dart';

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
      home: MyHomePage(title: 'リアルタイムTodoアプリ', supabase: supabase),
      debugShowCheckedModeBanner: false,
    );
  }
}
