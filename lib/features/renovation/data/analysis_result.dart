import 'dart:convert';

class AnalysisFailure implements Exception {
  const AnalysisFailure(this.code);
  final String code;
}

enum WorkScope {
  wallPaint('wall_paint'),
  floorFinish('floor_finish'),
  lighting('lighting'),
  textiles('textiles');

  const WorkScope(this.value);
  final String value;
}

class AnalysisResult {
  AnalysisResult._(this.json);
  final Map<String, dynamic> json;
  Map<String, dynamic> get proposal => json['proposal'] as Map<String, dynamic>;
  bool get matches => proposal['scene_matches'] as bool;
  String get concept => proposal['concept'] as String;
  factory AnalysisResult.fromJson(Map<String, dynamic> json) {
    final p = json['proposal'];
    final scopes = json['work_scopes'];
    if (scopes is! List ||
        scopes.isEmpty ||
        scopes.length > 4 ||
        scopes.toSet().length != scopes.length ||
        scopes.any((v) => !WorkScope.values.any((scope) => scope.value == v))) {
      throw const AnalysisFailure('invalid');
    }
    if (p is! Map<String, dynamic> ||
        p['scene_matches'] is! bool ||
        p['concept'] is! String ||
        (p['concept'] as String).length > 1200 ||
        json['model'] is! String ||
        json['revision'] is! String ||
        json['prompt_version'] is! int) {
      throw const AnalysisFailure('invalid');
    }
    for (final key in [
      'observations',
      'work_steps',
      'materials',
      'questions',
      'uncertainties',
    ]) {
      final values = p[key];
      if (values is! List ||
          values.length > 8 ||
          values.any((v) => v is! String || v.length > 1200)) {
        throw const AnalysisFailure('invalid');
      }
    }
    if (p['scene_matches'] == true && (p['concept'] as String).trim().isEmpty) {
      throw const AnalysisFailure('invalid');
    }
    if (p['scene_matches'] == false &&
        ((p['work_steps'] as List).isNotEmpty ||
            (p['materials'] as List).isNotEmpty)) {
      throw const AnalysisFailure('invalid');
    }
    return AnalysisResult._(
      jsonDecode(jsonEncode(json)) as Map<String, dynamic>,
    );
  }
}
