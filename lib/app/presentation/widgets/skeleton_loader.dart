import 'package:flutter/material.dart';

class SkeletonLoader extends StatefulWidget {
  const SkeletonLoader({super.key});

  @override
  State<SkeletonLoader> createState() => _SkeletonLoaderState();
}

class _SkeletonLoaderState extends State<SkeletonLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 6,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildShimmer(context, height: 20, width: double.infinity),
                    const SizedBox(height: 8),
                    _buildShimmer(context, height: 16, width: double.infinity),
                    const SizedBox(height: 4),
                    _buildShimmer(context, height: 16, width: 200),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildShimmer(
    BuildContext context, {
    required double height,
    required double width,
  }) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Colors.grey[300]!, Colors.grey[100]!, Colors.grey[300]!],
          stops: [
            _controller.value - 0.3,
            _controller.value,
            _controller.value + 0.3,
          ].map((e) => e.clamp(0.0, 1.0)).toList(),
        ),
      ),
    );
  }
}
