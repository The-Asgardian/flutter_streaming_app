import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/search_screen.dart';
import 'screens/sports_screen.dart';
import 'screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // Ensures platform-specific services are ready
  debugDefaultTargetPlatformOverride = TargetPlatform.android;
  runApp(StreamXApp());
}

class StreamXApp extends StatelessWidget {
  const StreamXApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(), // Start with Splash Screen
    );
  }
}

class TVNavigation extends StatelessWidget {
  const TVNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(child: HomeScreen()),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  child: Text("Movies"),
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => HomeScreen())),
                ),
                ElevatedButton(
                  child: Text("Search"),
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SearchScreen())),
                ),
                ElevatedButton(
                  child: Text("Sports"),
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SportsScreen())),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
