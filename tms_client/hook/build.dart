import 'package:flutter_rust_bridge_hooks/flutter_rust_bridge_hooks.dart';

// Builds and bundles the tms_infra Rust crate for native platforms (the web client uses the wasm build instead)
void main(List<String> args) async {
  await build(args, (input, output) async {
    await const FlutterRustBridgeNativeAssetsBuilder(
      assetName: 'generated/frb_generated.io.dart',
      cratePath: '../tms_infra',
    ).run(input: input, output: output);
  });
}
