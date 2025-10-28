import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/movie.dart';
import '../core/constants.dart';
import '../providers/movie_list_provider.dart';

class MovieDetailView extends ConsumerStatefulWidget {
  final int movieId;
  const MovieDetailView({required this.movieId, Key? key}) : super(key: key);

  @override
  ConsumerState<MovieDetailView> createState() => _MovieDetailViewState();
}

class _MovieDetailViewState extends ConsumerState<MovieDetailView> {
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
      final service = ref.read(tmdbServiceProvider);
      final m = await service.fetchMovieDetails(widget.movieId);
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
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (error != null) {
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
    }
    return Scaffold(
      appBar: AppBar(title: Text(movie!.title), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (movie!.posterPath.isNotEmpty)
              Image.network('${ApiConstants.imageBaseUrl}${movie!.posterPath}'),
            const SizedBox(height: 24),
            Text(
              movie!.title,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.star, size: 16),
                const SizedBox(width: 4),
                Text(movie!.voteAverage.toString()),
                const SizedBox(width: 16),
                Text(movie!.releaseDate),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              movie!.overview,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
