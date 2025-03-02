import 'package:flutter/material.dart';
import '../models/movie_model.dart' as model;
import '../services/movie_service.dart';

class MovieProvider with ChangeNotifier {
  final MovieService _movieService = MovieService();

  List<model.Movie> _trendingMovies = [];
  String? _trailerUrl;
  bool _isLoading = false;
  bool _isDisposed = false;

  List<model.Movie> get trendingMovies => _trendingMovies;
  String? get trailerUrl => _trailerUrl;
  bool get isLoading => _isLoading;

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  Future<void> fetchTrendingMovies() async {
    _setLoading(true);
    try {
      _trendingMovies = await _movieService.fetchTrendingMovies();
    } catch (e) {
      _trendingMovies = [];
    }
    _setLoading(false);
  }

  Future<void> fetchMovieTrailer(String movieId) async {
    _setLoading(true);
    try {
      _trailerUrl = await _movieService.fetchMovieTrailerUrl(movieId);
    } catch (e) {
      _trailerUrl = null;
    }
    _setLoading(false);
  }

  void _setLoading(bool value) {
    if (_isDisposed) return;
    _isLoading = value;
    notifyListeners();
  }
}
