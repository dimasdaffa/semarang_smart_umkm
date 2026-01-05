import 'package:latlong2/latlong.dart';

/// Model class untuk Sentra Produksi
/// Merepresentasikan cluster/kawasan UMKM dengan karakteristik produksi serupa

class SentraProduksi {
  final String id;
  final String nama;
  final String deskripsi;
  final LatLng pusatLokasi;
  final double radiusCoverage; // dalam km
  final List<String> umkmIds; // ID UMKM yang tergabung
  final List<String> bahanBakuUtama;
  final List<String> alatProduksiUtama;
  final TipeSentra tipeSentra;
  final int jumlahAnggota;
  final double totalOmzet;

  const SentraProduksi({
    required this.id,
    required this.nama,
    required this.deskripsi,
    required this.pusatLokasi,
    required this.radiusCoverage,
    required this.umkmIds,
    required this.bahanBakuUtama,
    required this.alatProduksiUtama,
    required this.tipeSentra,
    required this.jumlahAnggota,
    required this.totalOmzet,
  });

  /// Factory untuk membuat SentraProduksi dari Map
  factory SentraProduksi.fromMap(Map<String, dynamic> map) {
    return SentraProduksi(
      id: map['id'] as String,
      nama: map['nama'] as String,
      deskripsi: map['deskripsi'] as String,
      pusatLokasi: LatLng(
        map['pusatLat'] as double,
        map['pusatLng'] as double,
      ),
      radiusCoverage: (map['radiusCoverage'] as num).toDouble(),
      umkmIds: List<String>.from(map['umkmIds'] as List),
      bahanBakuUtama: List<String>.from(map['bahanBakuUtama'] as List),
      alatProduksiUtama: List<String>.from(map['alatProduksiUtama'] as List),
      tipeSentra: TipeSentra.values.firstWhere(
        (e) => e.name == map['tipeSentra'],
        orElse: () => TipeSentra.kombinasi,
      ),
      jumlahAnggota: map['jumlahAnggota'] as int,
      totalOmzet: (map['totalOmzet'] as num).toDouble(),
    );
  }

  /// Convert ke Map untuk penyimpanan
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'deskripsi': deskripsi,
      'pusatLat': pusatLokasi.latitude,
      'pusatLng': pusatLokasi.longitude,
      'radiusCoverage': radiusCoverage,
      'umkmIds': umkmIds,
      'bahanBakuUtama': bahanBakuUtama,
      'alatProduksiUtama': alatProduksiUtama,
      'tipeSentra': tipeSentra.name,
      'jumlahAnggota': jumlahAnggota,
      'totalOmzet': totalOmzet,
    };
  }

  /// Mendapatkan warna berdasarkan tipe sentra
  int getColorValue() {
    switch (tipeSentra) {
      case TipeSentra.bahanBaku:
        return 0xFF4CAF50; // Green
      case TipeSentra.alatProduksi:
        return 0xFF2196F3; // Blue
      case TipeSentra.kombinasi:
        return 0xFF9C27B0; // Purple
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SentraProduksi && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'SentraProduksi(id: $id, nama: $nama, anggota: $jumlahAnggota)';
}

/// Enum untuk tipe sentra produksi
enum TipeSentra {
  bahanBaku('Bahan Baku'),
  alatProduksi('Alat Produksi'),
  kombinasi('Kombinasi');

  final String label;
  const TipeSentra(this.label);
}
