import 'dart:convert';
import 'dart:io';
import 'package:integration_test/integration_test_driver.dart';

Future<void> main() => integrationDriver(
  timeout: const Duration(minutes: 5),
  responseDataCallback: (data) async {
    if (data != null) {
      final directory = Directory('output/integration');
      await directory.create(recursive: true);
      for (final screenshot in data['screenshots'] as List? ?? []) {
        final value = screenshot as Map;
        final name = value['screenshotName'] as String;
        if (!RegExp(r'^[a-zA-Z0-9_-]+$').hasMatch(name)) {
          throw StateError('Invalid screenshot name');
        }
        await File.fromUri(
          directory.uri.resolve('$name.png'),
        ).writeAsBytes((value['bytes'] as List).cast<int>());
      }
      final summary = Map<String, dynamic>.from(data)..remove('screenshots');
      await File.fromUri(
        directory.uri.resolve('native-result.json'),
      ).writeAsString(jsonEncode(summary));
    }
  },
);
