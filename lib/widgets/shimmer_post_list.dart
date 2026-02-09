import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerPostList extends StatelessWidget {
  const ShimmerPostList({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        itemCount: 8,
        padding: const EdgeInsets.all(16),
        itemBuilder: (_, __) => Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Card(
            child: ListTile(
              leading: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              title: Container(height: 16, color: Colors.white),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Container(height: 12, color: Colors.white),
                  const SizedBox(height: 6),
                  Container(height: 12, width: 200, color: Colors.white),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}