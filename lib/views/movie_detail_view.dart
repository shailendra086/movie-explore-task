import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/movie.dart';
import '../core/constants.dart';
import '../providers/movie_list_provider.dart';

class MovieDetailView extends ConsumerStatefulWidget {
  final int movieId;
  final String? heroTagSuffix;

  const MovieDetailView({required this.movieId, this.heroTagSuffix, Key? key})
    : super(key: key);

  @override
  ConsumerState<MovieDetailView> createState() => _MovieDetailViewState();
}

class _InfoCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color? iconColor;
  final Color backgroundColor;
  final Color textColor;

  const _InfoCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.backgroundColor,
    required this.textColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 20, color: iconColor ?? textColor),
              const SizedBox(width: 8),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
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
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 400.0,
            floating: false,
            pinned: true,
            backgroundColor: Colors.black.withOpacity(0.5),
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface.withOpacity(0.8),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: movie!.posterPath.isNotEmpty
                  ? Hero(
                      tag:
                          'movie-poster-${movie!.id}${widget.heroTagSuffix ?? ''}',
                      child: CachedNetworkImage(
                        imageUrl:
                            '${ApiConstants.imageBaseUrl}${movie!.posterPath}',
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            Container(color: Colors.grey[300]),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    )
                  : Container(color: Colors.grey[300]),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie!.title,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _InfoCard(
                        label: 'Rating',
                        value: '${movie!.voteAverage.toStringAsFixed(1)}/10',
                        icon: Icons.star_rounded,
                        iconColor: Colors.amber,
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.primaryContainer,
                        textColor: Theme.of(
                          context,
                        ).colorScheme.onPrimaryContainer,
                      ),
                      const SizedBox(width: 24),
                      _InfoCard(
                        label: 'Release Date',
                        value: movie!.releaseDate,
                        icon: Icons.calendar_today_rounded,
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.primaryContainer,
                        textColor: Theme.of(
                          context,
                        ).colorScheme.onPrimaryContainer,
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Movie Description',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.surfaceVariant.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Theme.of(
                          context,
                        ).colorScheme.outline.withOpacity(0.1),
                      ),
                    ),
                    child: Text(
                      movie!.overview,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        height: 1.5,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
