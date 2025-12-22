import 'dart:io';

import 'src/normalizer.dart' as normalizer;

void main() {
  final sampleA = [{'kd_produk': 'A001', 'nm_brg': 'Kopi Bubuk 100g', 'hrg': '15000', 'ket_stok': 'ada'}];
  final sampleB = [{'sku': 'TSHIRT-001', 'productName': 'Kaos Ijen Crater', 'price': 75000, 'isAvailable': true}];
  final sampleC = [
    {
      'id': 501,
      'details': {'name': 'Nasi Tempong', 'category': 'Food'},
      'pricing': {'base_price': 20000, 'tax': 2000},
      'stock': 50
    }
  ];

  final out = normalizer.normalizeAll(vendorA: sampleA, vendorB: sampleB, vendorC: sampleC);

  var ok = true;

  // Expect 3 items
  if (out.length != 3) {
    stderr.writeln('Expected 3 normalized items, found ${out.length}');
    ok = false;
  }

  // Vendor A check
  final a = out.firstWhere((e) => e['sumber'] == 'Vendor A', orElse: () => {});
  if (a.isEmpty) {
    stderr.writeln('Vendor A item missing');
    ok = false;
  } else {
    if (a['harga_final'] is! int) {
      stderr.writeln('Vendor A harga_final is not int');
      ok = false;
    }
    if (a['harga_final'] != 13500) {
      stderr.writeln('Vendor A discount not applied correctly, expected 13500 got ${a['harga_final']}');
      ok = false;
    }
  }

  // Vendor C check
  final c = out.firstWhere((e) => e['sumber'] == 'Vendor C', orElse: () => {});
  if (c.isEmpty) {
    stderr.writeln('Vendor C item missing');
    ok = false;
  } else {
    if (c['harga_final'] is! int) {
      stderr.writeln('Vendor C harga_final is not int');
      ok = false;
    }
    final nama = c['nama']?.toString() ?? '';
    if (!nama.endsWith('(Recommended)')) {
      stderr.writeln('Vendor C recommended label missing on name: $nama');
      ok = false;
    }
  }

  // General type checks
  for (final item in out) {
    if (item['harga_final'] is! int) {
      stderr.writeln('Item ${item['id']} harga_final is not int');
      ok = false;
    }
    if (item['status'] is! String) {
      stderr.writeln('Item ${item['id']} status is not String');
      ok = false;
    }
  }

  if (!ok) exitCode = 1;
  if (ok) {
    print('All checks passed ✅');
  }
}
