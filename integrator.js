const fs = require("fs");
const path = require("path");

const vendorA = require("./vendor_A/specifikasi_data.json");
const vendorB = require("./vendor_B/specifikasi_data.json");
const vendorC = require("./vendor_C/specifikasi_data.json");

console.log("Listing1:OutputJSONVendorA");
console.log(JSON.stringify(vendorA, null, 1));
console.log("Listing2:OutputJSONVendorB");
console.log(JSON.stringify(vendorB, null, 1));
console.log("Listing3:OutputJSONVendorC");
console.log(JSON.stringify(vendorC, null, 1));

function mapVendorA(item) {
  let rawPrice = parseInt(item.hrg, 10) || 0;
  // Diskon Warung: 10% discount
  let finalPrice = Math.floor(rawPrice * 0.9);

  return {
    id: String(item.kd_produk),
    nama: item.nm_brg,
    harga_final: finalPrice, // Type Safety: Integer
    status:
      item.ket_stok && String(item.ket_stok).toLowerCase() === "ada"
        ? "Tersedia"
        : "Tidak Tersedia",
    sumber: "Vendor A",
  };
}

function mapVendorB(item) {
  return {
    id: String(item.sku),
    nama: item.productName,
    harga_final: Number(item.price || 0),
    status: item.isAvailable ? "Tersedia" : "Tidak Tersedia",
    sumber: "Vendor B",
  };
}

function mapVendorC(item) {
  const base = Number((item.pricing && item.pricing.base_price) || 0);
  const tax = Number((item.pricing && item.pricing.tax) || 0);
  let totalPrice = base + tax;

  // Label Kuliner: Add (Recommended) if category is Food
  let name = (item.details && item.details.name) || "";
  if (item.details && item.details.category === "Food") {
    name += " (Recommended)";
  }

  return {
    id: String(item.id),
    nama: name,
    harga_final: Math.floor(totalPrice), // Type Safety: Integer
    status: Number(item.stock) > 0 ? "Tersedia" : "Tidak Tersedia",
    sumber: "Vendor C",
  };
}

const merged = [];
merged.push(...vendorA.map(mapVendorA));
merged.push(...vendorB.map(mapVendorB));
merged.push(...vendorC.map(mapVendorC));

const outPath = path.join(__dirname, "vendor_merged.json");
fs.writeFileSync(outPath, JSON.stringify(merged, null, 4), "utf8");
console.log("Merged data written to", outPath);
console.log("Listing4:TargetOutput(JSONFinal)");
console.log(JSON.stringify(merged, null, 4));
