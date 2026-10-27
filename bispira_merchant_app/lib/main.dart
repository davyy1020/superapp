import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/merchant_provider.dart';
import 'theme/neo_theme.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const BispiraMerchantApp());
}

class BispiraMerchantApp extends StatelessWidget {
  const BispiraMerchantApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MerchantProvider()),
      ],
      child: MaterialApp(
        title: 'BISPIRA Merchant Partner',
        debugShowCheckedModeBanner: false,
        theme: NeoTheme.theme,
        home: const SplashScreen(),
      ),
    );
  }
}
