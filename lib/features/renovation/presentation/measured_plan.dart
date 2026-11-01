import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show NumberFormat;
import '../../../l10n/l10n.dart';
import '../domain/rectangular_room.dart';

class MeasuredPlan extends StatelessWidget {
  const MeasuredPlan({super.key, required this.room});
  final Map<String, Object?> room;
  @override
  Widget build(BuildContext context) {
    roomFromRecord(room);
    final l = context.l10n;
    final number = NumberFormat(
      '0.###',
      Localizations.localeOf(context).languageCode,
    );
    final length = room['lengthMm'] as int, width = room['widthMm'] as int;
    final openings = [
      for (final value in room['openings'] as List? ?? const [])
        RoomOpening.fromJson(Map<String, Object?>.from(value as Map)),
    ];
    final colors = Theme.of(context).colorScheme;
    final scaler = MediaQuery.textScalerOf(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 12),
        Text(l.measuredPlan, style: Theme.of(context).textTheme.titleMedium),
        LayoutBuilder(
          builder: (context, constraints) => Semantics(
            label: l.measuredPlan,
            child: SizedBox(
              width: constraints.maxWidth,
              height: math.min(constraints.maxWidth, 300) + scaler.scale(16),
              child: CustomPaint(
                painter: _RoomPlanPainter(
                  length: length,
                  width: width,
                  openings: openings,
                  outline: colors.outline,
                  accent: colors.primary,
                  fill: colors.surface,
                  text: colors.onSurface,
                  textScaler: scaler,
                  direction: Directionality.of(context),
                  fontFamily: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.fontFamily,
                ),
              ),
            ),
          ),
        ),
        Wrap(
          spacing: 16,
          runSpacing: 8,
          children: [
            Text('${l.lengthMetres}: ${number.format(length / 1000)}'),
            Text('${l.widthMetres}: ${number.format(width / 1000)}'),
          ],
        ),
        const SizedBox(height: 8),
        Text(l.measuredPlanNote),
      ],
    );
  }
}

class _RoomPlanPainter extends CustomPainter {
  _RoomPlanPainter({
    required this.length,
    required this.width,
    required this.openings,
    required this.outline,
    required this.accent,
    required this.fill,
    required this.text,
    required this.textScaler,
    required this.direction,
    this.fontFamily,
  });
  final int length, width;
  final List<RoomOpening> openings;
  final Color outline, accent, fill, text;
  final TextScaler textScaler;
  final TextDirection direction;
  final String? fontFamily;
  @override
  void paint(Canvas canvas, Size size) {
    final label = TextPainter(
      text: TextSpan(
        text: '4',
        style: TextStyle(fontSize: 14, color: text, fontFamily: fontFamily),
      ),
      textScaler: textScaler,
      textDirection: direction,
    )..layout();
    final margin = label.height + 12;
    final scale = math.min(
      math.max(1, size.width - margin * 2) / length,
      math.max(1, size.height - margin * 2) / width,
    );
    final rect = Rect.fromCenter(
      center: size.center(Offset.zero),
      width: length * scale,
      height: width * scale,
    );
    canvas.drawRect(rect, Paint()..color = fill);
    canvas.drawRect(
      rect,
      Paint()
        ..color = outline
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );
    for (final opening in openings) {
      final x = opening.geometry.xMm * scale,
          span = opening.geometry.widthMm * scale;
      final (start, end) = switch (opening.wall) {
        0 => (
          Offset(rect.left + x, rect.top),
          Offset(rect.left + x + span, rect.top),
        ),
        1 => (
          Offset(rect.right, rect.top + x),
          Offset(rect.right, rect.top + x + span),
        ),
        2 => (
          Offset(rect.right - x, rect.bottom),
          Offset(rect.right - x - span, rect.bottom),
        ),
        _ => (
          Offset(rect.left, rect.bottom - x),
          Offset(rect.left, rect.bottom - x - span),
        ),
      };
      canvas.drawLine(
        start,
        end,
        Paint()
          ..color = accent
          ..strokeWidth = 6,
      );
    }
    final centers = [
      Offset(rect.center.dx, rect.top - label.height / 2 - 6),
      Offset(rect.right + label.width / 2 + 8, rect.center.dy),
      Offset(rect.center.dx, rect.bottom + label.height / 2 + 6),
      Offset(rect.left - label.width / 2 - 8, rect.center.dy),
    ];
    for (var wall = 0; wall < 4; wall++) {
      final painter = TextPainter(
        text: TextSpan(
          text: '${wall + 1}',
          style: TextStyle(fontSize: 14, color: text, fontFamily: fontFamily),
        ),
        textScaler: textScaler,
        textDirection: direction,
      )..layout();
      painter.paint(
        canvas,
        centers[wall] - Offset(painter.width / 2, painter.height / 2),
      );
    }
  }

  @override
  bool shouldRepaint(_RoomPlanPainter old) => true;
}
