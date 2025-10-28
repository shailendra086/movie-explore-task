import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../core/constants.dart';
import '../services/tmdb_api_service.dart';

class MovieDetailView extends StatefulWidget {
  final int movieId;
  const MovieDetailView({required this.movieId, Key? key}) : super(key: key);

  @override
  State<MovieDetailView> createState() => _MovieDetailViewState();
}

class _MovieDetailViewState extends State<MovieDetailView> {
  final _service = TmdbApiService();
  Movie? movie;
  bool loading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      loading = true;
      error = null;
    });
    try {
      final m = await _service.fetchMovieDetails(widget.movieId);
      setState(() {
        movie = m;
        loading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading)
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (error != null)
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(error!),
              ElevatedButton(onPressed: _load, child: const Text('Retry')),
            ],
          ),
        ),
      );
    return Scaffold(
      appBar: AppBar(title: Text(movie!.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (movie!.posterPath.isNotEmpty)
              Image.network('${ApiConstants.imageBaseUrl}${movie!.posterPath}'),
            const SizedBox(height: 12),
            Text(movie!.title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.star),
                Text(movie!.voteAverage.toString()),
                const SizedBox(width: 16),
                Text(movie!.releaseDate),
              ],
            ),
            const SizedBox(height: 12),
            Text(movie!.overview),
          ],
        ),
      ),
    );
  }
}
