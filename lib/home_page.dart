import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mock_api/posts_provider.dart';
import 'package:mock_api/scroll_helpers.dart';
import 'widgets/post_card.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    Future.microtask(() => ref.read(getPostsProvider.notifier).getPosts());
    _scrollController =
        ScrollController()..onScroll(() {
          try {
            ref.read(getPostsProvider.notifier).getMorePosts();
          } on Exception catch (e) {
            if (mounted) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
            }
          }
        });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final stateProvider = ref.watch(getPostsProvider);
    final provider = ref.read(getPostsProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: provider.getPosts,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: provider.getPosts,
        child:
            stateProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : stateProvider.error != null
                ? Center(child: Text(stateProvider.error!.toString()))
                : stateProvider.posts.isEmpty
                ? const Center(child: Text('No posts available'))
                : ListView.builder(
                  controller: _scrollController,
                  itemCount: stateProvider.posts.length,
                  itemBuilder: (context, index) {
                    return PostCard(post: stateProvider.posts[index]);
                  },
                ),
      ),
    );
  }
}
