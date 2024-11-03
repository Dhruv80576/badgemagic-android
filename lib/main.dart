import 'package:badgemagic/providers/app_localisation.dart';
import 'package:badgemagic/providers/getitlocator.dart';
import 'package:badgemagic/providers/imageprovider.dart';
import 'package:badgemagic/providers/locale_provider.dart';
import 'package:badgemagic/view/about_us_screen.dart';
import 'package:badgemagic/view/draw_badge_screen.dart';
import 'package:badgemagic/view/homescreen.dart';
import 'package:badgemagic/view/save_badge_screen.dart';
import 'package:badgemagic/view/saved_clipart.dart';
import 'package:badgemagic/view/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

void main() {
  setupLocator();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<InlineImageProvider>(
          create: (context) => getIt<InlineImageProvider>()),
      ChangeNotifierProvider(create: (_) => LocaleProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      builder: (context, child) {
        return MaterialApp(
          supportedLocales: const [Locale('en'), Locale('zh')],
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          locale: Provider.of<LocaleProvider>(context).locale,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorSchemeSeed: Colors.white,
            useMaterial3: true,
          ),
          initialRoute: '/',
          routes: {
            '/': (context) => const HomeScreen(),
            '/drawBadge': (context) => const DrawBadge(),
            '/savedBadge': (context) => const SaveBadgeScreen(),
            '/savedClipart': (context) => const SavedClipart(),
            '/aboutUs': (context) => const AboutUsScreen(),
            '/settings': (context) => const SettingsScreen(),
          },
        );
      },
    );
  }
}
