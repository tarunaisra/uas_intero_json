import 'dart:convert';
import 'dart:io';

import 'src/normalizer.dart' as normalizer;

String _readOrDefault(String path, String defaultContent) {
  final f = File(path);
  if (f.existsSync()) return f.readAsStringSync();
  return defaultContent;
}

void main(List<String> args) {
  final root = Directory.current.path;
  final base = '${root}${Platform.pathSeparator}tools${Platform.pathSeparator}integrator${Platform.pathSeparator}data${Platform.pathSeparator}';

  // Default samples (from the assignment)
  const sampleA = '[{"kd_produk":"A001","nm_brg":"Kopi Bubuk 100g","hrg":"15000","ket_stok":"ada"}]';
  const sampleB = '[{"sku":"TSHIRT-001","productName":"Kaos Ijen Crater","price":75000,"isAvailable":true}]';
  const sampleC = '[{"id":501,"details":{"name":"Nasi Tempong","category":"Food"},"pricing":{"base_price":20000,"tax":2000},"stock":50}]';

  final aStr = _readOrDefault('${base}vendor_a.json', sampleA);
  final bStr = _readOrDefault('${base}vendor_b.json', sampleB);
  final cStr = _readOrDefault('${base}vendor_c.json', sampleC);

  final List<dynamic> aJson = json.decode(aStr) as List<dynamic>;
  final List<dynamic> bJson = json.decode(bStr) as List<dynamic>;
  final List<dynamic> cJson = json.decode(cStr) as List<dynamic>;

  final results = normalizer.normalizeAll(vendorA: aJson, vendorB: bJson, vendorC: cJson);

  final out = normalizer.toPrettyJson(results);
  print(out);

  // Also write to file for convenience
  try {
    final outFile = File('${root}${Platform.pathSeparator}tools${Platform.pathSeparator}integrator${Platform.pathSeparator}output.json');
    outFile.writeAsStringSync(out);
    stderr.writeln('Wrote normalized output to tools/integrator/output.json');
  } catch (e) {
    stderr.writeln('Failed to write output.json: $e');
  }
}
