import 'package:flutter/material.dart';
import 'package:flutter_production_starter/core/error/app_exception.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers.dart';

void main() {
  testWidgets('shows the list of articles', (tester) async {
    await pumpApp(tester, FakeArticleRepository());
    expect(find.text('Articles'), findsOneWidget);
    expect(find.text('First article'), findsOneWidget);
    expect(find.text('Second article'), findsOneWidget);
  });

  testWidgets('shows an empty state', (tester) async {
    await pumpApp(tester, FakeArticleRepository(articles: []));
    expect(find.text('No articles yet.'), findsOneWidget);
  });

  testWidgets('shows a friendly error and retries', (tester) async {
    final repository = FakeArticleRepository(
      error: const NetworkException('offline'),
    );
    await pumpApp(tester, repository);
    expect(
      find.text('No internet connection. Check your network and try again.'),
      findsOneWidget,
    );

    repository.error = null;
    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();
    expect(find.text('First article'), findsOneWidget);
  });

  testWidgets('opens an article', (tester) async {
    await pumpApp(tester, FakeArticleRepository());
    await tester.tap(find.text('Second article'));
    await tester.pumpAndSettle();
    expect(find.text('And the second.'), findsOneWidget);
  });

  testWidgets('switches the app to Hindi from settings', (tester) async {
    await pumpApp(tester, FakeArticleRepository());
    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();
    await tester.tap(find.text('हिन्दी'));
    await tester.pumpAndSettle();
    expect(find.text('सेटिंग्स'), findsOneWidget);

    tester.state<NavigatorState>(find.byType(Navigator).last).pop();
    await tester.pumpAndSettle();
    expect(find.text('लेख'), findsOneWidget);
  });
}
