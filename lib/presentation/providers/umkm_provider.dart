import 'package:flutter/foundation.dart';
import '../../data/models/umkm.dart';
import '../../data/models/bahan_baku.dart';
import '../../data/models/alat_produksi.dart';
import '../../data/mock/mock_umkm_data.dart';

/// Provider untuk mengelola state UMKM
/// Enhanced version dengan dukungan bahan baku dan alat produksi

class UmkmProvider extends ChangeNotifier {
  List<Umkm> _umkmList = [];
  bool _isInitialized = false;

  UmkmProvider() {
    _initializeData();
  }

  void _initializeData() {
    if (!_isInitialized) {
      _umkmList = List.from(MockUmkmData.allUmkm);
      _isInitialized = true;
    }
  }

  List<Umkm> get umkmList => _umkmList;

  /// Menambahkan UMKM baru
  void addUmkm(Umkm umkm) {
    _umkmList.add(umkm);
    notifyListeners();
  }

  /// Update UMKM yang sudah ada
  void updateUmkm(Umkm updatedUmkm) {
    final index = _umkmList.indexWhere((u) => u.id == updatedUmkm.id);
    if (index != -1) {
      _umkmList[index] = updatedUmkm;
      notifyListeners();
    }
  }

  /// Hapus UMKM
  void removeUmkm(String id) {
    _umkmList.removeWhere((u) => u.id == id);
    notifyListeners();
  }

  /// Mendapatkan UMKM berdasarkan ID
  Umkm? getById(String id) {
    try {
      return _umkmList.firstWhere((u) => u.id == id);
    } catch (_) {
      return null;
    }
  }

  // ==================== STATS ====================

  /// Total omzet semua UMKM
  double get totalOmzet => _umkmList.fold(0, (sum, item) => sum + item.omzet);
  
  /// Total jumlah UMKM
  int get totalUmkm => _umkmList.length;

  /// Hitungan per kategori
  Map<String, int> get categoryCounts {
    final map = <String, int>{};
    for (var u in _umkmList) {
      map[u.kategori] = (map[u.kategori] ?? 0) + 1;
    }
    return map;
  }

  /// Hitungan per status kesehatan
  Map<UmkmStatus, int> get statusCounts {
    final map = <UmkmStatus, int>{};
    for (var u in _umkmList) {
      final status = u.analyzeUmkmHealth();
      map[status] = (map[status] ?? 0) + 1;
    }
    return map;
  }

  /// UMKM yang perlu bantuan
  List<Umkm> get umkmPerluBantuan {
    return _umkmList.where(
      (u) => u.analyzeUmkmHealth() == UmkmStatus.perluBantuan
    ).toList();
  }

  /// UMKM mandiri
  List<Umkm> get umkmMandiri {
    return _umkmList.where(
      (u) => u.analyzeUmkmHealth() == UmkmStatus.mandiri
    ).toList();
  }

  // ==================== PRODUCTION ANALYSIS ====================

  /// Mendapatkan semua bahan baku yang digunakan
  Set<BahanBaku> get allUsedMaterials {
    final materials = <BahanBaku>{};
    for (var umkm in _umkmList) {
      materials.addAll(umkm.bahanBakuList);
    }
    return materials;
  }

  /// Mendapatkan semua alat produksi yang digunakan
  Set<AlatProduksi> get allUsedEquipment {
    final equipment = <AlatProduksi>{};
    for (var umkm in _umkmList) {
      equipment.addAll(umkm.alatProduksiList);
    }
    return equipment;
  }

  /// Hitungan penggunaan bahan baku
  Map<String, int> get materialUsageCounts {
    final map = <String, int>{};
    for (var umkm in _umkmList) {
      for (var bahan in umkm.bahanBakuList) {
        map[bahan.nama] = (map[bahan.nama] ?? 0) + 1;
      }
    }
    return map;
  }

  /// Hitungan penggunaan alat produksi
  Map<String, int> get equipmentUsageCounts {
    final map = <String, int>{};
    for (var umkm in _umkmList) {
      for (var alat in umkm.alatProduksiList) {
        map[alat.nama] = (map[alat.nama] ?? 0) + 1;
      }
    }
    return map;
  }

  /// UMKM berdasarkan kategori bahan baku
  List<Umkm> getByMaterialCategory(String kategori) {
    return _umkmList.where((u) => 
      u.bahanBakuList.any((b) => b.kategori == kategori)
    ).toList();
  }

  /// UMKM berdasarkan kategori alat produksi
  List<Umkm> getByEquipmentCategory(String kategori) {
    return _umkmList.where((u) => 
      u.alatProduksiList.any((a) => a.kategori == kategori)
    ).toList();
  }
}
