# Functional Requirements Specification (FRS)
## SUSMAS - Semarang UMKM Smart Mapping & Analytics System

**Versi**: 2.0  
**Tanggal**: 5 Januari 2026  
**Status**: Approved

---

## 1. INFORMASI DOKUMEN

| Atribut | Detail |
|---------|--------|
| Nama Proyek | SUSMAS v2.0 |
| Disiapkan Oleh | Tim Pengembang SUSMAS |
| Tanggal Revisi | 5 Januari 2026 |
| Disetujui Oleh | Dinas Koperasi dan UMKM Semarang |

---

## 2. PENDAHULUAN

### 2.1 Tujuan Dokumen
Dokumen ini menjelaskan spesifikasi kebutuhan fungsional untuk sistem SUSMAS v2.0, termasuk fitur baru identifikasi sentra produksi.

### 2.2 Ruang Lingkup
Sistem mencakup modul Dashboard, Smart Map, Sentra Produksi, dan Input Data.

### 2.3 Definisi & Singkatan

| Istilah | Definisi |
|---------|----------|
| UMKM | Usaha Mikro, Kecil, dan Menengah |
| Sentra | Kawasan dengan UMKM karakteristik serupa |
| Clustering | Pengelompokan berdasarkan kesamaan |
| Omzet | Pendapatan kotor tahunan |

---

## 3. KEBUTUHAN FUNGSIONAL

### 3.1 Modul Dashboard (FR-DASH)

| ID | Requirement | Priority |
|----|-------------|----------|
| FR-DASH-001 | Sistem menampilkan total UMKM terdaftar | High |
| FR-DASH-002 | Sistem menampilkan total omzet | High |
| FR-DASH-003 | Sistem menampilkan grafik kategori usaha | High |
| FR-DASH-004 | Sistem menampilkan AI recommendation | High |
| FR-DASH-005 | Sistem menampilkan preview peta | Medium |
| FR-DASH-006 | Sistem menampilkan jumlah sentra teridentifikasi | High |
| FR-DASH-007 | Sistem menampilkan total UMKM dalam sentra | Medium |

### 3.2 Modul Smart Map (FR-MAP)

| ID | Requirement | Priority |
|----|-------------|----------|
| FR-MAP-001 | Sistem menampilkan peta OpenStreetMap | High |
| FR-MAP-002 | Sistem menampilkan marker UMKM | High |
| FR-MAP-003 | Marker berwarna sesuai status kesehatan | High |
| FR-MAP-004 | User dapat tap marker untuk detail | High |
| FR-MAP-005 | Sistem menampilkan zone overlay sentra | High |
| FR-MAP-006 | Sistem menampilkan legend status | Medium |
| FR-MAP-007 | Detail menampilkan bahan baku UMKM | Medium |
| FR-MAP-008 | Detail menampilkan alat produksi UMKM | Medium |

### 3.3 Modul Sentra Produksi (FR-SENTRA)

| ID | Requirement | Priority |
|----|-------------|----------|
| FR-SENTRA-001 | Sistem mengidentifikasi sentra secara otomatis | High |
| FR-SENTRA-002 | Clustering berdasarkan kesamaan bahan baku | High |
| FR-SENTRA-003 | Clustering berdasarkan kesamaan alat produksi | High |
| FR-SENTRA-004 | Clustering mempertimbangkan proximity | High |
| FR-SENTRA-005 | Sistem menampilkan daftar sentra | High |
| FR-SENTRA-006 | User dapat filter sentra berdasarkan tipe | Medium |
| FR-SENTRA-007 | User dapat search sentra | Medium |
| FR-SENTRA-008 | Sistem menampilkan statistik sentra | High |
| FR-SENTRA-009 | Sistem menampilkan daftar UMKM anggota | High |
| FR-SENTRA-010 | Sistem menampilkan rekomendasi sentra | High |
| FR-SENTRA-011 | Sistem menampilkan chart kesehatan anggota | Medium |
| FR-SENTRA-012 | Sentra memiliki tipe (Bahan/Alat/Kombinasi) | High |

### 3.4 Modul Input Data (FR-INPUT)

| ID | Requirement | Priority |
|----|-------------|----------|
| FR-INPUT-001 | User dapat input nama usaha | High |
| FR-INPUT-002 | User dapat input alamat | High |
| FR-INPUT-003 | User dapat memilih kategori usaha | High |
| FR-INPUT-004 | User dapat input estimasi omzet | High |
| FR-INPUT-005 | User dapat memilih bahan baku (multi) | High |
| FR-INPUT-006 | User dapat memilih alat produksi (multi) | High |
| FR-INPUT-007 | Sistem auto-generate lokasi GPS | Medium |
| FR-INPUT-008 | Sistem melakukan validasi form | High |
| FR-INPUT-009 | Sistem menampilkan konfirmasi sukses | Medium |
| FR-INPUT-010 | Sistem re-run analisis sentra setelah input | High |

---

## 4. KEBUTUHAN NON-FUNGSIONAL

### 4.1 Performance (NFR-PERF)

