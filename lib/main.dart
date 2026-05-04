import 'package:flutter/material.dart';

import 'domain_tester.dart';

const domains = ['a.com', 'b.com', 'c.com', 'd.com', 'e.com', 'f.com'];

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var results = <Map<String, double>>[];

  Future<void> _test() async {
    var domainTimes = <String, double>{};

    for (var domain in domains) {
      final time = await DomainTester().downloadImg(domain);
      domainTimes[domain] = time;
    }

    DomainTester().set(domainTimes);

    setState(() {
      results = DomainTester().get();
    });
  }

  void _clear() {
    setState(() {
      results.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            for (var item in results)
              Row(
                mainAxisAlignment: .center,
                children: [Text('${item.keys.first}: ${item.values.first}')],
              ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _test,
            tooltip: 'Test',
            child: const Text('Test'),
          ),
          FloatingActionButton(
            onPressed: _clear,
            tooltip: 'Clear',
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }
}
