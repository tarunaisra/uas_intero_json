import 'dart:convert';
import 'dart:io';

T _readJsonFile<T>(String path) {
  final f = File(path);
  if (!f.existsSync()) throw Exception('File not found: $path');
  final s = f.readAsStringSync();
  return json.decode(s) as T;
}

int _scoreFraction(bool ok, int points) => ok ? points : 0;

void main() {
  final root = Directory.current.path;
  final base = '${root}${Platform.pathSeparator}tools${Platform.pathSeparator}integrator${Platform.pathSeparator}';
  try {
    final a = _readJsonFile<List<dynamic>>('${base}data${Platform.pathSeparator}vendor_a.json');
    final b = _readJsonFile<List<dynamic>>('${base}data${Platform.pathSeparator}vendor_b.json');
    final c = _readJsonFile<List<dynamic>>('${base}data${Platform.pathSeparator}vendor_c.json');
    final out = _readJsonFile<List<dynamic>>('${base}output.json');

    // Basic validity
    var validityOk = true;

    // Data mapping checks
    var mappingOk = true;
    // Type safety
    var typeSafetyOk = true;
    // Business logic
    var businessOkA = true;
    var businessOkC = true;

    // Helper to find output by sumber + id
    Map<String, dynamic>? findOut(String sumber, String id) {
      for (final item in out) {
        if (item is Map<String, dynamic>) {
          if (item['sumber'] == sumber && item['id'].toString() == id) return item;
        }
      }
      return null;
    }

    // Vendor A checks
    for (final item in a) {
      if (item is! Map) continue;
      final id = item['kd_produk']?.toString() ?? '';
      final rawPrice = item['hrg']?.toString() ?? '0';
      final orig = int.tryParse(rawPrice) ?? -999999;
      final expected = (orig * 0.9).round();
      final outItem = findOut('Vendor A', id);
      if (outItem == null) mappingOk = false;
      else {
        if (outItem['harga_final'] is! int || outItem['harga_final'] != expected) businessOkA = false;
        if (outItem['status'] is! String) typeSafetyOk = false;
      }
    }

    // Vendor B checks
    for (final item in b) {
      if (item is! Map) continue;
      final id = item['sku']?.toString() ?? '';
      final price = (item['price'] is num) ? (item['price'] as num).toInt() : int.tryParse(item['price']?.toString() ?? '0') ?? 0;
      final isAvailable = item['isAvailable'] == true;
      final outItem = findOut('Vendor B', id);
      if (outItem == null) mappingOk = false;
      else {
        if (outItem['harga_final'] is! int || outItem['harga_final'] != price) typeSafetyOk = false;
        final expectedStatus = isAvailable ? 'Tersedia' : 'Habis';
        if (outItem['status'] != expectedStatus) typeSafetyOk = false;
      }
    }

    // Vendor C checks
    for (final item in c) {
      if (item is! Map) continue;
      final id = item['id']?.toString() ?? '';
      final details = item['details'] as Map<String, dynamic>? ?? {};
      final category = details['category']?.toString() ?? '';
      final pricing = item['pricing'] as Map<String, dynamic>? ?? {};
      final basePrice = (pricing['base_price'] is num) ? (pricing['base_price'] as num).toInt() : int.tryParse(pricing['base_price']?.toString() ?? '0') ?? 0;
      final tax = (pricing['tax'] is num) ? (pricing['tax'] as num).toInt() : int.tryParse(pricing['tax']?.toString() ?? '0') ?? 0;
      final expected = basePrice + tax;
      final outItem = findOut('Vendor C', id);
      if (outItem == null) mappingOk = false;
      else {
        if (outItem['harga_final'] is! int || outItem['harga_final'] != expected) businessOkC = false;
        if (category.toLowerCase() == 'food') {
          final nama = outItem['nama']?.toString() ?? '';
          if (!nama.endsWith('(Recommended)')) businessOkC = false;
        }
      }
    }

    // Type safety: ensure all harga_final ints and status string
    for (final item in out) {
      if (item is! Map) {
        typeSafetyOk = false;
        continue;
      }
      if (item['harga_final'] is! int) typeSafetyOk = false;
      if (item['status'] is! String) typeSafetyOk = false;
      final statusVal = item['status']?.toString() ?? '';
      if (!(statusVal == 'Tersedia' || statusVal == 'Habis')) typeSafetyOk = false;
    }

    // Compute rubric score
    final int validityScore = _scoreFraction(validityOk, 20);
    final int mappingScore = _scoreFraction(mappingOk, 25);
    final int typeScore = _scoreFraction(typeSafetyOk, 25);
    final int businessScore = ( _scoreFraction(businessOkA, 15) + _scoreFraction(businessOkC, 15) );
    final total = validityScore + mappingScore + typeScore + businessScore;

    print('--- Validator Report ---');
    print('Validity JSON: ${validityOk ? 'OK' : 'FAIL'} ($validityScore/20)');
    print('Data Mapping: ${mappingOk ? 'OK' : 'FAIL'} ($mappingScore/25)');
    print('Type Safety: ${typeSafetyOk ? 'OK' : 'FAIL'} ($typeScore/25)');
    print('Business Logic (Vendor A 10% discount): ${businessOkA ? 'OK' : 'FAIL'} (${ _scoreFraction(businessOkA,15) }/15)');
    print('Business Logic (Vendor C Recommended label): ${businessOkC ? 'OK' : 'FAIL'} (${ _scoreFraction(businessOkC,15) }/15)');
    print('TOTAL SCORE: $total / 100');

    // Detailed output sample
    print('\nNormalized output (preview):');
    final encoder = const JsonEncoder.withIndent('  ');
    print(encoder.convert(out));

    // Exit code non-zero if any critical check failed
    if (total < 100) {
      exitCode = 1;
    }
  } catch (e) {
    stderr.writeln('Validation failed: $e');
    exitCode = 2;
  }
}
