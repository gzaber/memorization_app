import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memorization_app/features/features.dart';

void main() {
  group('DeckColorPicker', () {
    testWidgets('renders containers with correct color', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DeckColorPicker(
              color: 0xffff8a80,
              onColorChanged: (color) {},
            ),
          ),
        ),
      );

      final containers =
          tester.widgetList<Container>(find.byType(Container)).toList();
      for (int i = 0; i < containers.length; i++) {
        expect(containers[i].color, Color(colors[i]));
      }
    });

    testWidgets('active container is bigger than the others', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DeckColorPicker(
              color: 0xffff8a80,
              onColorChanged: (color) {},
            ),
          ),
        ),
      );

      final containers =
          tester.widgetList<Container>(find.byType(Container)).toList();
      for (int i = 0; i < containers.length; i++) {
        if (containers[i].color == const Color(0xffff8a80)) {
          expect(containers[i].margin,
              const EdgeInsets.symmetric(horizontal: 10.0));
        } else {
          expect(containers[i].margin, const EdgeInsets.all(10.0));
        }
      }
    });

    testWidgets('changes active color when container tapped', (tester) async {
      int _color = 0xffff8a80;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DeckColorPicker(
              color: _color,
              onColorChanged: (color) {
                _color = color;
              },
            ),
          ),
        ),
      );

      final containers =
          tester.widgetList<Container>(find.byType(Container)).toList();

      await tester.tap(find.byWidget(containers[1]));
      await tester.pumpAndSettle();

      expect(containers[1].color, const Color(0xffff80ab));
      expect(_color, 0xffff80ab);
    });
  });
}
