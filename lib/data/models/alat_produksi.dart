/// Model class untuk Alat Produksi UMKM
/// Digunakan untuk menyimpan informasi peralatan/mesin yang digunakan dalam produksi

class AlatProduksi {
  final String id;
  final String nama;
  final String jenisAlat; // 'Manual', 'Semi-Otomatis', 'Otomatis'
  final String kategori; // 'Pengolahan', 'Pengemasan', 'Tekstil', 'Kriya', 'Transportasi'
  final int jumlahUnit;
  final String? merek;

  const AlatProduksi({
    required this.id,
    required this.nama,
    required this.jenisAlat,
    required this.kategori,
    required this.jumlahUnit,
    this.merek,
  });

  /// Factory untuk membuat AlatProduksi dari Map
  factory AlatProduksi.fromMap(Map<String, dynamic> map) {
    return AlatProduksi(
      id: map['id'] as String,
      nama: map['nama'] as String,
      jenisAlat: map['jenisAlat'] as String,
      kategori: map['kategori'] as String,
      jumlahUnit: map['jumlahUnit'] as int,
      merek: map['merek'] as String?,
    );
  }

  /// Convert ke Map untuk penyimpanan
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'jenisAlat': jenisAlat,
      'kategori': kategori,
      'jumlahUnit': jumlahUnit,
      'merek': merek,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AlatProduksi && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'AlatProduksi(id: $id, nama: $nama, kategori: $kategori)';
}

/// Enum untuk jenis alat produksi
enum JenisAlatProduksi {
  manual('Manual'),
  semiOtomatis('Semi-Otomatis'),
  otomatis('Otomatis');

  final String label;
  const JenisAlatProduksi(this.label);
}

/// Enum untuk kategori alat produksi
enum KategoriAlatProduksi {
  pengolahan('Pengolahan'),
  pengemasan('Pengemasan'),
  tekstil('Tekstil'),
  kriya('Kriya'),
  transportasi('Transportasi');

  final String label;
  const KategoriAlatProduksi(this.label);
}
