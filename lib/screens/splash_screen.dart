import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
//import 'dart:async';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _videoController;

  @override
  void initState() {
    super.initState();

    // Initialize the video player with the asset video
    _videoController = VideoPlayerController.asset("assets/videos/Intro.mp4")
      ..initialize().then((_) {
        // Hide buffering indicator and start playing as soon as it's loaded
        setState(() {});
        _videoController.play();
      });

    // Listen for video completion
    _videoController.addListener(() {
      if (_videoController.value.position >= _videoController.value.duration) {
        _navigateToHome();
      }
    });
  }

  void _navigateToHome() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => HomeScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Ensure black background
      body: _videoController.value.isInitialized
          ? SizedBox.expand(
        child: FittedBox(
          fit: BoxFit.cover, // Ensures full-screen playback
          child: SizedBox(
            width: _videoController.value.size.width,
            height: _videoController.value.size.height,
            child: VideoPlayer(_videoController),
          ),
        ),
      )
          : Container(), // No loading indicator, just a black screen
    );
  }
}
