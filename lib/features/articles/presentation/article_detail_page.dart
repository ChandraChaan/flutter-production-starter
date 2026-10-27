import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/error/app_exception.dart';
import '../../../core/error/error_view.dart';
import '../../../l10n/app_localizations.dart';
import 'articles_controller.dart';

class ArticleDetailPage extends ConsumerWidget {
  const ArticleDetailPage({super.key, required this.id});

  /// Null when the link had an id that isn't a number.
  final int? id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final id = this.id;
    if (id == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(l10n.articleNotFound)),
      );
    }
    final article = ref.watch(articleProvider(id));
    return Scaffold(
      appBar: AppBar(title: Text(article.value?.title ?? '')),
      body: article.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => error is ServerException && error.isNotFound
            ? Center(child: Text(l10n.articleNotFound))
            : ErrorView(
                error: error,
                onRetry: () => ref.invalidate(articleProvider(id)),
              ),
        data: (article) => SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                article.title,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              Text(article.body, style: Theme.of(context).textTheme.bodyLarge),
            ],
          ),
        ),
      ),
    );
  }
}
