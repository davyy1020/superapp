import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/driver_provider.dart';
import 'theme/neo_theme.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const BispiraDriverApp());
}

class BispiraDriverApp extends StatelessWidget {
  const BispiraDriverApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DriverProvider()),
      ],
      child: MaterialApp(
        title: 'BISPIRA Driver Partner',
        debugShowCheckedModeBanner: false,
        theme: NeoTheme.theme,
        home: const SplashScreen(),
      ),
    );
  }
}
