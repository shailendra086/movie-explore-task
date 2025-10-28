import 'dart:io';

class NetworkException implements Exception {
  final String message;
  final int? statusCode;

  NetworkException(this.message, [this.statusCode]);

  static String getUserFriendlyMessage(Object error) {
    if (error is SocketException) {
      return 'Unable to connect to the internet. Please check your connection and try again.';
    } else if (error is NetworkException) {
      if (error.statusCode == 404) {
        return 'The requested content was not found. Please try again later.';
      } else if (error.statusCode == 429) {
        return 'Too many requests. Please wait a moment and try again.';
      } else if (error.statusCode == 401 || error.statusCode == 403) {
        return 'Unable to access the movie data. Please try again later.';
      } else {
        return error.message;
      }
    } else if (error is FormatException) {
      return 'There was a problem processing the data. Please try again later.';
    }
    return 'Something went wrong. Please try again later.';
  }
}
