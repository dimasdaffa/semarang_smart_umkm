/// Model class untuk Bahan Baku UMKM
/// Digunakan untuk menyimpan informasi material/bahan yang digunakan dalam produksi

class BahanBaku {
  final String id;
  final String nama;
  final String kategori; // 'Pertanian', 'Peternakan', 'Perikanan', 'Tekstil', 'Mineral', 'Sintetis', 'Kayu'
  final String satuan;
  final double estimasiPenggunaan; // per bulan
  final String? sumberLokal; // Daerah asal bahan

  const BahanBaku({
    required this.id,
    required this.nama,
    required this.kategori,
    required this.satuan,
    required this.estimasiPenggunaan,
    this.sumberLokal,
  });

  /// Factory untuk membuat BahanBaku dari Map
  factory BahanBaku.fromMap(Map<String, dynamic> map) {
    return BahanBaku(
      id: map['id'] as String,
      nama: map['nama'] as String,
      kategori: map['kategori'] as String,
      satuan: map['satuan'] as String,
      estimasiPenggunaan: (map['estimasiPenggunaan'] as num).toDouble(),
      sumberLokal: map['sumberLokal'] as String?,
    );
  }

  /// Convert ke Map untuk penyimpanan
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'kategori': kategori,
      'satuan': satuan,
      'estimasiPenggunaan': estimasiPenggunaan,
      'sumberLokal': sumberLokal,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BahanBaku && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'BahanBaku(id: $id, nama: $nama, kategori: $kategori)';
}

/// Enum untuk kategori bahan baku
enum KategoriBahanBaku {
  pertanian('Pertanian'),
  peternakan('Peternakan'),
  perikanan('Perikanan'),
  tekstil('Tekstil'),
  mineral('Mineral'),
  sintetis('Sintetis'),
  kayu('Kayu');

  final String label;
  const KategoriBahanBaku(this.label);
}
