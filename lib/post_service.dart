import 'package:mock_api/http_client.dart';
import 'package:mock_api/models/post.dart';

class PostService {
  final ApiClient client;
  PostService(this.client);

  // Future<List<Post>> getPosts({int page = 1}) async {
  //   final res = await client.get('/posts', query: {'page': page});

  //   final data = res.data as List;
  //   return data.map((e) => Post.fromJson(e as Map<String, dynamic>)).toList();
  // }

  Future<List<Post>> getPosts({int page = 1}) async {
    await Future.delayed(const Duration(seconds: 1));

    return List.generate(10, (index) {
      return Post(
        id: index + 1,
        title: 'Dummy Post ${index + 1}',
        body: 'This is the body of dummy post ${index + 1}.',
        userId: index + 1,
      );
    });
  }
}
