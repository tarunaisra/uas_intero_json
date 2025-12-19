const express = require('express');
const fs = require('fs');
const path = require('path');

const app = express();
const PORT = 3000;

// Middleware untuk parsing JSON
app.use(express.json());

// Endpoint untuk mendapatkan data produk yang digabungkan
app.get('/api/products', (req, res) => {
    try {
        // Jalankan logika integrator untuk memastikan data terbaru
        const vendorA = require('./vendor_A/specifikasi_data.json');
        const vendorB = require('./vendor_B/specifikasi_data.json');
        const vendorC = require('./vendor_C/specifikasi_data.json');

        function mapVendorA(item){
            let harga = Number(parseInt(item.hrg, 10) || 0);
            harga = Math.floor(harga * 0.9); // Diskon 10%
            return {
                id: String(item.kd_produk),
                nama: item.nm_brg,
                harga_final: harga,
                status: (item.ket_stok && String(item.ket_stok).toLowerCase() === 'ada') ? 'Tersedia' : 'Tidak Tersedia',
                sumber: 'Vendor A'
            };
        }

        function mapVendorB(item){
            return {
                id: String(item.sku),
                nama: item.productName,
                harga_final: Math.floor(Number(item.price || 0)),
                status: item.isAvailable ? 'Tersedia' : 'Tidak Tersedia',
                sumber: 'Vendor B'
            };
        }

        function mapVendorC(item){
            const base = Number((item.pricing && item.pricing.base_price) || 0);
            const tax = Number((item.pricing && item.pricing.tax) || 0);
            let nama = (item.details && item.details.name) || '';
            if (item.details && item.details.category === 'Food') {
                nama += ' (Recommended)';
            }
            return {
                id: String(item.id),
                nama: nama,
                harga_final: Math.floor(base + tax),
                status: (Number(item.stock) > 0) ? 'Tersedia' : 'Tidak Tersedia',
                sumber: 'Vendor C'
            };
        }

        const merged = [];
        merged.push(...vendorA.map(mapVendorA));
        merged.push(...vendorB.map(mapVendorB));
        merged.push(...vendorC.map(mapVendorC));

        // Update file merged
        const outPath = path.join(__dirname, 'vendor_merged.json');
        fs.writeFileSync(outPath, JSON.stringify(merged, null, 4), 'utf8');

        // Kirim response JSON
        res.json({
            success: true,
            data: merged,
            total: merged.length
        });
    } catch (error) {
        res.status(500).json({
            success: false,
            message: 'Error processing data',
            error: error.message
        });
    }
});

// Endpoint untuk mendapatkan data dari vendor tertentu
app.get('/api/products/:vendor', (req, res) => {
    const vendor = req.params.vendor.toLowerCase();
    try {
        let data;
        if (vendor === 'a') {
            data = require('./vendor_A/specifikasi_data.json');
        } else if (vendor === 'b') {
            data = require('./vendor_B/specifikasi_data.json');
        } else if (vendor === 'c') {
            data = require('./vendor_C/specifikasi_data.json');
        } else {
            return res.status(404).json({ success: false, message: 'Vendor not found' });
        }
        res.json({ success: true, data: data });
    } catch (error) {
        res.status(500).json({ success: false, message: 'Error', error: error.message });
    }
});

app.listen(PORT, () => {
    console.log(`Server running on http://localhost:${PORT}`);
});