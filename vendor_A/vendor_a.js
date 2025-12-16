// Simulasi data Vendor A (Warung Legacy) - semua tipe data string
const dataVendorA = [
    {
        "kd_produk": "A001",
        "nm_brg": "Kopi Bubuk 100g",
        "hrg": "15000",
        "ket_stok": "ada"
    }
];

// Output JSON
console.log(JSON.stringify(dataVendorA, null, 4));