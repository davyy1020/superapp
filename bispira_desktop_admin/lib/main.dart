import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'providers/admin_provider.dart';
import 'theme/neo_brutal_theme.dart';
import 'views/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const BispiraDesktopAdminApp());
}

class BispiraDesktopAdminApp extends StatelessWidget {
  const BispiraDesktopAdminApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AdminProvider(),
      child: Consumer<AdminProvider>(
        builder: (context, provider, _) {
          final isDark = provider.isDarkMode;
          final accentColor = provider.accentColor;

          return MaterialApp(
            title: 'BISPIRA Admin Portal & Suite',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              useMaterial3: true,
              brightness: isDark ? Brightness.dark : Brightness.light,
              textTheme: GoogleFonts.interTextTheme(
                isDark ? ThemeData.dark().textTheme : ThemeData.light().textTheme,
              ),
              scaffoldBackgroundColor: NeoBrutalTheme.getBgDark(isDark),
              primaryColor: accentColor,
              colorScheme: ColorScheme.fromSeed(
                seedColor: accentColor,
                brightness: isDark ? Brightness.dark : Brightness.light,
                surface: NeoBrutalTheme.getBgDark(isDark),
              ),
              splashFactory: InkSparkle.splashFactory,
              pageTransitionsTheme: const PageTransitionsTheme(
                builders: {
                  TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
                  TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
                  TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
                },
              ),
            ),
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
