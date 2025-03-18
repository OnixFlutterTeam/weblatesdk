import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:weblate_sdk/weblate_sdk.dart';
import 'package:weblate_sdk_example/env.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Env.init();

  await WebLateSdk.initialize(
    //your token
    token: Env.token,
    //your host it must start with https://
    host: Env.host,
    //name of project
    projectName: Env.projectName,
    //name of component
    componentName: Env.componentName,
    defaultLanguage: 'en',
    disableCache: false,
    //optional
    cacheLive: const Duration(days: 1),
    //optional
    fallbackJson: 'assets/default.json', //optional
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
  });

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
      home: WebLateSdk.isSDKInitialized
          ? const HomeScreen()
          : const InitializationErrorScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.localizedValueOf('tab_home')),
      ),
      extendBodyBehindAppBar: true,
      body: Center(
        child: Text(
          context.localizedValueOf(
            'test_welcoming',
            format: [
              'John Doe',
            ],
          ),
        ),
      ),
    );
  }
}

class InitializationErrorScreen extends StatelessWidget {
  const InitializationErrorScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Initialization Error'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Center(
          child: Text(
            'Running app first time?\nPlease check your internet connection and try again.',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
