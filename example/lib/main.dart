import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:weblate_sdk/weblate_sdk.dart';


void main() async {
  await WebLateSdk.initialize(
    accessKey: 'your key',
    host: 'your host',
    projectName: 'project name',
    componentName: 'component name',
    defaultLanguage: 'en',
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      supportedLocales: WebLateSdk.supportedLocales,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        WebLateSdk.delegate,
      ],
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.localizedValueOf('title')),
      ),
      body: Center(
        child: Text(context.localizedValueOf('welcome_message')),
      ),
    );
  }
}
