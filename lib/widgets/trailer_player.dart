import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../providers/movie_provider.dart';
import '../models/movie_model.dart';

class TrailerPlayer extends StatefulWidget {
  const TrailerPlayer({super.key});

  @override
  State<TrailerPlayer> createState() => _TrailerPlayerState();
}

class _TrailerPlayerState extends State<TrailerPlayer> {
  YoutubePlayerController? _controller;

  @override
  void initState() {
    super.initState();
    _initializeTrailer();
  }

  void _initializeTrailer() async {
    final movieProvider = Provider.of<MovieProvider>(context, listen: false);

    if (movieProvider.trendingMovies.isNotEmpty) {
      String movieId = movieProvider.trendingMovies[0].id;
      await movieProvider.fetchMovieTrailer(movieId);
    }

    if (movieProvider.trailerUrl != null) {
      String? videoId = YoutubePlayer.convertUrlToId(movieProvider.trailerUrl!);
      if (videoId != null) {
        setState(() {
          _controller = YoutubePlayerController(
            initialVideoId: videoId,
            flags: const YoutubePlayerFlags(autoPlay: true, mute: false),
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final movieProvider = Provider.of<MovieProvider>(context);
    final Movie featuredMovie = movieProvider.trendingMovies.isNotEmpty
        ? movieProvider.trendingMovies[0]
        : Movie(
      title: "Loading...",
      posterUrl: "",
      id: "",
      description: "",
      backdropPath: "",
      voteAverage: 0.0,
      genreIds: [],
    );

    return Stack(
      alignment: Alignment.bottomLeft,
      children: [
        if (_controller != null)
          YoutubePlayer(controller: _controller!)
        else
          Image.network(
            featuredMovie.backdropPath.isNotEmpty ? featuredMovie.backdropPath : featuredMovie.posterUrl,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [Colors.black.withValues(alpha: .8), Colors.transparent],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                featuredMovie.title,
                style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                featuredMovie.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
