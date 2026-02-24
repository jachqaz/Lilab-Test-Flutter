import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart' as provider;

import '../bloc/home/home_cubit.dart';
import '../bloc/home/home_state.dart';
import '../providers/animation_provider.dart';
import '../providers/search_provider.dart';
import '../services/like_sync_service.dart';
import '../utils/responsive_utils.dart';
import '../widgets/responsive_post_grid.dart';
import '../widgets/skeleton_loader.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().loadPosts();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveUtils.isDesktop(context);

    return isDesktop ? _buildDesktopLayout() : _buildMobileLayout();
  }

  Widget _buildDesktopLayout() {
    final searchProvider = provider.Provider.of<SearchProvider>(context);
    final animationProvider = provider.Provider.of<AnimationProvider>(context);

    return Scaffold(
      body: Row(
        children: [
          _buildSidebar(),
          Expanded(
            child: Column(
              children: [
                _buildDesktopAppBar(searchProvider),
                Expanded(child: _buildContent(animationProvider)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(right: BorderSide(color: Colors.grey[300]!, width: 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Icon(
                  Icons.article_outlined,
                  size: 32,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 12),
                const Text(
                  'Social Challenge',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            selected: true,
            selectedTileColor: Theme.of(context).colorScheme.primaryContainer,
          ),
          ListTile(
            leading: const Icon(Icons.favorite_border),
            title: const Text('Favoritos'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('Perfil'),
            onTap: () {},
          ),
          const Spacer(),
          const Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'v1.0.0',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopAppBar(SearchProvider searchProvider) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(bottom: BorderSide(color: Colors.grey[300]!, width: 1)),
      ),
      child: Row(
        children: [
          const Text(
            'Posts',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          SizedBox(
            width: 400,
            child: TextField(
              controller: searchProvider.searchController,
              decoration: InputDecoration(
                hintText: 'Buscar posts...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searchProvider.searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          searchProvider.searchController.clear();
                          context.read<HomeCubit>().searchPosts('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              onChanged: (query) {
                searchProvider.onSearchChanged(
                  query,
                  (q) => context.read<HomeCubit>().searchPosts(q),
                );
              },
            ),
          ),
          const SizedBox(width: 16),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<HomeCubit>().loadPosts(),
            tooltip: 'Recargar',
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout() {
    final searchProvider = provider.Provider.of<SearchProvider>(context);
    final animationProvider = provider.Provider.of<AnimationProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: searchProvider.isSearchActive
            ? TextField(
                controller: searchProvider.searchController,
                focusNode: searchProvider.searchFocusNode,
                decoration: InputDecoration(
                  hintText: 'Buscar posts...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey[400]),
                ),
                style: const TextStyle(fontSize: 16),
                onChanged: (query) {
                  searchProvider.onSearchChanged(
                    query,
                    (q) => context.read<HomeCubit>().searchPosts(q),
                  );
                },
              )
            : const Text('Social Challenge'),
        actions: [
          IconButton(
            icon: Icon(
              searchProvider.isSearchActive ? Icons.close : Icons.search,
            ),
            onPressed: () {
              searchProvider.toggleSearch();
              if (!searchProvider.isSearchActive) {
                context.read<HomeCubit>().searchPosts('');
              }
            },
          ),
        ],
      ),
      body: _buildContent(animationProvider),
    );
  }

  Widget _buildContent(AnimationProvider animationProvider) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return state.when(
          initial: () => const Center(child: Text('Presiona para cargar')),
          loading: () => const SkeletonLoader(),
          loaded: (posts, searchQuery) {
            if (posts.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text(
                      searchQuery != null && searchQuery.isNotEmpty
                          ? 'No se encontraron resultados'
                          : 'No hay posts disponibles',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              );
            }

            return ResponsivePostGrid(
              posts: posts,
              onPostTap: (post) => context.push('/post/${post.id}'),
              onLikeTap: (post) async {
                animationProvider.startLikeAnimation(post.id);
                final syncService = LikeSyncService(
                  ref,
                  context.read<HomeCubit>(),
                );
                await syncService.toggleLike(post.id, post.isLiked);
              },
              isAnimating: (postId) => animationProvider.isAnimating(postId),
            );
          },
          error: (message) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                const SizedBox(height: 16),
                Text(
                  'Error: $message',
                  style: TextStyle(color: Colors.red[700]),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => context.read<HomeCubit>().loadPosts(),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reintentar'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
