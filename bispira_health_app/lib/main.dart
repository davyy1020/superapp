import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/health_provider.dart';
import 'screens/splash_screen.dart';
import 'theme/neo_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const BispiraHealthApp());
}

class BispiraHealthApp extends StatelessWidget {
  const BispiraHealthApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HealthProvider()),
      ],
      child: MaterialApp(
        title: 'BISPIRA Health & Homecare',
        debugShowCheckedModeBanner: false,
        theme: NeoTheme.theme,
        home: const SplashScreen(),
      ),
    );
  }
}
