# Laporan UAS — Banyuwangi Marketplace

Program Studi: Teknologi Rekayasa Perangkat Lunak

Mata Kuliah: Interopabilitas

Dosen: Sepyan Purnama Kristanto, M.Kom.

Judul: Integrator Data Produk UMKM — Banyuwangi Marketplace

Anggota:
- Vendor A: (NIM - Nama)
- Vendor B: (NIM - Nama)
- Vendor C: (NIM - Nama)
- Integrator: (NIM - Nama)

---

## Deskripsi
Membuat layanan integrator yang membaca tiga format JSON vendor (A, B, C), menormalisasi menjadi format standar:

```json
{
  "id": "A001",
  "nama": "Kopi Bubuk 100g",
  "harga_final": 15000,
  "status": "Tersedia",
  "sumber": "Vendor A"
}
```

## Logika yang diterapkan
- Vendor A: semua nilai datang sebagai string — parse harga, berikan diskon 10% pada `harga_final`.
- Vendor B: mapping camelCase ke field standar; `isAvailable` → `status`.
- Vendor C: ambil nested `details` dan `pricing`; `harga_final = base_price + tax`; jika `category == "Food"` tambahkan ` (Recommended)` ke `nama`.
- Type safety: `harga_final` selalu Integer; `status` selalu String (`"Tersedia"` atau `"Habis"`).

## Cara menjalankan
1. Buka PowerShell di folder project `intero`:

```powershell
cd D:\Project\UAS PAK SEPYAN\intero
```

2. Jalankan integrator: (menghasilkan `tools/integrator/output.json`)

```powershell
dart run tools/integrator/integrator.dart
```

3. Jalankan validator untuk memeriksa rubrik dan mendapatkan skor otomatis:

```powershell
dart run tools/integrator/validator.dart
```

4. Untuk menjalankan dengan contoh banyak produk (disediakan):

```powershell
# ganti file data menjadi file "many" yang sudah disediakan
copy tools\integrator\data\vendor_a_many.json tools\integrator\data\vendor_a.json /Y
copy tools\integrator\data\vendor_b_many.json tools\integrator\data\vendor_b.json /Y
copy tools\integrator\data\vendor_c_many.json tools\integrator\data\vendor_c.json /Y

dart run tools/integrator/integrator.dart
dart run tools/integrator/validator.dart
```

## Bukti keluaran
- Output yang dihasilkan (potongan):

```json
[
  {
    "id": "A001",
    "nama": "Kopi Bubuk 100g",
    "harga_final": 13500,
    "status": "Tersedia",
    "sumber": "Vendor A"
  },
  {
    "id": "TSHIRT-001",
    "nama": "Kaos Ijen Crater",
    "harga_final": 75000,
    "status": "Tersedia",
    "sumber": "Vendor B"
  }
]
```

Validator memberikan hasil: **100 / 100** (lihat `tools/integrator/validator.dart` untuk rincian pemeriksaan).

---

## Lampiran
- Semua file ada di `tools/integrator/`.

Jika ingin saya buatkan PDF dari laporan ini, saya bisa mengonversi `REPORT.md` menjadi PDF jika Anda mengizinkan penggunaan `pandoc` atau ingin saya mengekspor HTML yang bisa Anda cetak ke PDF.
