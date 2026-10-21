// Source of web/drift_worker.js (the browser database worker). Rebuild with:
//   dart compile js -O4 tool/drift_worker.dart -o web/drift_worker.js
import 'package:drift/wasm.dart';

void main() => WasmDatabase.workerMainForOpen();
