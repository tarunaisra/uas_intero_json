import 'dart:convert';

Map<String, dynamic> normalizeVendorA(Map<String, dynamic> j) {
  final id = j['kd_produk']?.toString().trim() ?? '';
  final nama = j['nm_brg']?.toString().trim() ?? '';
  final rawPrice = j['hrg']?.toString().trim() ?? '0';
  final price = int.tryParse(rawPrice) ?? 0;
  // Diskon 10%
  final hargaFinal = (price * 0.9).round();
  final ket = j['ket_stok']?.toString().toLowerCase() ?? '';
  final status = ket.contains('ada') ? 'Tersedia' : 'Habis';

  return {
    'id': id,
    'nama': nama,
    'harga_final': hargaFinal,
    'status': status,
    'sumber': 'Vendor A',
  };
}

Map<String, dynamic> normalizeVendorB(Map<String, dynamic> j) {
  final id = j['sku']?.toString().trim() ?? '';
  final nama = j['productName']?.toString().trim() ?? '';
  final priceNum = j['price'];
  final price = (priceNum is num) ? priceNum.toInt() : int.tryParse(priceNum?.toString() ?? '0') ?? 0;
  final isAvailable = j['isAvailable'] == true;
  final status = isAvailable ? 'Tersedia' : 'Habis';

  return {
    'id': id,
    'nama': nama,
    'harga_final': price,
    'status': status,
    'sumber': 'Vendor B',
  };
}

Map<String, dynamic> normalizeVendorC(Map<String, dynamic> j) {
  final id = j['id']?.toString() ?? '';
  final details = j['details'] as Map<String, dynamic>? ?? {};
  final namaBase = details['name']?.toString().trim() ?? '';
  final category = details['category']?.toString().trim() ?? '';
  var nama = namaBase;
  if (category.toLowerCase() == 'food') {
    nama = '$namaBase (Recommended)';
  }

  final pricing = j['pricing'] as Map<String, dynamic>? ?? {};
  final basePrice = (pricing['base_price'] is num) ? (pricing['base_price'] as num).toInt() : int.tryParse(pricing['base_price']?.toString() ?? '0') ?? 0;
  final tax = (pricing['tax'] is num) ? (pricing['tax'] as num).toInt() : int.tryParse(pricing['tax']?.toString() ?? '0') ?? 0;
  final hargaFinal = basePrice + tax;

  final stock = j['stock'];
  final stockNum = (stock is num) ? stock.toInt() : int.tryParse(stock?.toString() ?? '0') ?? 0;
  final status = stockNum > 0 ? 'Tersedia' : 'Habis';

  return {
    'id': id,
    'nama': nama,
    'harga_final': hargaFinal,
    'status': status,
    'sumber': 'Vendor C',
  };
}

List<Map<String, dynamic>> normalizeAll({
  required List<dynamic> vendorA,
  required List<dynamic> vendorB,
  required List<dynamic> vendorC,
}) {
  final List<Map<String, dynamic>> results = [];
  for (final item in vendorA) {
    if (item is Map<String, dynamic>) results.add(normalizeVendorA(item));
  }
  for (final item in vendorB) {
    if (item is Map<String, dynamic>) results.add(normalizeVendorB(item));
  }
  for (final item in vendorC) {
    if (item is Map<String, dynamic>) results.add(normalizeVendorC(item));
  }
  return results;
}

String toPrettyJson(List<Map<String, dynamic>> results) => const JsonEncoder.withIndent('  ').convert(results);
