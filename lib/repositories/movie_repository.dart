import '../models/movie.dart';
import '../services/tmdb_api_service.dart';

class MovieRepository {
  final TmdbApiService apiService;
  MovieRepository(this.apiService);

  Future<List<Movie>> getTrending({int page = 1}) => apiService.fetchTrending(page: page);
  Future<List<Movie>> search(String q, {int page = 1}) => apiService.searchMovies(q, page: page);
  Future<Movie> getDetails(int id) => apiService.fetchMovieDetails(id);
}
