import 'package:flutter_test/flutter_test.dart';
import 'package:objectno/features/renovation/domain/room_dimensions.dart';

void main() {
  test(
    'metres parse exactly without floating point, comma and dot accepted',
    () {
      expect(parseMetresToMm(' 2,705 '), 2705);
      expect(parseMetresToMm('3.01'), 3010);
      expect(parseMetresToMm('0.001'), 1);
      expect(parseMetresToMm('1000'), 1000000);
      for (final value in [
        '',
        '0',
        '-1',
        'NaN',
        '1e3',
        '2.0001',
        '1000.001',
        '1,2.3',
      ]) {
        expect(parseMetresToMm(value), isNull, reason: value);
      }
    },
  );
}
