import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/expert_provider.dart';
import 'screens/splash_screen.dart';
import 'theme/neo_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const BispiraExpertApp());
}

class BispiraExpertApp extends StatelessWidget {
  const BispiraExpertApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ExpertProvider()),
      ],
      child: MaterialApp(
        title: 'BISPIRA Mitra Ahli & Entertainment',
        debugShowCheckedModeBanner: false,
        theme: NeoTheme.theme,
        home: const SplashScreen(),
      ),
    );
  }
}
