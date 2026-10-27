import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/error/error_view.dart';
import '../../../l10n/app_localizations.dart';
import 'articles_controller.dart';

class ArticlesPage extends ConsumerWidget {
  const ArticlesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final articles = ref.watch(articlesControllerProvider);
    final controller = ref.read(articlesControllerProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.articlesTitle),
        actions: [
          IconButton(
            tooltip: l10n.settings,
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: articles.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) =>
            ErrorView(error: error, onRetry: controller.refresh),
        data: (items) => RefreshIndicator(
          onRefresh: controller.refresh,
          child: items.isEmpty
              ? ListView(
                  children: [
                    const SizedBox(height: 120),
                    Center(child: Text(l10n.emptyArticles)),
                  ],
                )
              : ListView.separated(
                  itemCount: items.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final article = items[index];
                    return ListTile(
                      title: Text(
                        article.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        article.body,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () => context.push('/articles/${article.id}'),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
