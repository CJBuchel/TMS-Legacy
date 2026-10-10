import 'dart:io';

import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated_io.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tms/generated/frb_generated.dart';
import 'package:tms/generated/infra/database_schemas/team.dart';
import 'package:tms/generated/infra/fll_infra/fll_blueprint_map.dart';
import 'package:tms/generated/infra/fll_infra/question.dart';

// Exercises the Rust bridge natively (the web client goes through wasm instead).
// Needs the host library, build it first with: cargo build -p tms_infra --release
String? _hostLibraryPath() {
  final name = Platform.isWindows
      ? 'tms_infra.dll'
      : Platform.isMacOS
          ? 'libtms_infra.dylib'
          : 'libtms_infra.so';
  final file = File('../target/release/$name');
  return file.existsSync() ? file.absolute.path : null;
}

List<QuestionAnswer> _defaultAnswers(String season) {
  final blueprint = FllBlueprintMap.getFllBlueprint(season: season)!;
  return blueprint.robotGameQuestions.map((q) {
    return q.input.when(
      categorical: (input) => QuestionAnswer(questionId: q.id, answer: input.defaultOption),
    );
  }).toList();
}

void main() {
  final library = _hostLibraryPath();
  final skip = library == null ? 'host library not built (cargo build -p tms_infra --release)' : null;

  setUpAll(() async {
    if (library != null) {
      await TmsRustLib.init(externalLibrary: ExternalLibrary.open(library));
    }
  });

  test('seasons include both 2026 games', () {
    final seasons = FllBlueprintMap.getSeasons();
    expect(seasons, containsAll(['2025', '2026-Founders', '2026-Future']));
  }, skip: skip);

  test('default answers score and validate', () {
    for (final entry in {'2026-Founders': 70, '2026-Future': 0, '2025': 60}.entries) {
      final blueprint = FllBlueprintMap.getFllBlueprint(season: entry.key)!;
      final answers = _defaultAnswers(entry.key);
      expect(FllBlueprintMap.calculateScore(blueprint: blueprint, answers: answers), entry.value, reason: entry.key);
      expect(FllBlueprintMap.validate(season: entry.key, answers: answers), isEmpty, reason: entry.key);
    }
  }, skip: skip);

  test('2026 missions point at bundled images', () {
    for (final season in ['2026-Founders', '2026-Future']) {
      final blueprint = FllBlueprintMap.getFllBlueprint(season: season)!;
      for (final mission in blueprint.robotGameMissions) {
        expect(File(mission.imageUrl!).existsSync(), isTrue, reason: '$season ${mission.id}');
      }
    }
  }, skip: skip);

  test('json round trips through the bridge', () {
    const team = Team(teamNumber: '1001', name: 'Test Team', affiliation: 'Test', ranking: 3);
    expect(Team.fromJsonString(json: team.toJsonString()), team);
    // malformed data falls back to the default rather than throwing
    expect(Team.fromJsonString(json: 'not json'), Team.default_());
  }, skip: skip);
}
