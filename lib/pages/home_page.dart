import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  final Function(int) onNavigate; // ✅ callback from MainScreen

  const MyHomePage({super.key, required this.title, required this.onNavigate});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with AutomaticKeepAliveClientMixin<MyHomePage> {
  int _counter = 0;
  late String _title;

  @override
  void initState() {
    super.initState();
    _title = widget.title; // initialize from widget
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
      _title = '${widget.title} ($_counter)'; // update title with counter
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // ✅ important when using keepAlive
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(_title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              'Counter: $_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _incrementCounter,
              child: const Text('Increment History Counter'),
            ),
            ElevatedButton(
              onPressed: () => widget.onNavigate(2),
              child: const Text('Go to History Page'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
