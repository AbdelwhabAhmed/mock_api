import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mock_api/models/post.dart';
import 'package:mock_api/post_service.dart';
import 'package:mock_api/scroll_helpers.dart';
import 'package:mock_api/service_provider.dart';

class PostsState extends Equatable {
  final Exception? error;
  final bool isLoading;
  final List<Post> posts;
  final PaginationState paginationState;
  final int? nextPage;

  const PostsState({
    this.error,
    this.isLoading = false,
    this.posts = const [],
    this.paginationState = PaginationState.loaded,
    this.nextPage,
  });

  bool get hasNextPage => nextPage != null;

  bool get _isPaginating => paginationState == PaginationState.paginating;

  PostsState copyWith({
    Exception? error,
    bool? isLoading,
    List<Post>? posts,
    PaginationState? paginationState,
    int? nextPage,
  }) {
    return PostsState(
      error: error,
      isLoading: isLoading ?? this.isLoading,
      posts: posts ?? this.posts,
      paginationState: paginationState ?? this.paginationState,
      nextPage: nextPage,
    );
  }

  @override
  List<Object?> get props => [error, isLoading, posts];
}

class PostsProvider extends StateNotifier<PostsState> {
  final PostService _service;
  PostsProvider(this._service) : super(const PostsState());

  Future<void> getPosts() async {
    state = state.copyWith(isLoading: true);
    try {
      final posts = await _service.getPosts();

      final currentPage = state.nextPage ?? 1;

      state = state.copyWith(
        posts: posts,
        isLoading: false,
        nextPage: posts.isNotEmpty ? currentPage + 1 : null,
      );
    } on Exception catch (e) {
      state = state.copyWith(error: e, isLoading: false);
    }
  }

  Future<void> getMorePosts() async {
    final posts = state.posts;

    if (posts.isEmpty) return;

    if (state._isPaginating || !state.hasNextPage) return;

    state = state.copyWith(
      paginationState: PaginationState.paginating,
      nextPage: state.nextPage,
    );

    final morePosts = await _service.getPosts(page: state.nextPage!);

    final currentPage = state.nextPage ?? 1;

    state = state.copyWith(
      paginationState: PaginationState.loaded,
      posts: List.of(posts)..addAll(morePosts),
      nextPage: morePosts.isNotEmpty ? currentPage + 1 : null,
    );
  }
}

final getPostsProvider = StateNotifierProvider<PostsProvider, PostsState>((
  ref,
) {
  final service = ref.read(postServiceProvider);
  return PostsProvider(service);
});
