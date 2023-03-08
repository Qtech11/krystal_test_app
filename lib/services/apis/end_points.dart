class EndPoints {
  static const _baseUrl = "https://jsonplaceholder.typicode.com";

  String getListOfBlogPostEndPoint = '$_baseUrl/posts';
  String getCommentsOfAPostEndPoint(postId) =>
      '$_baseUrl/posts/$postId/comments';
}
