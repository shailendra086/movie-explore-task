import 'package:flutter_riverpod/legacy.dart';
import 'package:movieexplorer/providers/movie_list_provider.dart';
import '../models/movie.dart';
import '../repositories/movie_repository.dart';

final searchQueryProvider = StateProvider<String>((_) => '');

class SearchState {
  final List<Movie> results;
  final bool loading;
  final String? error;
  SearchState({required this.results, required this.loading, this.error});
  factory SearchState.initial() => SearchState(results: [], loading: false);
}

class SearchNotifier extends StateNotifier<SearchState> {
  final MovieRepository repo;
  SearchNotifier(this.repo) : super(SearchState.initial());

  Future<void> search(String query) async {
    if (query.isEmpty) {
      state = SearchState.initial();
      return;
    }
    state = SearchState(results: [], loading: true);
    try {
      final res = await repo.search(query);
      state = SearchState(results: res, loading: false);
    } catch (e) {
      state = SearchState(results: [], loading: false, error: e.toString());
    }
  }
}

final searchProvider = StateNotifierProvider<SearchNotifier, SearchState>((ref) {
  final repo = ref.read(movieRepositoryProvider);
  return SearchNotifier(repo);
});
