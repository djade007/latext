import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latext/latext.dart';

void main() {
  testWidgets('LaTexT renders plain text correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: LaTexT(
          laTeXCode: Text('Hello, world!'),
        ),
      ),
    ));

    expect(find.textContaining('Hello, world!'), findsOneWidget);
  });

  testWidgets('LaTexT renders inline LaTeX correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: LaTexT(
          laTeXCode: Text(r'Euler: $e^{i\pi} + 1 = 0$'),
        ),
      ),
    ));

    expect(find.textContaining('Euler:'), findsOneWidget);
    expect(find.byType(Math), findsOneWidget);
  });

  testWidgets('LaTexT renders display LaTeX correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: LaTexT(
          laTeXCode: Text(r'Pythagorean theorem: $$a^2 + b^2 = c^2$$'),
        ),
      ),
    ));

    expect(find.textContaining('Pythagorean theorem:'), findsOneWidget);
    expect(find.byType(Math), findsOneWidget);
  });

  testWidgets('LaTexT handles custom delimiter correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: LaTexT(
          laTeXCode: Text(r'Area: ~(1/2)ab\sin C~'),
          delimiter: '~',
        ),
      ),
    ));

    expect(find.textContaining('Area:'), findsOneWidget);
    expect(find.byType(Math), findsOneWidget);
  });
}
