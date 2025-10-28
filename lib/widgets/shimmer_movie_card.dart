import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerMovieCard extends StatelessWidget {
  const ShimmerMovieCard({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Column(
          children: [
            Expanded(child: Container(color: Colors.white)),
            Container(
              height: 16,
              margin: const EdgeInsets.all(8),
              color: Colors.white,
            ),
            Container(
              height: 12,
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
