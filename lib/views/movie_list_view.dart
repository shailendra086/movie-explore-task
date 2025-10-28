import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/movie_list_provider.dart';
import '../widgets/movie_card.dart';
import '../widgets/shimmer_movie_card.dart';
import '../widgets/error_retry.dart';

class MovieListView extends ConsumerStatefulWidget {
  const MovieListView({Key? key}) : super(key: key);
  @override
  _MovieListViewState createState() => _MovieListViewState();
}

class _MovieListViewState extends ConsumerState<MovieListView> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      final max = _scrollController.position.maxScrollExtent;
      final current = _scrollController.position.pixels;
      if (current >= (max - 200)) {
        ref.read(movieListProvider.notifier).fetchNextPage();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(movieListProvider);
    if (state.status == MovieListStatus.initial || (state.status == MovieListStatus.loading && state.movies.isEmpty)) {
      // show shimmer grid
      return GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.65),
        itemCount: 6,
        itemBuilder: (_, __) => const ShimmerMovieCard(),
      );
    }
    if (state.status == MovieListStatus.error && state.movies.isEmpty) {
      return Center(child: ErrorRetry(message: state.error ?? 'Error', onRetry: () => ref.read(movieListProvider.notifier).refresh()));
    }

    // show loaded content
    return RefreshIndicator(
      onRefresh: () => ref.read(movieListProvider.notifier).refresh(),
      child: GridView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.65),
        itemCount: state.hasMore ? state.movies.length + 1 : state.movies.length,
        itemBuilder: (context, index) {
          if (index >= state.movies.length) {
            // loading indicator at bottom
            return const Padding(
              padding: EdgeInsets.all(8),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          final movie = state.movies[index];
          return MovieCard(movie: movie);
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
