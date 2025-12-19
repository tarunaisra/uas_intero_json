// Simulasi data Vendor C (Resto & Kuliner) - struktur data kompleks dengan Nested Object
const dataVendorC = [
    {
        "id": 501,
        "details": {
            "name": "Nasi Tempong",
            "category": "Food"
        },
        "pricing": {
            "base_price": 20000,
            "tax": 2000
        },
        "stock": 50
    }
];

// Output JSON
console.log(JSON.stringify(dataVendorC, null, 4));