import 'package:flutter/material.dart';
import 'screens/feed_noticias_screen.dart';

void main() {
  runApp(const PortalNoticiasApp());
}

class PortalNoticiasApp extends StatelessWidget {
  const PortalNoticiasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Portal de Notícias',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 1,
        ),
      ),
      home: const FeedNoticiasScreen(),
    );
  }
}
