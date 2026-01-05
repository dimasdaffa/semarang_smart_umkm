import 'package:latlong2/latlong.dart';
import '../models/umkm.dart';
import '../models/bahan_baku.dart';
import '../models/alat_produksi.dart';
import 'mock_catalogs.dart';

/// Mock data UMKM yang sudah diperkaya dengan bahan baku dan alat produksi
/// Data ini digunakan untuk demo dan testing fitur analisis sentra

class MockUmkmData {
  static List<Umkm> get allUmkm => [
    // KULINER - LUMPIA & OLAHAN TEPUNG (Cluster 1)
    Umkm(
      id: '1',
      nama: "Lumpia Gang Lombok",
      kategori: "Kuliner",
      omzet: 150000000,
      lokasi: const LatLng(-6.9744, 110.4263),
      alamat: "Gg. Lombok No.11, Purwodinatan",
      bahanBakuList: [
        MockMaterialCatalog.getById('BB001')!, // Tepung Terigu
        MockMaterialCatalog.getById('BB010')!, // Telur Ayam
        MockMaterialCatalog.getById('BB026')!, // Minyak Goreng
        MockMaterialCatalog.getById('BB009')!, // Daging Ayam
      ],
      alatProduksiList: [
        MockEquipmentCatalog.getById('AP004')!, // Wajan Besar
        MockEquipmentCatalog.getById('AP001')!, // Kompor Gas
        MockEquipmentCatalog.getById('AP008')!, // Deep Fryer
        MockEquipmentCatalog.getById('AP009')!, // Mesin Sealer
      ],
    ),
    Umkm(
      id: '2',
      nama: "Bandeng Juwana Elrina",
      kategori: "Oleh-oleh",
      omzet: 500000000,
      lokasi: const LatLng(-6.9890, 110.4100),
      alamat: "Jl. Pandanaran No.57",
      bahanBakuList: [
        MockMaterialCatalog.getById('BB012')!, // Ikan Bandeng
        MockMaterialCatalog.getById('BB014')!, // Garam
        MockMaterialCatalog.getById('BB026')!, // Minyak Goreng
      ],
      alatProduksiList: [
        MockEquipmentCatalog.getById('AP007')!, // Mesin Presto
        MockEquipmentCatalog.getById('AP001')!, // Kompor Gas
        MockEquipmentCatalog.getById('AP010')!, // Vacuum Sealer
        MockEquipmentCatalog.getById('AP011')!, // Timbangan Digital
      ],
    ),
    Umkm(
      id: '3',
      nama: "Soto Bangkong",
      kategori: "Kuliner",
      omzet: 250000000,
      lokasi: const LatLng(-6.9961, 110.4300),
      alamat: "Jl. Bridjen Katamso",
      bahanBakuList: [
        MockMaterialCatalog.getById('BB009')!, // Daging Ayam
        MockMaterialCatalog.getById('BB003')!, // Beras
        MockMaterialCatalog.getById('BB010')!, // Telur Ayam
        MockMaterialCatalog.getById('BB005')!, // Kelapa
      ],
      alatProduksiList: [
        MockEquipmentCatalog.getById('AP001')!, // Kompor Gas
        MockEquipmentCatalog.getById('AP004')!, // Wajan Besar
        MockEquipmentCatalog.getById('AP025')!, // Gerobak
      ],
    ),
    Umkm(
      id: '4',
      nama: "Tahu Bakso Ungaran (Cabang Kota)",
      kategori: "Oleh-oleh",
      omzet: 45000000, // Perlu Bantuan
      lokasi: const LatLng(-7.0000, 110.4200),
      alamat: "Sekitar Simpang Lima",
      bahanBakuList: [
        MockMaterialCatalog.getById('BB006')!, // Kedelai
        MockMaterialCatalog.getById('BB008')!, // Daging Sapi
        MockMaterialCatalog.getById('BB001')!, // Tepung Terigu
      ],
      alatProduksiList: [
        MockEquipmentCatalog.getById('AP005')!, // Mesin Penggiling
        MockEquipmentCatalog.getById('AP001')!, // Kompor Gas
        MockEquipmentCatalog.getById('AP004')!, // Wajan Besar
      ],
    ),

    // BATIK (Cluster 2)
    Umkm(
      id: '5',
      nama: "Batik Semarang Indah",
      kategori: "Fashion",
      omzet: 80000000,
      lokasi: const LatLng(-6.9800, 110.4350),
      alamat: "Kawasan Kota Lama",
      bahanBakuList: [
        MockMaterialCatalog.getById('BB015')!, // Kain Mori
        MockMaterialCatalog.getById('BB017')!, // Lilin Batik
        MockMaterialCatalog.getById('BB018')!, // Pewarna Alam
      ],
      alatProduksiList: [
        MockEquipmentCatalog.getById('AP013')!, // Canting
        MockEquipmentCatalog.getById('AP014')!, // Cap Batik
        MockEquipmentCatalog.getById('AP015')!, // Kompor Batik
        MockEquipmentCatalog.getById('AP016')!, // Gawangan
      ],
    ),
    Umkm(
      id: '11',
      nama: "Batik Semarang 16",
      kategori: "Fashion",
      omzet: 120000000,
      lokasi: const LatLng(-6.9820, 110.4380),
      alamat: "Jl. Tugu Muda Area",
      bahanBakuList: [
        MockMaterialCatalog.getById('BB015')!, // Kain Mori
        MockMaterialCatalog.getById('BB017')!, // Lilin Batik
        MockMaterialCatalog.getById('BB025')!, // Pewarna Sintetis
        MockMaterialCatalog.getById('BB019')!, // Benang
      ],
      alatProduksiList: [
        MockEquipmentCatalog.getById('AP013')!, // Canting
        MockEquipmentCatalog.getById('AP015')!, // Kompor Batik
        MockEquipmentCatalog.getById('AP016')!, // Gawangan
        MockEquipmentCatalog.getById('AP017')!, // Mesin Jahit
      ],
    ),
    Umkm(
      id: '12',
      nama: "Rumah Batik Kota Lama",
      kategori: "Fashion",
      omzet: 95000000,
      lokasi: const LatLng(-6.9785, 110.4320),
      alamat: "Kawasan Heritage Kota Lama",
      bahanBakuList: [
        MockMaterialCatalog.getById('BB016')!, // Kain Primisima
        MockMaterialCatalog.getById('BB017')!, // Lilin Batik
        MockMaterialCatalog.getById('BB018')!, // Pewarna Alam
      ],
      alatProduksiList: [
        MockEquipmentCatalog.getById('AP013')!, // Canting
        MockEquipmentCatalog.getById('AP014')!, // Cap Batik
        MockEquipmentCatalog.getById('AP015')!, // Kompor Batik
      ],
    ),

    // KRIYA (Cluster 3)
    Umkm(
      id: '6',
      nama: "Warung Makan Mbok Berek",
      kategori: "Kuliner",
      omzet: 30000000, // Perlu Bantuan
      lokasi: const LatLng(-6.9850, 110.4000),
      alamat: "Jl. Jendral Sudirman",
      bahanBakuList: [
        MockMaterialCatalog.getById('BB009')!, // Daging Ayam
        MockMaterialCatalog.getById('BB003')!, // Beras
        MockMaterialCatalog.getById('BB026')!, // Minyak Goreng
      ],
      alatProduksiList: [
        MockEquipmentCatalog.getById('AP001')!, // Kompor Gas
        MockEquipmentCatalog.getById('AP004')!, // Wajan Besar
        MockEquipmentCatalog.getById('AP026')!, // Etalase Kaca
      ],
    ),
    Umkm(
      id: '7',
      nama: "Kerajinan Rotan Khas",
      kategori: "Kriya",
      omzet: 60000000,
      lokasi: const LatLng(-6.9920, 110.4150),
      alamat: "Dekat Tugu Muda",
      bahanBakuList: [
        MockMaterialCatalog.getById('BB023')!, // Rotan
        MockMaterialCatalog.getById('BB024')!, // Bambu
      ],
      alatProduksiList: [
        MockEquipmentCatalog.getById('AP024')!, // Perkakas Rotan
        MockEquipmentCatalog.getById('AP019')!, // Pahat Kayu
      ],
    ),
    Umkm(
      id: '13',
      nama: "Kerajinan Bambu Kreatif",
      kategori: "Kriya",
      omzet: 55000000,
      lokasi: const LatLng(-6.9935, 110.4170),
      alamat: "Jl. Sisingamangaraja",
      bahanBakuList: [
        MockMaterialCatalog.getById('BB024')!, // Bambu
        MockMaterialCatalog.getById('BB023')!, // Rotan
      ],
      alatProduksiList: [
        MockEquipmentCatalog.getById('AP019')!, // Pahat Kayu
        MockEquipmentCatalog.getById('AP022')!, // Amplas Mesin
        MockEquipmentCatalog.getById('AP024')!, // Perkakas Rotan
      ],
    ),

    // OLEH-OLEH & WINGKO (Cluster 4)
    Umkm(
      id: '8',
      nama: "Wingko Babat Kereta Api",
      kategori: "Oleh-oleh",
      omzet: 220000000,
      lokasi: const LatLng(-6.9680, 110.4230),
      alamat: "Stasiun Tawang Area",
      bahanBakuList: [
        MockMaterialCatalog.getById('BB005')!, // Kelapa
        MockMaterialCatalog.getById('BB002')!, // Gula Pasir
        MockMaterialCatalog.getById('BB001')!, // Tepung Terigu
      ],
      alatProduksiList: [
        MockEquipmentCatalog.getById('AP002')!, // Oven Industri
        MockEquipmentCatalog.getById('AP003')!, // Mixer Adonan
        MockEquipmentCatalog.getById('AP009')!, // Mesin Sealer
        MockEquipmentCatalog.getById('AP012')!, // Labeling Machine
      ],
    ),
    Umkm(
      id: '14',
      nama: "Wingko MM Authentic",
      kategori: "Oleh-oleh",
      omzet: 180000000,
      lokasi: const LatLng(-6.9695, 110.4250),
      alamat: "Kawasan Stasiun Tawang",
      bahanBakuList: [
        MockMaterialCatalog.getById('BB005')!, // Kelapa
        MockMaterialCatalog.getById('BB002')!, // Gula Pasir
        MockMaterialCatalog.getById('BB003')!, // Beras (tepung ketan)
      ],
      alatProduksiList: [
        MockEquipmentCatalog.getById('AP002')!, // Oven Industri
        MockEquipmentCatalog.getById('AP003')!, // Mixer Adonan
        MockEquipmentCatalog.getById('AP010')!, // Vacuum Sealer
      ],
    ),

    // KOPI & MINUMAN
    Umkm(
      id: '9',
      nama: "Kopi Banaran Point",
      kategori: "Kuliner",
      omzet: 180000000,
      lokasi: const LatLng(-6.9900, 110.4050),
      alamat: "Jl. Pemuda",
      bahanBakuList: [
        MockMaterialCatalog.getById('BB011')!, // Susu Segar
        MockMaterialCatalog.getById('BB002')!, // Gula Pasir
      ],
      alatProduksiList: [
        MockEquipmentCatalog.getById('AP006')!, // Blender Industri
        MockEquipmentCatalog.getById('AP001')!, // Kompor Gas
      ],
    ),

    // FASHION LAINNYA
    Umkm(
      id: '10',
      nama: "Souvenir Kaos Semarang",
      kategori: "Fashion",
      omzet: 40000000, // Perlu Bantuan
      lokasi: const LatLng(-6.9950, 110.4250),
      alamat: "Simpang Lima Area Plaza",
      bahanBakuList: [
        MockMaterialCatalog.getById('BB019')!, // Benang
        MockMaterialCatalog.getById('BB025')!, // Pewarna Sintetis
      ],
      alatProduksiList: [
        MockEquipmentCatalog.getById('AP017')!, // Mesin Jahit
        MockEquipmentCatalog.getById('AP018')!, // Mesin Obras
      ],
    ),

    // TAMBAHAN UNTUK MEMPERKAYA DATA CLUSTERING
    Umkm(
      id: '15',
      nama: "Mebel Jati Semarang",
      kategori: "Kriya",
      omzet: 350000000,
      lokasi: const LatLng(-6.9940, 110.4180),
      alamat: "Jl. Kaligawe",
      bahanBakuList: [
        MockMaterialCatalog.getById('BB022')!, // Kayu Jati
        MockMaterialCatalog.getById('BB024')!, // Bambu
      ],
      alatProduksiList: [
        MockEquipmentCatalog.getById('AP020')!, // Mesin Bubut Kayu
        MockEquipmentCatalog.getById('AP021')!, // Gergaji Mesin
        MockEquipmentCatalog.getById('AP022')!, // Amplas Mesin
        MockEquipmentCatalog.getById('AP019')!, // Pahat Kayu
      ],
    ),
    Umkm(
      id: '16',
      nama: "Gerabah Seni Semarang",
      kategori: "Kriya",
      omzet: 48000000,
      lokasi: const LatLng(-6.9960, 110.4190),
      alamat: "Jl. Pedurungan",
      bahanBakuList: [
        MockMaterialCatalog.getById('BB020')!, // Tanah Liat
        MockMaterialCatalog.getById('BB021')!, // Pasir
      ],
      alatProduksiList: [
        MockEquipmentCatalog.getById('AP023')!, // Tungku Pembakaran
        MockEquipmentCatalog.getById('AP019')!, // Pahat Kayu
      ],
    ),
  ];

  /// Mendapatkan UMKM berdasarkan kategori
  static List<Umkm> getByKategori(String kategori) {
    return allUmkm.where((u) => u.kategori == kategori).toList();
  }

  /// Mendapatkan UMKM berdasarkan status kesehatan
  static List<Umkm> getByStatus(UmkmStatus status) {
    return allUmkm.where((u) => u.analyzeUmkmHealth() == status).toList();
  }

  /// Mendapatkan UMKM yang menggunakan bahan baku tertentu
  static List<Umkm> getByBahanBaku(String bahanBakuId) {
    return allUmkm.where((u) => 
      u.bahanBakuList.any((b) => b.id == bahanBakuId)
    ).toList();
  }

  /// Mendapatkan UMKM yang menggunakan alat produksi tertentu
  static List<Umkm> getByAlatProduksi(String alatProduksiId) {
    return allUmkm.where((u) => 
      u.alatProduksiList.any((a) => a.id == alatProduksiId)
    ).toList();
  }
}
