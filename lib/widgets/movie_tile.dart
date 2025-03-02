import 'package:flutter/material.dart';
import '../models/movie_model.dart';

class MovieTile extends StatelessWidget {
  final Movie movie;
  const MovieTile({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Image.network(
          movie.posterUrl,
          width: 120,
          height: 180,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
