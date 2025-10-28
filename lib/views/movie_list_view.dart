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
    if (state.status == MovieListStatus.initial ||
        (state.status == MovieListStatus.loading && state.movies.isEmpty)) {
      // show shimmer grid
      return GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.65,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
        ),
        itemCount: 6,
        itemBuilder: (_, __) => const ShimmerMovieCard(),
      );
    }
    if (state.status == MovieListStatus.error && state.movies.isEmpty) {
      return Center(
        child: ErrorRetry(
          message: state.error ?? 'Error',
          onRetry: () => ref.read(movieListProvider.notifier).refresh(),
        ),
      );
    }

    // show loaded content
    return RefreshIndicator(
      onRefresh: () => ref.read(movieListProvider.notifier).refresh(),
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.65,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            delegate: SliverChildBuilderDelegate((context, index) {
              if (index >= state.movies.length) {
                return const SizedBox.shrink();
              }
              return MovieCard(
                movie: state.movies[index],
                heroTagSuffix: '-list-$index',
              );
            }, childCount: state.movies.length),
          ),
          if (state.hasMore)
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).shadowColor.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
