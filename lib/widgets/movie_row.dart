import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/movie_provider.dart';
import '../widgets/movie_tile.dart';

class MovieRow extends StatelessWidget {
  final String title;
  const MovieRow({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final movieProvider = Provider.of<MovieProvider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: movieProvider.trendingMovies.length,
            itemBuilder: (context, index) {
              return MovieTile(movie: movieProvider.trendingMovies[index]);
            },
          ),
        ),
      ],
    );
  }
}
