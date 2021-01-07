import 'package:badee_task/models/post.dart';
import 'package:badee_task/models/post_id.dart';
import 'package:http/http.dart' as http;

class PostService {
  final String url = 'https://dummyapi.io/data/api/post';
  final String appId = '5ff2f6f3cbaf25e8e0138c19';

  Future<Posts> fetchPosts() async {
    var response = await http.get(url, headers: {'app-id': appId});
    if (response.statusCode == 200) {
      print('status code = ${response.statusCode}');
      var data = Posts.fromJson(response.body);
      return data;
    }
    return Posts(data: []);
  }

  Future<PostsId> fetchPostsByID(String postId) async {

    final String urlById = 'https://dummyapi.io/data/api/post/${postId}';
    var response = await http.get(urlById, headers: {'app-id': appId});
    if (response.statusCode == 200) {
      print('status code Id = ${response.statusCode}');
      var data = PostsId.fromJson(response.body);

      return data;
    }
    return PostsId(id: '');
  }
}
