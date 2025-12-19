// Simulasi data Vendor B (Distro Modern) - CamelCase, Number, Boolean
const path = require("path");

let dataVendorB;
try {
  dataVendorB = require("./specifikasi_data.json");
} catch (err) {
  dataVendorB = [
    {
      sku: "TSHIRT-001",
      productName: "Kaos Ijen Crater",
      price: 75000,
      isAvailable: true,
    },
  ];
}

// Output JSON (stringified)
console.log(JSON.stringify(dataVendorB, null, 4));
