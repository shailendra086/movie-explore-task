import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:movieexplorer/services/tmdb_api_service.dart';
import '../models/movie.dart';
import '../repositories/movie_repository.dart';

enum MovieListStatus { initial, loading, loaded, error }

class MovieListState {
  final List<Movie> movies;
  final int page;
  final bool hasMore;
  final MovieListStatus status;
  final String? error;

  MovieListState({
    required this.movies,
    required this.page,
    required this.hasMore,
    required this.status,
    this.error,
  });

  MovieListState.initial()
      : movies = [],
        page = 1,
        hasMore = true,
        status = MovieListStatus.initial,
        error = null;

  MovieListState copyWith({
    List<Movie>? movies,
    int? page,
    bool? hasMore,
    MovieListStatus? status,
    String? error,
  }) {
    return MovieListState(
      movies: movies ?? this.movies,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }
}

class MovieListNotifier extends StateNotifier<MovieListState> {
  final MovieRepository repository;
  MovieListNotifier(this.repository) : super(MovieListState.initial()) {
    fetchNextPage();
  }

  Future<void> fetchNextPage() async {
    if (!state.hasMore || state.status == MovieListStatus.loading) return;
    try {
      state = state.copyWith(status: MovieListStatus.loading);
      final nextPage = state.page;
      final movies = await repository.getTrending(page: nextPage);
      final hasMore = movies.isNotEmpty;
      state = state.copyWith(
        movies: [...state.movies, ...movies],
        page: nextPage + 1,
        hasMore: hasMore,
        status: MovieListStatus.loaded,
      );
    } catch (e) {
      state = state.copyWith(status: MovieListStatus.error, error: e.toString());
    }
  }

  Future<void> refresh() async {
    state = MovieListState.initial();
    await fetchNextPage();
  }
}

final tmdbServiceProvider = Provider((ref) => TmdbApiService());
final movieRepositoryProvider = Provider((ref) => MovieRepository(ref.read(tmdbServiceProvider)));
final movieListProvider = StateNotifierProvider<MovieListNotifier, MovieListState>((ref) {
  final repo = ref.read(movieRepositoryProvider);
  return MovieListNotifier(repo);
});
