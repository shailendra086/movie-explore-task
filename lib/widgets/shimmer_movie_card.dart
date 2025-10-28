import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerMovieCard extends StatelessWidget {
  const ShimmerMovieCard({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: Shimmer.fromColors(
        baseColor: Theme.of(context).brightness == Brightness.light
            ? const Color(0xFFE0E0E0) // Light theme shimmer base
            : const Color(0xFF2A2A2A), // Dark theme shimmer base
        highlightColor: Theme.of(context).brightness == Brightness.light
            ? const Color(0xFFF5F5F5) // Light theme shimmer highlight
            : const Color(0xFF3D3D3D), // Dark theme shimmer highlight
        period: const Duration(
          milliseconds: 1500,
        ), // Slightly slower animation for better effect
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: const BoxDecoration(color: Colors.white),
              ),
            ),
            Container(
              height: 16,
              margin: const EdgeInsets.fromLTRB(12, 12, 40, 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            Container(
              height: 12,
              margin: const EdgeInsets.fromLTRB(12, 0, 80, 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
