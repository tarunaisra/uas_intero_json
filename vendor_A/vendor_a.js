// Simulasi data Vendor A (Warung Legacy) - semua tipe data string
const path = require('path');

let dataVendorA;
try {
    dataVendorA = require('./specifikasi_data.json');
} catch (err) {
    dataVendorA = [
        {
            "kd_produk": "A001",
            "nm_brg": "Kopi Bubuk 100g",
            "hrg": "15000",
            "ket_stok": "ada"
        }
    ];
}

// Output JSON (stringified)
console.log(JSON.stringify(dataVendorA, null, 4));
g