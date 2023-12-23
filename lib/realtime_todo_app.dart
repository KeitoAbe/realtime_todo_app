import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:logger/logger.dart';

var logger = Logger();

class RealtimeTodoApp extends StatefulWidget {
  final SupabaseClient supabase;
  final String title;

  const RealtimeTodoApp({Key? key, required this.title, required this.supabase})
      : super(key: key);

  @override
  State<RealtimeTodoApp> createState() => _RealtimeTodoAppState();
}

class _RealtimeTodoAppState extends State<RealtimeTodoApp> {
  List<Map<String, dynamic>> tasks = []; // Initialize an empty list of tasks
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchTasks();
  }

  void fetchTasks() async {
    try {
      widget.supabase.from('todos').stream(primaryKey: ['id']).listen(
        (List<Map<String, dynamic>> data) {
          setState(() {
            tasks =
                data.map((e) => {'id': e['id'], 'task': e['task']}).toList();
          });
        },
      );
    } catch (error) {
      handleError(error);
    }
  }

  Future<void> addTask() async {
    FocusScope.of(context).unfocus(); // Close the keyboard

    if (_textController.text.isEmpty) {
      return; // Do nothing if the input text is empty
    }

    String taskText = _textController.text;
    _textController.clear(); // Clear the input text

    try {
      await widget.supabase.from('todos').insert({'task': taskText}).then((_) {
        fetchTasks();
      });
    } catch (error) {
      handleError(error);
    }
  }

  Future<void> deleteTask(Map<String, dynamic> task) async {
    try {
      await widget.supabase.from('todos').delete().eq('id', task['id']);
    } catch (error) {
      handleError(error);
    }
  }

  void handleError(dynamic error) {
    logger.e('An error occurred: $error');
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('エラー'),
          content: Text(error.toString()),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _textController, // Use the text controller
              decoration: const InputDecoration(
                hintText: 'タスクを入力してください',
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: addTask,
              child: const Text('追加'),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return Card(
                    child: ListTile(
                      title: Text(task['task']),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          deleteTask(task);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
