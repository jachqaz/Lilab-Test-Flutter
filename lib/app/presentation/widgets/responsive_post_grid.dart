import 'package:flutter/material.dart';

import '../../domain/entities/post.dart';
import '../utils/responsive_utils.dart';

class ResponsivePostGrid extends StatelessWidget {
  final List<Post> posts;
  final Function(Post) onPostTap;
  final Function(Post) onLikeTap;
  final bool Function(int) isAnimating;

  const ResponsivePostGrid({
    super.key,
    required this.posts,
    required this.onPostTap,
    required this.onLikeTap,
    required this.isAnimating,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final deviceType = ResponsiveUtils.getDeviceType(context);

        switch (deviceType) {
          case DeviceType.mobile:
            return _buildMobileView();
          case DeviceType.tablet:
            return _buildTabletView();
          case DeviceType.desktop:
            return _buildDesktopView(context);
        }
      },
    );
  }

  Widget _buildMobileView() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: posts.length,
      itemBuilder: (context, index) => _buildMobileCard(posts[index]),
    );
  }

  Widget _buildTabletView() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.5,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: posts.length,
      itemBuilder: (context, index) => _buildTabletCard(posts[index]),
    );
  }

  Widget _buildDesktopView(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1400),
        child: GridView.builder(
          padding: const EdgeInsets.all(24),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1.2,
            crossAxisSpacing: 24,
            mainAxisSpacing: 24,
          ),
          itemCount: posts.length,
          itemBuilder: (context, index) => _buildDesktopCard(posts[index]),
        ),
      ),
    );
  }

  Widget _buildMobileCard(Post post) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => onPostTap(post),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      post.body,
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              _buildLikeButton(post, 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabletCard(Post post) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => onPostTap(post),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      post.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  _buildLikeButton(post, 26),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Text(
                  post.body,
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopCard(Post post) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        onTap: () => onPostTap(post),
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Post #${post.id}',
                      style: TextStyle(
                        color: Colors.blue[700],
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Spacer(),
                  _buildLikeButton(post, 28),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                post.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  height: 1.3,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Text(
                  post.body,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 14,
                    height: 1.5,
                  ),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.person_outline, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    'User ${post.userId}',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLikeButton(Post post, double size) {
    final isAnim = isAnimating(post.id);

    return AnimatedScale(
      scale: isAnim ? 1.3 : 1.0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutBack,
      child: IconButton(
        icon: Icon(
          post.isLiked ? Icons.favorite : Icons.favorite_border,
          color: post.isLiked ? Colors.red : Colors.grey,
          size: size,
        ),
        onPressed: () => onLikeTap(post),
      ),
    );
  }
}
