import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage>
    with AutomaticKeepAliveClientMixin<HistoryPage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // ✅ important when using keepAlive
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('History Page'),
          Text('Counter: $_counter'),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _incrementCounter,
            child: const Text('Increment History Counter'),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
