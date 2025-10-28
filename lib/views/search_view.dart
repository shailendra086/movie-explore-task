import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/search_provider.dart';
import '../widgets/movie_card.dart';
import '../widgets/shimmer_movie_card.dart';
import '../widgets/error_retry.dart';

class SearchView extends ConsumerStatefulWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  ConsumerState<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends ConsumerState<SearchView> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;

  void _onSearchChanged(String query) {
    // debounce user input to avoid hitting API for every keystroke
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      ref.read(searchProvider.notifier).search(query);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(searchProvider);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          autofocus: true,
          onChanged: _onSearchChanged,
          decoration: const InputDecoration(
            hintText: 'Search movies...',
            border: InputBorder.none,
          ),
        ),
      ),
      body: _buildBody(state),
    );
  }

  Widget _buildBody(SearchState state) {
    if (state.loading) {
      // shimmer while loading
      return GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.65,
        ),
        itemCount: 6,
        itemBuilder: (_, __) => const ShimmerMovieCard(),
      );
    }

    if (state.error != null) {
      return Center(
        child: ErrorRetry(
          message: state.error!,
          onRetry: () =>
              ref.read(searchProvider.notifier).search(_controller.text),
        ),
      );
    }

    if (state.results.isEmpty && _controller.text.isNotEmpty) {
      return const Center(child: Text('No results found'));
    }

    if (state.results.isEmpty && _controller.text.isEmpty) {
      return const Center(child: Text('Start typing to search for movies',style: TextStyle(color: Colors.black,),));
    }

    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.65,
      ),
      itemCount: state.results.length,
      itemBuilder: (_, index) {
        final movie = state.results[index];
        return MovieCard(movie: movie);
      },
    );
  }
}
