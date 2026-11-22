import 'package:flutter/material.dart';
import 'screens/game_screen.dart';
void main() => runApp(const DesertAdventureApp());
class DesertAdventureApp extends StatelessWidget { const DesertAdventureApp({super.key}); @override Widget build(BuildContext context) => MaterialApp(debugShowCheckedModeBanner: false, title: 'مغامرة الصحراء', theme: ThemeData(fontFamily: 'sans', colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xffe5394f), brightness: Brightness.dark), useMaterial3: true), home: const GameScreen()); }
