import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/movie_provider.dart';
import '../widgets/sidebar.dart';
import '../widgets/trailer_player.dart';
import '../widgets/movie_row.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MovieProvider()..fetchTrendingMovies(),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Row(
          children: [
            const SidebarMenu(), // ✅ Sidebar for navigation
            Expanded(
              child: Column(
                children: [
                  const Expanded(flex: 4, child: TrailerPlayer()), // ✅ Video Trailer Section
                  Expanded(
                    flex: 6,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const MovieRow(title: "Trending Now"),
                          const MovieRow(title: "TV Shows"),
                          const MovieRow(title: "Action & Adventure"),
                          const MovieRow(title: "Top Rated"),
                          const MovieRow(title: "Family Movies"),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
