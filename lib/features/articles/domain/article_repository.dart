import 'article.dart';

/// What the app needs from wherever articles come from. Screens and
/// controllers depend on this, never on HTTP, so tests swap in a fake.
abstract interface class ArticleRepository {
  Future<List<Article>> fetchArticles();

  Future<Article> fetchArticle(int id);
}
