class Movie {
  final String title;
  final String posterUrl;
  final String id;
  final String description;
  final String backdropPath;
  final double voteAverage;
  final List<int> genreIds;

  Movie({
    required this.title,
    required this.posterUrl,
    required this.id,
    required this.description,
    required this.backdropPath,
    required this.voteAverage,
    required this.genreIds,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json['title'] ?? 'Unknown',
      posterUrl: json['poster_path'] != null
          ? "https://image.tmdb.org/t/p/w500${json['poster_path']}"
          : "https://via.placeholder.com/300x450",
      id: json['id'].toString(), // ✅ Use `id` field from API response
      description: json['overview'] ?? 'No description available.',
      backdropPath: json['backdrop_path'] != null
          ? "https://image.tmdb.org/t/p/w780${json['backdrop_path']}"
          : "",
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      genreIds: List<int>.from(json['genre_ids'] ?? []),
    );
  }
}
