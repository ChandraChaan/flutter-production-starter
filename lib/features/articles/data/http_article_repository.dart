import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/error/app_exception.dart';
import '../../../core/network/api_client.dart';
import '../domain/article.dart';
import '../domain/article_repository.dart';

/// Articles from a JSON API. The starter points at JSONPlaceholder's
/// `/posts`; replace the paths with your own backend's.
class HttpArticleRepository implements ArticleRepository {
  const HttpArticleRepository(this._api);

  final ApiClient _api;

  @override
  Future<List<Article>> fetchArticles() async {
    final json = await _api.getJson('/posts');
    if (json is! List) throw ParseException('Expected a list, got $json');
    return [for (final item in json) Article.fromJson(item)];
  }

  @override
  Future<Article> fetchArticle(int id) async =>
      Article.fromJson(await _api.getJson('/posts/$id'));
}

final articleRepositoryProvider = Provider<ArticleRepository>(
  (ref) => HttpArticleRepository(ref.watch(apiClientProvider)),
);
