// ignore_for_file: directives_ordering

import 'package:build_runner_core/build_runner_core.dart' as _i1;
import 'package:auto_route_generator/builder.dart' as _i2;
import 'package:injectable_generator/builder.dart' as _i3;
import 'package:source_gen/builder.dart' as _i4;
import 'package:build_config/build_config.dart' as _i5;
import 'dart:isolate' as _i6;
import 'package:build_runner/build_runner.dart' as _i7;
import 'dart:io' as _i8;

final _builders = <_i1.BuilderApplication>[
  _i1.apply('auto_route_generator:autoRouteGenerator', [_i2.autoRouteGenerator],
      _i1.toDependentsOf('auto_route_generator'),
      hideOutput: false),
  _i1.apply('injectable_generator:injectable_builder', [_i3.injectableBuilder],
      _i1.toDependentsOf('injectable_generator'),
      hideOutput: true),
  _i1.apply('injectable_generator:injectable_config_builder',
      [_i3.injectableConfigBuilder], _i1.toDependentsOf('injectable_generator'),
      hideOutput: false),
  _i1.apply('source_gen:combining_builder', [_i4.combiningBuilder],
      _i1.toNoneByDefault(),
      hideOutput: false, appliesBuilders: ['source_gen:part_cleanup']),
  _i1.applyPostProcess('source_gen:part_cleanup', _i4.partCleanup,
      defaultGenerateFor: const _i5.InputSet())
];
void main(List<String> args, [_i6.SendPort sendPort]) async {
  var result = await _i7.run(args, _builders);
  sendPort?.send(result);
  _i8.exitCode = result;
}
