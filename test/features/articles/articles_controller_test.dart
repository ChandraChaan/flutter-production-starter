import 'package:flutter_production_starter/core/error/app_exception.dart';
import 'package:flutter_production_starter/features/articles/domain/article.dart';
import 'package:flutter_production_starter/features/articles/presentation/articles_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers.dart';

void main() {
  ProviderContainer containerFor(FakeArticleRepository repository) =>
      ProviderContainer.test(
        overrides: testOverrides(repository),
        retry: (retryCount, error) => null,
      );

  test('loads articles from the repository', () async {
    final container = containerFor(FakeArticleRepository());
    expect(
      await container.read(articlesControllerProvider.future),
      sampleArticles,
    );
  });

  test('exposes repository errors as AsyncError', () async {
    final container = containerFor(
      FakeArticleRepository(error: const NetworkException('offline')),
    );
    await expectLater(
      container.read(articlesControllerProvider.future),
      throwsA(isA<NetworkException>()),
    );
    expect(
      container.read(articlesControllerProvider).error,
      isA<NetworkException>(),
    );
  });

  test('refresh reloads and recovers from an error', () async {
    final repository = FakeArticleRepository(
      error: const NetworkException('offline'),
    );
    final container = containerFor(repository);
    container.listen(articlesControllerProvider, (_, _) {});
    await container
        .read(articlesControllerProvider.future)
        .catchError((_) => <Article>[]);

    repository.error = null;
    await container.read(articlesControllerProvider.notifier).refresh();

    expect(container.read(articlesControllerProvider).value, sampleArticles);
    expect(repository.fetchCount, 2);
  });

  test('Article.fromJson rejects unexpected shapes', () {
    expect(
      Article.fromJson({'id': 1, 'title': 'T', 'body': 'B'}),
      const Article(id: 1, title: 'T', body: 'B'),
    );
    expect(() => Article.fromJson({'id': '1'}), throwsA(isA<ParseException>()));
  });
}
