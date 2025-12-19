const express = require("express");
const app = express();
const port = 3000;
const path = require("path");
const fs = require("fs");

// Helper to read JSON safely
const readJson = (filePath) => {
  try {
    const fullPath = path.join(__dirname, filePath);
    if (fs.existsSync(fullPath)) {
      const data = fs.readFileSync(fullPath, "utf8");
      return JSON.parse(data);
    }
  } catch (e) {
    console.error("Error reading file:", filePath, e);
  }
  return { error: "Data not found or invalid" };
};

// Routes for vendors
app.get("/vendor1", (req, res) => {
  res.json(readJson("vendor_A/specifikasi_data.json"));
});

app.get("/vendor2", (req, res) => {
  res.json(readJson("vendor_B/specifikasi_data.json"));
});

app.get("/vendor3", (req, res) => {
  res.json(readJson("vendor_C/specifikasi_data.json"));
});

// Route for integrator (merged data)
app.get("/integrator", (req, res) => {
  res.json(readJson("vendor_merged.json"));
});

// Main dashboard
app.get("/", (req, res) => {
  res.send(`
        <h1>Banyuwangi Market Place - Integration Dashboard</h1>
        <ul>
            <li><a href="/vendor1">Mahasiswa 1: Vendor A (Warung Legacy)</a></li>
            <li><a href="/vendor2">Mahasiswa 2: Vendor B (Distro Modern)</a></li>
            <li><a href="/vendor3">Mahasiswa 3: Vendor C (Resto & Kuliner)</a></li>
            <li><a href="/integrator">Mahasiswa 4: Lead Integrator (Merged Output)</a></li>
        </ul>
    `);
});

app.listen(port, () => {
  console.log(`Server starting...`);
  console.log(`Open http://localhost:${port} to view the dashboard`);
});
