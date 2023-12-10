import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

final TextEditingController _textController = TextEditingController();

class _MyHomePageState extends State<MyHomePage> {
  List<String> tasks = []; // Initialize an empty list of tasks
  void addTask() {
    if (_textController.text.isEmpty) {
      return; // Do nothing if the input text is empty
    }
    setState(() {
      tasks.add(_textController.text); // Add the input text to the list
      _textController.clear(); // Clear the input field
    });
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
