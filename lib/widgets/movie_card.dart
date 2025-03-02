import 'package:flutter/material.dart';
import '../models/movie_model.dart';

class MovieCard extends StatefulWidget {
  final Movie movie;

  const MovieCard(this.movie, {super.key});

  @override
  MovieCardState createState() => MovieCardState();
}

class MovieCardState extends State<MovieCard> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return FocusableActionDetector(
      onFocusChange: (focused) {
        setState(() {
          _isFocused = focused;
        });
      },
      child: MouseRegion(
        onEnter: (_) => setState(() => _isFocused = true),
        onExit: (_) => setState(() => _isFocused = false),
        child: Container(
          width: 120, // Fixed size
          height: 180, // Fixed size
          margin: EdgeInsets.symmetric(horizontal: 2.5),
          decoration: BoxDecoration(
            border: _isFocused ? Border.all(color: Colors.white, width: 2) : null,
            image: DecorationImage(
              image: NetworkImage(widget.movie.posterUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
