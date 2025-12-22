Integrator for Banyuwangi Marketplace
====================================

This small Dart script demonstrates parsing JSON from three different vendor
formats and normalizing them into a single target format as required by the
UAS assignment.

Requirements
- Dart SDK (bundled with Flutter). From the `intero` project root you can run
  using the Dart executable that comes with Flutter.

Run

PowerShell (from `D:\Project\UAS PAK SEPYAN\intero`):
```powershell
dart run tools/integrator/integrator.dart
```

What it does
- Reads the sample vendor JSON files under `tools/integrator/data/` (if
  present) or falls back to built-in examples.
- Applies mapping rules and business logic:
  - Vendor A: prices are strings; apply 10% discount; ensure `harga_final` is
    an integer.
  - Vendor B: CamelCase keys; boolean availability.
  - Vendor C: nested structure; `harga_final` = base_price + tax; if
    category == "Food" append " (Recommended)" to `nama`.
- Outputs a normalized JSON array to stdout and writes `tools/integrator/output.json`.
