import 'src/normalizer.dart' as normalizer;

void _assert(bool cond, String message) {
  if (!cond) {
    print('FAIL: $message');
    throw Exception(message);
  }
}

void main() {
  // Test Vendor A discount and types
  final a = [
    { 'kd_produk': 'A001', 'nm_brg': 'Kopi Bubuk 100g', 'hrg': '15000', 'ket_stok': 'ada' }
  ];
  final resA = normalizer.normalizeVendorA(a.first);
  _assert(resA['harga_final'] == 13500, 'Vendor A discount not applied or wrong');
  _assert(resA['harga_final'] is int, 'Vendor A harga_final should be int');

  // Test Vendor B mapping
  final b = [
    { 'sku': 'TSHIRT-001', 'productName': 'Kaos Ijen Crater', 'price': 75000, 'isAvailable': true }
  ];
  final resB = normalizer.normalizeVendorB(b.first);
  _assert(resB['harga_final'] == 75000, 'Vendor B price mapping failed');
  _assert(resB['status'] == 'Tersedia', 'Vendor B status mapping failed');

  // Test Vendor C recommended label and price math
  final c = [
    { 'id': 501, 'details': { 'name': 'Nasi Tempong', 'category': 'Food' }, 'pricing': { 'base_price': 20000, 'tax': 2000 }, 'stock': 50 }
  ];
  final resC = normalizer.normalizeVendorC(c.first);
  _assert(resC['harga_final'] == 22000, 'Vendor C harga_final wrong');
  _assert((resC['nama'] as String).endsWith('(Recommended)'), 'Vendor C recommended label missing');

  // Integration: multiple products
  final all = normalizer.normalizeAll(vendorA: a, vendorB: b, vendorC: c);
  _assert(all.length == 3, 'normalizeAll should produce 3 items');

  print('All tests passed.');
}
