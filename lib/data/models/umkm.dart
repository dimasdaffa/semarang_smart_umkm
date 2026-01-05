import 'dart:math';
import 'package:latlong2/latlong.dart';
import '../models/bahan_baku.dart';
import '../models/alat_produksi.dart';

/// Model class UMKM yang sudah diperkaya dengan data produksi
/// Ini adalah enhanced version dari model Umkm original

enum UmkmStatus { mandiri, berkembang, perluBantuan }

class Umkm {
  final String id;
  final String nama;
  final String kategori;
  final double omzet;
  final LatLng lokasi;
  final String alamat;
  
  // NEW: Production Analysis Fields
  final List<BahanBaku> bahanBakuList;
  final List<AlatProduksi> alatProduksiList;
  final String? sentraId; // Sentra yang terafiliasi

  const Umkm({
    required this.id,
    required this.nama,
    required this.kategori,
    required this.omzet,
    required this.lokasi,
    required this.alamat,
    this.bahanBakuList = const [],
    this.alatProduksiList = const [],
    this.sentraId,
  });

  /// "BAU AI" Logic: Analyze Health based on Omzet
  UmkmStatus analyzeUmkmHealth() {
    if (omzet > 200000000) return UmkmStatus.mandiri;
    if (omzet >= 50000000) return UmkmStatus.berkembang;
    return UmkmStatus.perluBantuan;
  }

  String getStatusText() {
    switch (analyzeUmkmHealth()) {
      case UmkmStatus.mandiri:
        return "Mandiri";
      case UmkmStatus.berkembang:
        return "Berkembang";
      case UmkmStatus.perluBantuan:
        return "Perlu Bantuan";
    }
  }

  /// Mendapatkan kategori bahan baku yang digunakan (untuk clustering)
  Set<String> get kategoriBahanBaku {
    return bahanBakuList.map((b) => b.kategori).toSet();
  }

  /// Mendapatkan kategori alat produksi yang digunakan (untuk clustering)
  Set<String> get kategoriAlatProduksi {
    return alatProduksiList.map((a) => a.kategori).toSet();
  }

  /// Menghitung jarak ke UMKM lain dalam km
  double distanceTo(Umkm other) {
    const Distance distance = Distance();
    return distance.as(LengthUnit.Kilometer, lokasi, other.lokasi);
  }

  /// Copy with untuk immutability
  Umkm copyWith({
    String? id,
    String? nama,
    String? kategori,
    double? omzet,
    LatLng? lokasi,
    String? alamat,
    List<BahanBaku>? bahanBakuList,
    List<AlatProduksi>? alatProduksiList,
    String? sentraId,
  }) {
    return Umkm(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      kategori: kategori ?? this.kategori,
      omzet: omzet ?? this.omzet,
      lokasi: lokasi ?? this.lokasi,
      alamat: alamat ?? this.alamat,
      bahanBakuList: bahanBakuList ?? this.bahanBakuList,
      alatProduksiList: alatProduksiList ?? this.alatProduksiList,
      sentraId: sentraId ?? this.sentraId,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Umkm && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Umkm(id: $id, nama: $nama, kategori: $kategori)';
}
