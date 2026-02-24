import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as provider;

import '../../config/providers/riverpod_providers.dart';
import '../bloc/home/home_cubit.dart';
import '../bloc/post_detail/post_detail_cubit.dart';
import '../bloc/post_detail/post_detail_state.dart';
import '../providers/animation_provider.dart';
import '../services/like_sync_service.dart';
import '../utils/responsive_utils.dart';
import '../widgets/staggered_comment_list.dart';

class PostDetailPage extends ConsumerStatefulWidget {
  final String postId;

  const PostDetailPage({super.key, required this.postId});

  @override
  ConsumerState<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends ConsumerState<PostDetailPage> {
  late PostDetailCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = PostDetailCubit(ref.read(getCommentsUseCaseProvider));
    _cubit.loadComments(int.parse(widget.postId));
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveUtils.isDesktop(context);

    return isDesktop ? _buildDesktopLayout() : _buildMobileLayout();
  }

  Widget _buildDesktopLayout() {
    final postId = int.parse(widget.postId);
    final isLiked = ref.watch(likeStateProvider)[postId] ?? false;
    final animationProvider = provider.Provider.of<AnimationProvider>(context);
    final isAnimating = animationProvider.isAnimating(postId);

    return Scaffold(
      appBar: AppBar(
        title: Text('Post #${widget.postId}'),
        centerTitle: false,
        actions: [
          AnimatedScale(
            scale: isAnimating ? 1.3 : 1.0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutBack,
            child: IconButton(
              icon: Icon(
                isLiked ? Icons.favorite : Icons.favorite_border,
                color: isLiked ? Colors.red : null,
                size: 28,
              ),
              onPressed: () async {
                animationProvider.startLikeAnimation(postId);
                final homeCubit = context.read<HomeCubit>();
                final syncService = LikeSyncService(ref, homeCubit);
                await syncService.toggleLike(postId, isLiked);
              },
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: BlocBuilder<PostDetailCubit, PostDetailState>(
            bloc: _cubit,
            builder: (context, state) {
              return state.when(
                initial: () => const Center(child: CircularProgressIndicator()),
                loading: () => const Center(child: CircularProgressIndicator()),
                loaded: (comments) {
                  if (comments.isEmpty) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.comment_outlined,
                            size: 64,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'No hay comentarios',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(24),
                    itemCount: comments.length,
                    itemBuilder: (context, index) {
                      final comment = comments[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 24,
                                    backgroundColor: Theme.of(
                                      context,
                                    ).colorScheme.primaryContainer,
                                    child: Text(
                                      comment.name[0].toUpperCase(),
                                      style: TextStyle(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onPrimaryContainer,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          comment.name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          comment.email,
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                comment.body,
                                style: const TextStyle(
                                  fontSize: 15,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                error: (message) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.red[300],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Error: $message',
                        style: TextStyle(color: Colors.red[700]),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () => _cubit.loadComments(postId),
                        icon: const Icon(Icons.refresh),
                        label: const Text('Reintentar'),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildMobileLayout() {
    final postId = int.parse(widget.postId);
    final isLiked = ref.watch(likeStateProvider)[postId] ?? false;
    final animationProvider = provider.Provider.of<AnimationProvider>(context);
    final isAnimating = animationProvider.isAnimating(postId);

    return Scaffold(
      body: BlocBuilder<PostDetailCubit, PostDetailState>(
        bloc: _cubit,
        builder: (context, state) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 200,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    'Post #${widget.postId}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          offset: Offset(0, 1),
                          blurRadius: 3,
                          color: Colors.black26,
                        ),
                      ],
                    ),
                  ),
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Theme.of(context).colorScheme.primary,
                          Theme.of(context).colorScheme.secondary,
                        ],
                      ),
                    ),
                  ),
                ),
                actions: [
                  AnimatedScale(
                    scale: isAnimating ? 1.3 : 1.0,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutBack,
                    child: IconButton(
                      icon: Icon(
                        isLiked ? Icons.favorite : Icons.favorite_border,
                        color: isLiked ? Colors.red : Colors.white,
                        size: 28,
                      ),
                      onPressed: () async {
                        animationProvider.startLikeAnimation(postId);
                        final homeCubit = context.read<HomeCubit>();
                        final syncService = LikeSyncService(ref, homeCubit);
                        await syncService.toggleLike(postId, isLiked);
                      },
                    ),
                  ),
                ],
              ),
              state.when(
                initial: () => const SliverFillRemaining(
                  child: Center(child: Text('Cargando...')),
                ),
                loading: () => const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                ),
                loaded: (comments) {
                  if (comments.isEmpty) {
                    return const SliverFillRemaining(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.comment_outlined,
                              size: 64,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'No hay comentarios',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return StaggeredCommentList(comments: comments);
                },
                error: (message) => SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red[300],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error: $message',
                          style: TextStyle(color: Colors.red[700]),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () => _cubit.loadComments(postId),
                          icon: const Icon(Icons.refresh),
                          label: const Text('Reintentar'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
