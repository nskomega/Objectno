import 'package:flutter/services.dart';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:objectno/design_system/theme/objectno_theme.dart';
import 'package:objectno/l10n/l10n.dart';
import 'package:objectno/features/renovation/presentation/measured_plan.dart';

void main() {
  for (final brightness in Brightness.values) {
    testWidgets(
      'measured plan renders wall labels and openings at 3x $brightness',
      (tester) async {
        tester.view.physicalSize = const Size(375, 1000);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final key = GlobalKey();
        final render = Platform.environment['OBJECTNO_RENDER_PREVIEWS'] == '1';
        if (render) {
          await tester.runAsync(() async {
            final font = File('/System/Library/Fonts/Supplemental/Arial.ttf');
            if (await font.exists()) {
              final loader = FontLoader('VisualTestFont')
                ..addFont(
                  Future.value(ByteData.sublistView(await font.readAsBytes())),
                );
              await loader.load();
            }
          });
        }
        final theme = objectnoTheme(brightness);
        await tester.pumpWidget(
          MaterialApp(
            theme: render
                ? theme.copyWith(
                    textTheme: theme.textTheme.apply(
                      fontFamily: 'VisualTestFont',
                    ),
                  )
                : theme,
            locale: const Locale('ru'),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(textScaler: TextScaler.linear(3)),
              child: child!,
            ),
            home: Scaffold(
              body: SingleChildScrollView(
                child: RepaintBoundary(
                  key: key,
                  child: ColoredBox(
                    color: theme.scaffoldBackgroundColor,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: MeasuredPlan(
                        room: {
                          'kind': 'bedroom',
                          'lengthMm': 4000,
                          'widthMm': 3000,
                          'heightMm': 2500,
                          'openings': [
                            {
                              'wall': 0,
                              'xMm': 500,
                              'yMm': 0,
                              'widthMm': 800,
                              'heightMm': 2000,
                            },
                            {
                              'wall': 2,
                              'xMm': 1000,
                              'yMm': 1000,
                              'widthMm': 1500,
                              'heightMm': 1200,
                            },
                          ],
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.text('Длина, м: 4'), findsOneWidget);
        expect(find.text('Ширина, м: 3'), findsOneWidget);
        expect(tester.takeException(), isNull);
        if (render) {
          final boundary =
              key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
          await tester.runAsync(() async {
            final image = await boundary.toImage();
            final bytes = await image.toByteData(
              format: ui.ImageByteFormat.png,
            );
            final dir = Directory('output/preview');
            await dir.create(recursive: true);
            await File(
              '${dir.path}/measured-plan-${brightness.name}-3x.png',
            ).writeAsBytes(bytes!.buffer.asUint8List());
            image.dispose();
          });
        }
      },
    );
  }
}
