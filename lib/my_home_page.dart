import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:logger/logger.dart';

var logger = Logger();

class MyHomePage extends StatefulWidget {
  final SupabaseClient supabase;
  final String title;

  const MyHomePage({Key? key, required this.title, required this.supabase})
      : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> tasks = []; // Initialize an empty list of tasks
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();

    widget.supabase.from('todos').stream(primaryKey: ['id']).listen(
      (List<Map<String, dynamic>> data) {
        setState(() {
          tasks = data.map((e) => e['tasks'] as String).toList();
        });
      },
      onError: (error) {
        logger.e('An error occurred: $error');
      },
    );
  }

  void addTask() {
    FocusScope.of(context).unfocus(); // Close the keyboard

    if (_textController.text.isEmpty) {
      return; // Do nothing if the input text is empty
    }
    widget.supabase.from('todos').insert({'tasks': _textController.text}).then(
      (value) {
        setState(() {
          tasks.add(_textController.text); // Add the task to the list
          _textController.clear(); // Clear the input text
        });
      },
      onError: (error) {
        logger.e('An error occurred: $error');
      },
    );
  }

  void deleteTask(String task) {
    widget.supabase.from('todos').delete().eq('tasks', task).then(
      (value) {
        setState(() {
          tasks.remove(task); // Remove the task from the list
        });
      },
      onError: (error) {
        logger.e('An error occurred: $error');
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
                  return Card(
                    child: ListTile(
                      title: Text(tasks[index]),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          deleteTask(tasks[index]);
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
