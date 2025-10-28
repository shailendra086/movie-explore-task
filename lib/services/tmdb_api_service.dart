import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../core/constants.dart';
import '../models/movie.dart';

class TmdbApiService {
  final String _apiKey = dotenv.env['TMDB_API_KEY'] ?? '';

  Future<List<Movie>> fetchTrending({int page = 1}) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}/trending/movie/week?api_key=$_apiKey&page=$page');
    final res = await http.get(uri);
    if (res.statusCode != 200) throw Exception('Failed fetching trending movies');
    final Map<String, dynamic> data = json.decode(res.body);
    final List results = data['results'] as List;
    return results.map((e) => Movie.fromJson(e)).toList();
  }

  Future<List<Movie>> searchMovies(String query, {int page = 1}) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}/search/movie?api_key=$_apiKey&query=${Uri.encodeQueryComponent(query)}&page=$page');
    final res = await http.get(uri);
    if (res.statusCode != 200) throw Exception('Search failed');
    final Map<String, dynamic> data = json.decode(res.body);
    final List results = data['results'] as List;
    return results.map((e) => Movie.fromJson(e)).toList();
  }

  Future<Movie> fetchMovieDetails(int id) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}/movie/$id?api_key=$_apiKey');
    final res = await http.get(uri);
    if (res.statusCode != 200) throw Exception('Failed fetching details');
    final data = json.decode(res.body);
    return Movie.fromJson(data);
  }
}
