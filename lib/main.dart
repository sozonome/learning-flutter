import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nathan',
      home: DemoPage(),
    );
  }
}

class DemoPage extends StatelessWidget {
  launchURL() {
    launch('https://sznm.dev');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(onPressed: launchURL, child: Text('Hello')),
      ),
    );
  }
}
