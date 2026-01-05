import '../models/bahan_baku.dart';
import '../models/alat_produksi.dart';

/// Katalog Bahan Baku yang tersedia untuk dipilih
/// Data referensi untuk input form dan analisis

class MockMaterialCatalog {
  /// Daftar semua bahan baku yang tersedia dalam katalog
  static const List<BahanBaku> allMaterials = [
    // PERTANIAN
    BahanBaku(
      id: 'BB001',
      nama: 'Tepung Terigu',
      kategori: 'Pertanian',
      satuan: 'kg',
      estimasiPenggunaan: 100,
      sumberLokal: 'Jawa Tengah',
    ),
    BahanBaku(
      id: 'BB002',
      nama: 'Gula Pasir',
      kategori: 'Pertanian',
      satuan: 'kg',
      estimasiPenggunaan: 50,
      sumberLokal: 'Jawa Timur',
    ),
    BahanBaku(
      id: 'BB003',
      nama: 'Beras',
      kategori: 'Pertanian',
      satuan: 'kg',
      estimasiPenggunaan: 200,
      sumberLokal: 'Demak',
    ),
    BahanBaku(
      id: 'BB004',
      nama: 'Jagung',
      kategori: 'Pertanian',
      satuan: 'kg',
      estimasiPenggunaan: 75,
      sumberLokal: 'Grobogan',
    ),
    BahanBaku(
      id: 'BB005',
      nama: 'Kelapa',
      kategori: 'Pertanian',
      satuan: 'buah',
      estimasiPenggunaan: 150,
      sumberLokal: 'Kendal',
    ),
    BahanBaku(
      id: 'BB006',
      nama: 'Kedelai',
      kategori: 'Pertanian',
      satuan: 'kg',
      estimasiPenggunaan: 80,
      sumberLokal: 'Jawa Tengah',
    ),
    BahanBaku(
      id: 'BB007',
      nama: 'Singkong',
      kategori: 'Pertanian',
      satuan: 'kg',
      estimasiPenggunaan: 120,
      sumberLokal: 'Wonogiri',
    ),

    // PETERNAKAN
    BahanBaku(
      id: 'BB008',
      nama: 'Daging Sapi',
      kategori: 'Peternakan',
      satuan: 'kg',
      estimasiPenggunaan: 30,
      sumberLokal: 'Boyolali',
    ),
    BahanBaku(
      id: 'BB009',
      nama: 'Daging Ayam',
      kategori: 'Peternakan',
      satuan: 'kg',
      estimasiPenggunaan: 50,
      sumberLokal: 'Semarang',
    ),
    BahanBaku(
      id: 'BB010',
      nama: 'Telur Ayam',
      kategori: 'Peternakan',
      satuan: 'butir',
      estimasiPenggunaan: 500,
      sumberLokal: 'Temanggung',
    ),
    BahanBaku(
      id: 'BB011',
      nama: 'Susu Segar',
      kategori: 'Peternakan',
      satuan: 'liter',
      estimasiPenggunaan: 100,
      sumberLokal: 'Boyolali',
    ),

    // PERIKANAN
    BahanBaku(
      id: 'BB012',
      nama: 'Ikan Bandeng',
      kategori: 'Perikanan',
      satuan: 'kg',
      estimasiPenggunaan: 100,
      sumberLokal: 'Demak',
    ),
    BahanBaku(
      id: 'BB013',
      nama: 'Udang',
      kategori: 'Perikanan',
      satuan: 'kg',
      estimasiPenggunaan: 30,
      sumberLokal: 'Kendal',
    ),
    BahanBaku(
      id: 'BB014',
      nama: 'Garam',
      kategori: 'Perikanan',
      satuan: 'kg',
      estimasiPenggunaan: 20,
      sumberLokal: 'Rembang',
    ),

    // TEKSTIL
    BahanBaku(
      id: 'BB015',
      nama: 'Kain Mori',
      kategori: 'Tekstil',
      satuan: 'meter',
      estimasiPenggunaan: 200,
      sumberLokal: 'Solo',
    ),
    BahanBaku(
      id: 'BB016',
      nama: 'Kain Primisima',
      kategori: 'Tekstil',
      satuan: 'meter',
      estimasiPenggunaan: 150,
      sumberLokal: 'Pekalongan',
    ),
    BahanBaku(
      id: 'BB017',
      nama: 'Lilin Batik',
      kategori: 'Tekstil',
      satuan: 'kg',
      estimasiPenggunaan: 20,
      sumberLokal: 'Semarang',
    ),
    BahanBaku(
      id: 'BB018',
      nama: 'Pewarna Alam',
      kategori: 'Tekstil',
      satuan: 'kg',
      estimasiPenggunaan: 10,
      sumberLokal: 'Jawa Tengah',
    ),
    BahanBaku(
      id: 'BB019',
      nama: 'Benang',
      kategori: 'Tekstil',
      satuan: 'gulung',
      estimasiPenggunaan: 50,
      sumberLokal: 'Bandung',
    ),

    // MINERAL
    BahanBaku(
      id: 'BB020',
      nama: 'Tanah Liat',
      kategori: 'Mineral',
      satuan: 'kg',
      estimasiPenggunaan: 300,
      sumberLokal: 'Kasongan',
    ),
    BahanBaku(
      id: 'BB021',
      nama: 'Pasir',
      kategori: 'Mineral',
      satuan: 'kg',
      estimasiPenggunaan: 200,
      sumberLokal: 'Merapi',
    ),

    // KAYU
    BahanBaku(
      id: 'BB022',
      nama: 'Kayu Jati',
      kategori: 'Kayu',
      satuan: 'kubik',
      estimasiPenggunaan: 2,
      sumberLokal: 'Jepara',
    ),
    BahanBaku(
      id: 'BB023',
      nama: 'Rotan',
      kategori: 'Kayu',
      satuan: 'batang',
      estimasiPenggunaan: 100,
      sumberLokal: 'Kalimantan',
    ),
    BahanBaku(
      id: 'BB024',
      nama: 'Bambu',
      kategori: 'Kayu',
      satuan: 'batang',
      estimasiPenggunaan: 50,
      sumberLokal: 'Magelang',
    ),

    // SINTETIS
    BahanBaku(
      id: 'BB025',
      nama: 'Pewarna Sintetis',
      kategori: 'Sintetis',
      satuan: 'liter',
      estimasiPenggunaan: 5,
      sumberLokal: 'Import',
    ),
    BahanBaku(
      id: 'BB026',
      nama: 'Minyak Goreng',
      kategori: 'Pertanian',
      satuan: 'liter',
      estimasiPenggunaan: 50,
      sumberLokal: 'Jawa Tengah',
    ),
  ];

