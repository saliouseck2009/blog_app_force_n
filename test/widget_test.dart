// Test pour l'application Blog avec Clean Architecture
//
// Ce test vérifie que l'application se lance correctement avec la structure
// Clean Architecture et l'injection de dépendances.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:blog_app/main.dart';
import 'package:blog_app/injection_container.dart' as di;

void main() {
  setUpAll(() async {
    // Initialiser l'injection de dépendances avant les tests
    await di.init();
  });

  testWidgets('App should load and display blog list page', (
    WidgetTester tester,
  ) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Vérifier que la page principale est affichée
    expect(find.text('Bloggr'), findsOneWidget);

    // Vérifier que la barre de recherche est présente
    expect(find.text('Search blog posts'), findsOneWidget);

    // Vérifier que le floating action button est présent
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });

  testWidgets('Blog list should display loading indicator initially', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    // Vérifier que l'indicateur de chargement est affiché initialement
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
