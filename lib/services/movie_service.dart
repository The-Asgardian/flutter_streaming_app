// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants.dart';
import '../models/movie_model.dart' as model;

class MovieService {
  /// Fetches trending movies from TMDB
  Future<List<model.Movie>> fetchTrendingMovies() async {
    final url = "https://api.themoviedb.org/3/trending/movie/week?api_key=${AppConstants.TMDB_API_KEY}";
    return _fetchMovies(url);
  }

  /// Fetches top-rated movies
  Future<List<model.Movie>> fetchTopRatedMovies() async {
    final url = "https://api.themoviedb.org/3/movie/top_rated?api_key=${AppConstants.TMDB_API_KEY}";
    return _fetchMovies(url);
  }

  /// Fetches trending TV shows
  Future<List<model.Movie>> fetchTrendingTVShows() async {
    final url = "https://api.themoviedb.org/3/trending/tv/week?api_key=${AppConstants.TMDB_API_KEY}";
    return _fetchMovies(url);
  }

  /// Fetches movies by genre
  Future<List<model.Movie>> fetchMoviesByGenre(String genreId) async {
    final url = "https://api.themoviedb.org/3/discover/movie?api_key=${AppConstants.TMDB_API_KEY}&with_genres=$genreId";
    return _fetchMovies(url);
  }

  /// Fetches movie details including trailer information
  Future<String?> fetchMovieTrailerUrl(String movieId) async {
    if (movieId.isEmpty) {
      throw Exception("Movie ID is empty. Cannot fetch movie details.");
    }

    final url = "https://api.themoviedb.org/3/movie/$movieId/videos?api_key=${AppConstants.TMDB_API_KEY}&language=en-US";
    print("Fetching movie details from: $url");

    final headers = {
      "Accept": "application/json",
      "Authorization": "Bearer ${AppConstants.TMDB_ACCESS_TOKEN}"
    };

    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print("API Response: $data");

      String? trailerUrl;

      // Extract trailer link from videos
      if (data['results'] != null && data['results'].isNotEmpty) {
        for (var video in data['results']) {
          if (video['site'] == "YouTube" && video['type'] == "Trailer") {
            trailerUrl = "https://www.youtube.com/watch?v=${video['key']}";
            break;
          }
        }
      }

      if (trailerUrl == null) {
        print("No trailer found in API response for movie ID: $movieId");
      } else {
        print("Trailer found: $trailerUrl");
      }

      return trailerUrl;
    } else {
      print("Failed to fetch movie details, Status Code: ${response.statusCode}");
      throw Exception("Failed to fetch movie details");
    }
  }



  /// Helper method to process TMDB responses
  Future<List<model.Movie>> _fetchMovies(String url) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List results = json.decode(response.body)['results'];
      return results.map((e) => model.Movie.fromJson(e)).toList();
    } else {
      throw Exception("Failed to fetch movies");
    }
  }


}
