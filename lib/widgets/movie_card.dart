import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/movie.dart';
import '../core/constants.dart';
import '../views/movie_detail_view.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;
  const MovieCard({required this.movie, Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => MovieDetailView(movieId: movie.id))),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: movie.posterPath.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: '${ApiConstants.imageBaseUrl}${movie.posterPath}',
                      fit: BoxFit.cover,
                      width: double.infinity,
                    )
                  : Container(color: Colors.grey, child: const Center(child: Icon(Icons.movie))),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(movie.title, maxLines: 2, overflow: TextOverflow.ellipsis),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  Icon(Icons.star, size: 14),
                  const SizedBox(width: 4),
                  Text(movie.voteAverage.toString()),
                  const Spacer(),
                  Text(movie.releaseDate.isNotEmpty ? movie.releaseDate.split('-')[0] : ''),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
