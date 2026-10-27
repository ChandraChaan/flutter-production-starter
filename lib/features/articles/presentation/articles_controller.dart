import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/http_article_repository.dart';
import '../domain/article.dart';

class ArticlesController extends AsyncNotifier<List<Article>> {
  @override
  Future<List<Article>> build() =>
      ref.watch(articleRepositoryProvider).fetchArticles();

  /// Reloads the list. The screen keeps showing the current articles while
  /// this runs, and the result (or error) replaces them when it finishes.
  Future<void> refresh() async {
    ref.invalidateSelf();
    try {
      await future;
    } catch (_) {
      // The error is in `state`; the screen shows it.
    }
  }
}

final articlesControllerProvider =
    AsyncNotifierProvider<ArticlesController, List<Article>>(
      ArticlesController.new,
    );

final articleProvider = FutureProvider.family<Article, int>(
  (ref, id) => ref.watch(articleRepositoryProvider).fetchArticle(id),
);
