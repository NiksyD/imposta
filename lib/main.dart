import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'models/game_state.dart';
import 'screens/discussion_screen.dart';
import 'screens/elimination_screen.dart';
import 'screens/end_game_screen.dart';
import 'screens/home_screen.dart';
import 'screens/secret_reveal_screen.dart';
import 'screens/setup_screen.dart';
import 'screens/turn_order_screen.dart';
import 'screens/voting_screen.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock to portrait for pass-and-play clarity
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // Transparent status bar for immersive light theme
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: AppTheme.scaffoldBg,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));

  runApp(const ImpostaApp());
}

class ImpostaApp extends StatelessWidget {
  const ImpostaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GameState(),
      child: MaterialApp(
        title: 'Imposta',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        initialRoute: '/',
        routes: {
          '/': (_) => const HomeScreen(),
          '/setup': (_) => const SetupScreen(),
          '/secret-reveal': (_) => const SecretRevealScreen(),
          '/turn-order': (_) => const TurnOrderScreen(),
          '/discussion': (_) => const DiscussionScreen(),
          '/voting': (_) => const VotingScreen(),
          '/elimination': (_) => const EliminationScreen(),
          '/end-game': (_) => const EndGameScreen(),
        },
      ),
    );
  }
}