| ID | Requirement | Target |
|----|-------------|--------|
| NFR-PERF-001 | Response time halaman | < 2 detik |
| NFR-PERF-002 | Frame rate aplikasi | 60 FPS |
| NFR-PERF-003 | Waktu clustering | < 1 detik |
| NFR-PERF-004 | Memory usage | < 150 MB |

### 4.2 Usability (NFR-USE)

| ID | Requirement | Target |
|----|-------------|--------|
| NFR-USE-001 | User satisfaction score | ≥ 4.0/5.0 |
| NFR-USE-002 | Responsive design | Mobile & Web |
| NFR-USE-003 | Bahasa antarmuka | Indonesia |

### 4.3 Reliability (NFR-REL)

| ID | Requirement | Target |
|----|-------------|--------|
| NFR-REL-001 | Crash rate | < 0.5% |
| NFR-REL-002 | Data persist on restart | Yes |

---

## 5. ACCEPTANCE CRITERIA

### 5.1 Sentra Identification

| AC ID | Kriteria |
|-------|----------|
| AC-001 | Minimal 2 UMKM untuk membentuk sentra |
| AC-002 | Similarity threshold ≥ 0.4 (40%) |
| AC-003 | Max distance ≤ 10 km |
| AC-004 | Clustering selesai < 1 detik |

### 5.2 Input Form

| AC ID | Kriteria |
|-------|----------|
| AC-005 | User dapat memilih ≥ 1 bahan baku |
| AC-006 | User dapat memilih ≥ 1 alat produksi |
| AC-007 | Validasi error ditampilkan jelas |
| AC-008 | Koordinat auto-generated dalam radius Semarang |

---

## 6. USE CASE DIAGRAM

```
┌─────────────────────────────────────────────────────────────────┐
│                         SUSMAS v2.0                              │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│   ┌─────────────┐                                               │
│   │   Petugas   │◄────┐                                         │
│   │  Lapangan   │     │                                         │
│   └──────┬──────┘     │                                         │
│          │            │                                         │
│     ┌────▼────┐   ┌───┴────┐   ┌──────────┐                    │
│     │  Input  │   │  View  │   │  View    │                    │
│     │  Data   │   │  Map   │   │ Dashboard│◄────┐              │
│     │  UMKM   │   │        │   │          │     │              │
│     └─────────┘   └────────┘   └──────────┘     │              │
│                                                  │              │
│   ┌─────────────┐                               │              │
│   │  Pimpinan   │───────────────────────────────┘              │
│   │  Dinas      │                                               │
│   └──────┬──────┘                                               │
│          │                                                       │
│     ┌────▼────────┐   ┌──────────────┐                          │
│     │   View      │   │    Export    │                          │
│     │   Sentra    │   │    Report    │                          │
│     │  Produksi   │   │    (Future)  │                          │
│     └─────────────┘   └──────────────┘                          │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## 7. DATA REQUIREMENTS

### 7.1 Entity: UMKM

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| id | String | Yes | Unique identifier |
| nama | String | Yes | Nama usaha |
| kategori | String | Yes | Kategori usaha |
| omzet | Double | Yes | Omzet tahunan |
| lokasi | LatLng | Yes | Koordinat GPS |
| alamat | String | Yes | Alamat lengkap |
| bahanBakuList | List | No | Daftar bahan baku |
| alatProduksiList | List | No | Daftar alat produksi |

### 7.2 Entity: BahanBaku

| Field | Type | Required |
|-------|------|----------|
| id | String | Yes |
| nama | String | Yes |
| kategori | String | Yes |
| satuan | String | Yes |
| estimasiPenggunaan | Double | No |

### 7.3 Entity: AlatProduksi

| Field | Type | Required |
|-------|------|----------|
| id | String | Yes |
| nama | String | Yes |
| jenisAlat | String | Yes |
| kategori | String | Yes |
| jumlahUnit | Int | No |

### 7.4 Entity: SentraProduksi

| Field | Type | Required |
|-------|------|----------|
| id | String | Yes |
| nama | String | Yes |
| deskripsi | String | Yes |
| pusatLokasi | LatLng | Yes |
| radiusCoverage | Double | Yes |
| umkmIds | List<String> | Yes |
| bahanBakuUtama | List<String> | Yes |
| alatProduksiUtama | List<String> | Yes |
| tipeSentra | Enum | Yes |

---

## 8. TRACEABILITY MATRIX

| Requirement | Use Case | Test Case |
|-------------|----------|-----------|
| FR-SENTRA-001 | UC-Clustering | TC-001 |
| FR-SENTRA-002 | UC-Clustering | TC-002 |
| FR-SENTRA-003 | UC-Clustering | TC-003 |
| FR-INPUT-005 | UC-InputData | TC-010 |
| FR-INPUT-006 | UC-InputData | TC-011 |

---

## 9. APPROVAL

| Role | Nama | Tanggal | Tanda Tangan |
|------|------|---------|--------------|
| Project Manager | Dimas Daffa | 05/01/2026 | ____________ |
| Lead Developer | Ahmad Fariz | 05/01/2026 | ____________ |
| QA Engineer | Siti Aminah | 05/01/2026 | ____________ |
| Sponsor | Kepala Dinas KUMKM | _________ | ____________ |

---

*Dokumen ini merupakan bagian dari dokumentasi resmi proyek SUSMAS v2.0*
