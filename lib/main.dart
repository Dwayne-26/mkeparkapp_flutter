import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'citysmart/branding_preview.dart';
import 'providers/user_provider.dart';
import 'screens/auth_screen.dart';
import 'screens/history_screen.dart';
import 'screens/landing_screen.dart';
import 'screens/parking_screen.dart';
import 'screens/preferences_screen.dart';
import 'screens/permit_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/street_sweeping_screen.dart';
import 'screens/vehicle_management_screen.dart';
import 'screens/welcome_screen.dart';
import 'services/user_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final repository = await UserRepository.create();
  runApp(MKEParkApp(userRepository: repository));
}

class MKEParkApp extends StatelessWidget {
  const MKEParkApp({super.key, required this.userRepository});

  final UserRepository userRepository;

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF003E29);
    final baseTheme = ThemeData.light();

    return ChangeNotifierProvider(
      create: (_) => UserProvider(userRepository: userRepository)..initialize(),
      child: MaterialApp(
        title: 'MKEPark',
        theme: baseTheme.copyWith(
          colorScheme: baseTheme.colorScheme.copyWith(
            primary: primaryGreen,
            onPrimary: Colors.white,
          ),
          primaryColor: primaryGreen,
          scaffoldBackgroundColor: primaryGreen,
          appBarTheme: const AppBarTheme(
            backgroundColor: primaryGreen,
            foregroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.white),
            systemOverlayStyle: SystemUiOverlayStyle.light,
          ),
          primaryTextTheme: baseTheme.primaryTextTheme.apply(
            bodyColor: Colors.white,
            displayColor: Colors.white,
          ),
          textTheme: baseTheme.textTheme.copyWith(
            bodyMedium: baseTheme.textTheme.bodyMedium?.copyWith(
              color: Colors.white,
            ),
          ),
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => const WelcomeScreen(),
          '/auth': (context) => const AuthScreen(),
          '/landing': (context) => LandingScreen(),
          '/parking': (context) => const ParkingScreen(),
          '/permit': (context) => const PermitScreen(),
          '/sweeping': (context) => const StreetSweepingScreen(),
          '/history': (context) => HistoryScreen(),
          '/branding': (context) => const BrandingPreviewPage(),
          '/profile': (context) => const ProfileScreen(),
          '/vehicles': (context) => const VehicleManagementScreen(),
          '/preferences': (context) => const PreferencesScreen(),
        },
      ),
    );
  }
}
