import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../core/constants.dart';
import '../core/network_exceptions.dart';
import '../models/movie.dart';

class TmdbApiService {
  // Your TMDb API key
  final String _apiKey = '7b969cbddd20fec29f32bec62bb16360';

  Future<List<Movie>> fetchTrending({int page = 1}) async {
    try {
      final uri = Uri.parse(
        '${ApiConstants.baseUrl}/trending/movie/week?api_key=$_apiKey&page=$page',
      );
      final res = await http.get(uri);
      if (res.statusCode != 200) {
        throw NetworkException(
          'Unable to load trending movies',
          res.statusCode,
        );
      }
      final Map<String, dynamic> data = json.decode(res.body);
      final List results = data['results'] as List;
      return results.map((e) => Movie.fromJson(e)).toList();
    } on SocketException {
      throw NetworkException('Unable to connect to the internet');
    } on FormatException {
      throw NetworkException('Received invalid data from the server');
    } catch (e) {
      if (e is NetworkException) rethrow;
      throw NetworkException('Failed to load trending movies');
    }
  }

  Future<List<Movie>> searchMovies(String query, {int page = 1}) async {
    try {
      final uri = Uri.parse(
        '${ApiConstants.baseUrl}/search/movie?api_key=$_apiKey&query=${Uri.encodeQueryComponent(query)}&page=$page',
      );
      final res = await http.get(uri);
      if (res.statusCode != 200) {
        throw NetworkException('Unable to search for movies', res.statusCode);
      }
      final Map<String, dynamic> data = json.decode(res.body);
      final List results = data['results'] as List;
      return results.map((e) => Movie.fromJson(e)).toList();
    } on SocketException {
      throw NetworkException('Unable to connect to the internet');
    } on FormatException {
      throw NetworkException('Received invalid data from the server');
    } catch (e) {
      if (e is NetworkException) rethrow;
      throw NetworkException('Failed to search for movies');
    }
  }

  Future<Movie> fetchMovieDetails(int id) async {
    try {
      final uri = Uri.parse(
        '${ApiConstants.baseUrl}/movie/$id?api_key=$_apiKey',
      );
      final res = await http.get(uri);
      if (res.statusCode != 200) {
        throw NetworkException('Unable to load movie details', res.statusCode);
      }
      final data = json.decode(res.body);
      return Movie.fromJson(data);
    } on SocketException {
      throw NetworkException('Unable to connect to the internet');
    } on FormatException {
      throw NetworkException('Received invalid data from the server');
    } catch (e) {
      if (e is NetworkException) rethrow;
      throw NetworkException('Failed to load movie details');
    }
  }
}
