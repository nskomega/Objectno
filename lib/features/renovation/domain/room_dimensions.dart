// Parse metres exactly into integer millimetres, accepting comma or dot.
int? parseMetresToMm(String input) {
  final value = input.trim().replaceAll(',', '.');
  if (!RegExp(r'^\d{1,4}(\.\d{1,3})?$').hasMatch(value)) return null;
  final parts = value.split('.');
  final mm =
      int.parse(parts[0]) * 1000 +
      (parts.length == 1 ? 0 : int.parse(parts[1].padRight(3, '0')));
  return mm > 0 && mm <= 1000000 ? mm : null;
}
