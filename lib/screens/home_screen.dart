// ignore_for_file: use_key_in_widget_constructors, avoid_print
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../models/movie_model.dart' as model;
import 'package:flutter_streaming_app/services/movie_service.dart';
import '../widgets/movie_card.dart';

class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final MovieService movieService = MovieService();
  YoutubePlayerController? _youtubeController;
  model.Movie? _focusedMovie;
  int _selectedRowIndex = 0;
  int _selectedMovieIndex = 0;
  List<List<model.Movie>> _movieRows = [];

  @override
  void initState() {
    super.initState();
    _loadFeaturedMovie();
    _setupKeyboardListener();
  }

  void _loadMovies() async {
    List<model.Movie> trending = await movieService.fetchTrendingMovies();
    List<model.Movie> topRated = await movieService.fetchTopRatedMovies();
    List<model.Movie> action = await movieService.fetchMoviesByGenre("28");
    List<model.Movie> comedy = await movieService.fetchMoviesByGenre("35");
    List<model.Movie> horror = await movieService.fetchMoviesByGenre("27");
    List<model.Movie> tvShows = await movieService.fetchTrendingTVShows();

    setState(() {
      _movieRows = [trending, topRated, action, comedy, horror, tvShows];
    });
  }

  void _loadFeaturedMovie() async {
    List<model.Movie> movies = await movieService.fetchTrendingMovies();
    if (movies.isNotEmpty) {
      setState(() {
        _focusedMovie = movies[0];
        _updateTrailer(_focusedMovie!);
      });
    }
  }

  void _updateTrailer(model.Movie movie) async {
    print("Fetching movie details for: ${movie.title}");

    String? trailerUrl = await movieService.fetchMovieTrailerUrl(movie.id);
    print("Fetched trailer URL: $trailerUrl");

    if (trailerUrl == null || trailerUrl.isEmpty) {
      print("No trailer URL found for ${movie.title}");
      return;
    }

    final videoId = YoutubePlayer.convertUrlToId(trailerUrl);
    if (videoId == null) {
      print("Invalid YouTube URL");
      return;
    }

    print("Extracted YouTube Video ID: $videoId");

    // Dispose old controller before creating a new one
    _youtubeController?.dispose();

    // Initialize new YouTube Player controller
    _youtubeController = YoutubePlayerController(
      initialVideoId: videoId,
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        loop: false,
        forceHD: false,
        disableDragSeek: true,
        enableCaption: false,
        controlsVisibleAtStart: false,
        useHybridComposition: false,
        showLiveFullscreenButton: false,
        hideThumbnail: true,
        hideControls: true,

      ),
    );

    setState(() {});
  }


  void _setupKeyboardListener() {
    RawKeyboard.instance.addListener((RawKeyEvent event) {
      if (event is RawKeyDownEvent) {
        if (_movieRows.isEmpty) return;

        setState(() {
          if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
            _selectedMovieIndex = (_selectedMovieIndex + 1) % _movieRows[_selectedRowIndex].length;
          } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
            _selectedMovieIndex =
                (_selectedMovieIndex - 1 + _movieRows[_selectedRowIndex].length) % _movieRows[_selectedRowIndex].length;
          } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
            _selectedRowIndex = (_selectedRowIndex + 1) % _movieRows.length;
            _selectedMovieIndex = 0;
          } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
            _selectedRowIndex = (_selectedRowIndex - 1 + _movieRows.length) % _movieRows.length;
            _selectedMovieIndex = 0;
          } else if (event.logicalKey == LogicalKeyboardKey.enter) {
            _focusedMovie = _movieRows[_selectedRowIndex][_selectedMovieIndex];
            _updateTrailer(_focusedMovie!);
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _youtubeController?.dispose();
    RawKeyboard.instance.removeListener((_) {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final videoHeight = screenHeight * 0.6; // Video takes up 50% of screen height
    final videoWidth = videoHeight * (16 / 9); // Ensures a 16:9 aspect ratio

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          /// 📌 **1. Video Player (Back of Stack)**
          if (_focusedMovie != null && _youtubeController != null)
            Positioned(
              top: 0,
              right: 0,
              width: videoWidth,
              height: videoHeight,
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: YoutubePlayer(
                  key: ValueKey(_youtubeController!.initialVideoId),
                  controller: _youtubeController!,
                  showVideoProgressIndicator: false,
                ),
              ),
            ),

          /// 📌 **2. Movie Title & Description (Left, Overlapping Video)**
          Positioned(
            top: 0,
            left: 70,
            width: screenWidth * 0.4,
            height: videoHeight,
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.black,
                    Colors.black.withValues(alpha: 0.999),
                    Colors.black.withValues(alpha: 0.95),
                    Colors.black.withValues(alpha: 0.9),
                    Colors.transparent,
                  ],
                  stops: [0.0, 0.78,0.8,0.84, 0.9],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _focusedMovie?.title ?? "",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    _focusedMovie?.description ?? "",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),


          /// 📌 **2. Gradient Overlay (In Front of Video, Behind Movies)**
          Positioned(
            top: screenHeight * 0.5,  // ✅ Starts halfway down the screen
            left: 0,
            right: 0,
            height: screenHeight * 0.2, // ✅ Covers the top half of bottom screen
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black, // ✅ Strong black at the bottom
                    Colors.black,
                    Colors.black.withValues(alpha: 0.9),
                    Colors.black.withValues(alpha: 0.8),
                    Colors.transparent, // ✅ Fades to transparent at the top
                  ],
                  stops: [0.0, 0.4, 0.6, 0.7, 1.0], // ✅ Controls the fade
                ),
              ),
            ),
          ),

          /// 📌 **3. Movie Rows (Front of Stack with Half-Screen Vertical Padding)**
          Positioned(
            top: screenHeight * 0.5, // Starts from half the screen
            left: 70,
            right: 0,
            bottom: 0,
            child: ListView(
              children: [
                _buildGenreRow("Trending Now", movieService.fetchTrendingMovies),
                _buildGenreRow("Top Rated", movieService.fetchTopRatedMovies),
                _buildGenreRow("Action Movies", () => movieService.fetchMoviesByGenre("28")),
                _buildGenreRow("Comedy Movies", () => movieService.fetchMoviesByGenre("35")),
                _buildGenreRow("Horror Movies", () => movieService.fetchMoviesByGenre("27")),
                _buildGenreRow("TV Shows", movieService.fetchTrendingTVShows),
              ],
            ),
          ),

          /// 📌 **4. Sidebar Navigation (Left Side)**
          Positioned(
            top: 0,
            left: 0,
            bottom: 0,
            width: 60,
            child: Container(
              color: Colors.black,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(icon: Icon(Icons.search, color: Colors.white),iconSize: 20, onPressed: () {}),
                  IconButton(icon: Icon(Icons.home, color: Colors.white), iconSize: 20, onPressed: () {}),
                  IconButton(icon: Icon(Icons.movie, color: Colors.white),iconSize: 20, onPressed: () {}),
                  IconButton(icon: Icon(Icons.live_tv, color: Colors.white),iconSize: 20, onPressed: () {}),
                  IconButton(icon: Icon(Icons.sports, color: Colors.white),iconSize: 20, onPressed: () {}),
                  IconButton(icon: Icon(Icons.settings, color: Colors.white),iconSize: 20, onPressed: () {}),
                ],
              ),
            ),
          ),

          /// 📌 **2. Gradient Overlay (In Front of  Movies)**
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: screenHeight * 0.1,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black, // ✅ Strong black at the bottom
                    Colors.black.withValues(alpha: 0.8),
                    Colors.black.withValues(alpha: 0.8),
                    Colors.black.withValues(alpha: 0.6),
                    Colors.transparent, // ✅ Fades to transparent at the top
                  ],
                  stops: [0.0, 0.1, 0.2, 0.5, .9], // ✅ Controls the fade
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenreRow(String title, Future<List<model.Movie>> Function() fetchMovies) {
    return FutureBuilder<List<model.Movie>>(
      future: fetchMovies(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SizedBox(height: 200, child: Center(child: CircularProgressIndicator()));
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(8.0,2,0,2),
              child: Text(
                title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            SizedBox(
              height: 180,  // Keep height same
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 0.0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _focusedMovie = snapshot.data![index];
                          _updateTrailer(_focusedMovie!);
                        });
                      },
                      child: MovieCard(snapshot.data![index]),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}