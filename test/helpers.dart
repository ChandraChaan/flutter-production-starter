import 'package:flutter_production_starter/app/app.dart';
import 'package:flutter_production_starter/core/config/app_config.dart';
import 'package:flutter_production_starter/features/articles/data/http_article_repository.dart';
import 'package:flutter_production_starter/features/articles/domain/article.dart';
import 'package:flutter_production_starter/features/articles/domain/article_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';

final testConfig = AppConfig(
  environment: AppEnvironment.dev,
  apiBaseUrl: Uri.https('api.example.com'),
);

const sampleArticles = [
  Article(id: 1, title: 'First article', body: 'Hello from the first one.'),
  Article(id: 2, title: 'Second article', body: 'And the second.'),
];

/// A repository whose answers each test controls.
class FakeArticleRepository implements ArticleRepository {
  FakeArticleRepository({this.articles = sampleArticles, this.error});

  List<Article> articles;
  Object? error;
  int fetchCount = 0;

  @override
  Future<List<Article>> fetchArticles() async {
    fetchCount++;
    if (error case final error?) throw error;
    return articles;
  }

  @override
  Future<Article> fetchArticle(int id) async {
    if (error case final error?) throw error;
    return articles.firstWhere((a) => a.id == id);
  }
}

List<Override> testOverrides(ArticleRepository repository) => [
  appConfigProvider.overrideWithValue(testConfig),
  articleRepositoryProvider.overrideWithValue(repository),
];

Future<void> pumpApp(WidgetTester tester, ArticleRepository repository) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: testOverrides(repository),
      retry: (retryCount, error) => null,
      child: const App(),
    ),
  );
  await tester.pumpAndSettle();
}
