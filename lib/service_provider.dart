import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mock_api/http_client.dart';
import 'package:mock_api/post_service.dart';

final httpClient = Provider<ApiClient>((ref) => ApiClient(dioInstance));

final postServiceProvider = Provider<PostService>(
  (ref) => PostService(ref.read(httpClient)),
);
