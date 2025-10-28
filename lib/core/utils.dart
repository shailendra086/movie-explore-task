import 'package:flutter/material.dart';

/// Returns full TMDb image URL or a fallback placeholder.
String imageUrl(String? path, {String size = 'w500'}) {
  if (path == null || path.isEmpty) {
    // You can replace this URL with a local asset if preferred
    return 'https://via.placeholder.com/500x750?text=No+Image';
  }
  return 'https://image.tmdb.org/t/p/$size$path';
}

/// Format date safely (YYYY-MM-DD -> readable)
String formatDate(String? date) {
  if (date == null || date.isEmpty) return 'N/A';
  try {
    final d = DateTime.parse(date);
    return '${d.day}/${d.month}/${d.year}';
  } catch (_) {
    return date;
  }
}

/// Truncate a string to a maximum length with ellipsis
String truncate(String text, [int max = 100]) {
  if (text.length <= max) return text;
  return '${text.substring(0, max)}...';
}

/// Display a SnackBar message easily
void showSnack(BuildContext context, String message, {bool isError = false}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: isError ? Colors.red : Colors.green,
      behavior: SnackBarBehavior.floating,
    ),
  );
}

/// Returns a star color based on rating
Color ratingColor(double rating) {
  if (rating >= 7.5) return Colors.green;
  if (rating >= 5.0) return Colors.orange;
  return Colors.red;
}

/// Safe image widget (fallback on error)
Image safeNetworkImage(
  String url, {
  BoxFit fit = BoxFit.cover,
  double? width,
  double? height,
}) {
  return Image.network(
    url,
    fit: fit,
    width: width,
    height: height,
    errorBuilder: (context, error, stackTrace) => Container(
      color: Colors.grey.shade300,
      child: const Center(child: Icon(Icons.broken_image)),
    ),
  );
}
