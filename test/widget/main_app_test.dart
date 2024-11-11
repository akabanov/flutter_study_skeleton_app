import 'package:flutter/material.dart';
import 'package:flutter_study_skeleton_app/src/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Localization', () {
    testWidgets("Shows correct english title", (tester) async {
      await tester.pumpWidget(const MainApp());

      var text = find.text('Skeleton Study App');
      expect(text, findsOne);
    });

    testWidgets("Shows correct russian title", (tester) async {
      await tester.pumpWidget(const MainApp(
        locale: Locale('ru'),
      ));

      var text = find.text('Приложение для Изучения Skeleton');
      expect(text, findsOne);
    });

    testWidgets('Shows correct greeting', (tester) async {
      await tester.pumpWidget(const MainApp());

      var text = find.text('Hello, Alex!');
      expect(text, findsOne);
    });
  });
}
