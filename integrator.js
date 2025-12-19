const fs = require('fs');
const path = require('path');

const vendorA = require('./vendor_A/specifikasi_data.json');
const vendorB = require('./vendor_B/specifikasi_data.json');
const vendorC = require('./vendor_C/specifikasi_data.json');

function mapVendorA(item){
    return {
        id: String(item.kd_produk),
        nama: item.nm_brg,
        harga_final: Number(parseInt(item.hrg, 10) || 0),
        status: (item.ket_stok && String(item.ket_stok).toLowerCase() === 'ada') ? 'Tersedia' : 'Tidak Tersedia',
        sumber: 'Vendor A'
    };
}

function mapVendorB(item){
    return {
        id: String(item.sku),
        nama: item.productName,
        harga_final: Number(item.price || 0),
        status: item.isAvailable ? 'Tersedia' : 'Tidak Tersedia',
        sumber: 'Vendor B'
    };
}

function mapVendorC(item){
    const base = Number((item.pricing && item.pricing.base_price) || 0);
    const tax = Number((item.pricing && item.pricing.tax) || 0);
    return {
        id: String(item.id),
        nama: (item.details && item.details.name) || '',
        harga_final: base + tax,
        status: (Number(item.stock) > 0) ? 'Tersedia' : 'Tidak Tersedia',
        sumber: 'Vendor C'
    };
}

const merged = [];
merged.push(...vendorA.map(mapVendorA));
merged.push(...vendorB.map(mapVendorB));
merged.push(...vendorC.map(mapVendorC));

const outPath = path.join(__dirname, 'vendor_merged.json');
fs.writeFileSync(outPath, JSON.stringify(merged, null, 4), 'utf8');
console.log('Merged data written to', outPath);
console.log(JSON.stringify(merged, null, 4));