  /// Mendapatkan bahan baku berdasarkan kategori
  static List<BahanBaku> getByKategori(String kategori) {
    return allMaterials.where((m) => m.kategori == kategori).toList();
  }

  /// Mendapatkan bahan baku berdasarkan ID
  static BahanBaku? getById(String id) {
    try {
      return allMaterials.firstWhere((m) => m.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Mendapatkan semua kategori unik
  static List<String> get allKategori {
    return allMaterials.map((m) => m.kategori).toSet().toList()..sort();
  }
}

/// Katalog Alat Produksi yang tersedia untuk dipilih

class MockEquipmentCatalog {
  /// Daftar semua alat produksi yang tersedia dalam katalog
  static const List<AlatProduksi> allEquipment = [
    // PENGOLAHAN - KULINER
    AlatProduksi(
      id: 'AP001',
      nama: 'Kompor Gas Industri',
      jenisAlat: 'Semi-Otomatis',
      kategori: 'Pengolahan',
      jumlahUnit: 2,
    ),
    AlatProduksi(
      id: 'AP002',
      nama: 'Oven Industri',
      jenisAlat: 'Semi-Otomatis',
      kategori: 'Pengolahan',
      jumlahUnit: 1,
    ),
    AlatProduksi(
      id: 'AP003',
      nama: 'Mixer Adonan',
      jenisAlat: 'Otomatis',
      kategori: 'Pengolahan',
      jumlahUnit: 1,
    ),
    AlatProduksi(
      id: 'AP004',
      nama: 'Wajan Besar',
      jenisAlat: 'Manual',
      kategori: 'Pengolahan',
      jumlahUnit: 5,
    ),
    AlatProduksi(
      id: 'AP005',
      nama: 'Mesin Penggiling',
      jenisAlat: 'Otomatis',
      kategori: 'Pengolahan',
      jumlahUnit: 1,
    ),
    AlatProduksi(
      id: 'AP006',
      nama: 'Blender Industri',
      jenisAlat: 'Otomatis',
      kategori: 'Pengolahan',
      jumlahUnit: 2,
    ),
    AlatProduksi(
      id: 'AP007',
      nama: 'Mesin Presto',
      jenisAlat: 'Semi-Otomatis',
      kategori: 'Pengolahan',
      jumlahUnit: 2,
    ),
    AlatProduksi(
      id: 'AP008',
      nama: 'Deep Fryer',
      jenisAlat: 'Semi-Otomatis',
      kategori: 'Pengolahan',
      jumlahUnit: 1,
    ),

    // PENGEMASAN
    AlatProduksi(
      id: 'AP009',
      nama: 'Mesin Sealer',
      jenisAlat: 'Manual',
      kategori: 'Pengemasan',
      jumlahUnit: 2,
    ),
    AlatProduksi(
      id: 'AP010',
      nama: 'Vacuum Sealer',
      jenisAlat: 'Semi-Otomatis',
      kategori: 'Pengemasan',
      jumlahUnit: 1,
    ),
    AlatProduksi(
      id: 'AP011',
      nama: 'Timbangan Digital',
      jenisAlat: 'Otomatis',
      kategori: 'Pengemasan',
      jumlahUnit: 2,
    ),
    AlatProduksi(
      id: 'AP012',
      nama: 'Labeling Machine',
      jenisAlat: 'Semi-Otomatis',
      kategori: 'Pengemasan',
      jumlahUnit: 1,
    ),

    // TEKSTIL
    AlatProduksi(
      id: 'AP013',
      nama: 'Canting',
      jenisAlat: 'Manual',
      kategori: 'Tekstil',
      jumlahUnit: 10,
    ),
    AlatProduksi(
      id: 'AP014',
      nama: 'Cap Batik',
      jenisAlat: 'Manual',
      kategori: 'Tekstil',
      jumlahUnit: 5,
    ),
    AlatProduksi(
      id: 'AP015',
      nama: 'Kompor Batik',
      jenisAlat: 'Manual',
      kategori: 'Tekstil',
      jumlahUnit: 3,
    ),
    AlatProduksi(
      id: 'AP016',
      nama: 'Gawangan',
      jenisAlat: 'Manual',
      kategori: 'Tekstil',
      jumlahUnit: 5,
    ),
    AlatProduksi(
      id: 'AP017',
      nama: 'Mesin Jahit',
      jenisAlat: 'Semi-Otomatis',
      kategori: 'Tekstil',
      jumlahUnit: 3,
    ),
    AlatProduksi(
      id: 'AP018',
      nama: 'Mesin Obras',
      jenisAlat: 'Semi-Otomatis',
      kategori: 'Tekstil',
      jumlahUnit: 1,
    ),

    // KRIYA
    AlatProduksi(
      id: 'AP019',
      nama: 'Pahat Kayu',
      jenisAlat: 'Manual',
      kategori: 'Kriya',
      jumlahUnit: 10,
    ),
    AlatProduksi(
      id: 'AP020',
      nama: 'Mesin Bubut Kayu',
      jenisAlat: 'Otomatis',
      kategori: 'Kriya',
      jumlahUnit: 1,
    ),
    AlatProduksi(
      id: 'AP021',
      nama: 'Gergaji Mesin',
      jenisAlat: 'Semi-Otomatis',
      kategori: 'Kriya',
      jumlahUnit: 2,
    ),
    AlatProduksi(
      id: 'AP022',
      nama: 'Amplas Mesin',
      jenisAlat: 'Semi-Otomatis',
      kategori: 'Kriya',
      jumlahUnit: 2,
    ),
    AlatProduksi(
      id: 'AP023',
      nama: 'Tungku Pembakaran',
      jenisAlat: 'Manual',
      kategori: 'Kriya',
      jumlahUnit: 1,
    ),
    AlatProduksi(
      id: 'AP024',
      nama: 'Perkakas Rotan',
      jenisAlat: 'Manual',
      kategori: 'Kriya',
      jumlahUnit: 5,
    ),

    // TRANSPORTASI
    AlatProduksi(
      id: 'AP025',
      nama: 'Gerobak',
      jenisAlat: 'Manual',
      kategori: 'Transportasi',
      jumlahUnit: 1,
    ),
    AlatProduksi(
      id: 'AP026',
      nama: 'Etalase Kaca',
      jenisAlat: 'Manual',
      kategori: 'Transportasi',
      jumlahUnit: 2,
    ),
  ];

  /// Mendapatkan alat produksi berdasarkan kategori
  static List<AlatProduksi> getByKategori(String kategori) {
    return allEquipment.where((e) => e.kategori == kategori).toList();
  }

  /// Mendapatkan alat produksi berdasarkan jenis
  static List<AlatProduksi> getByJenis(String jenis) {
    return allEquipment.where((e) => e.jenisAlat == jenis).toList();
  }

  /// Mendapatkan alat produksi berdasarkan ID
  static AlatProduksi? getById(String id) {
    try {
      return allEquipment.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Mendapatkan semua kategori unik
  static List<String> get allKategori {
    return allEquipment.map((e) => e.kategori).toSet().toList()..sort();
  }

  /// Mendapatkan semua jenis alat unik
  static List<String> get allJenis {
    return allEquipment.map((e) => e.jenisAlat).toSet().toList();
  }
}
