import 'package:flutter/foundation.dart';
import '../../data/models/sentra_produksi.dart';
import '../../data/models/umkm.dart';
import '../../services/sentra_identification_service.dart';

/// Provider untuk mengelola state Sentra Produksi
/// Menggunakan SentraIdentificationService untuk clustering

class SentraProvider extends ChangeNotifier {
  final SentraIdentificationService _sentraService = SentraIdentificationService();
  
  List<SentraProduksi> _sentraList = [];
  SentraProduksi? _selectedSentra;
  bool _isAnalyzing = false;
  String? _error;

  // Konfigurasi clustering
  double _similarityThreshold = 0.4;
  double _maxDistanceKm = 10.0;

  List<SentraProduksi> get sentraList => _sentraList;
  SentraProduksi? get selectedSentra => _selectedSentra;
  bool get isAnalyzing => _isAnalyzing;
  String? get error => _error;
  double get similarityThreshold => _similarityThreshold;
  double get maxDistanceKm => _maxDistanceKm;

  /// Jalankan analisis clustering untuk mengidentifikasi sentra
  Future<void> analyzeAndGenerateSentra(List<Umkm> umkmList) async {
    _isAnalyzing = true;
    _error = null;
    notifyListeners();

    try {
      // Simulasi proses yang memerlukan waktu
      await Future.delayed(const Duration(milliseconds: 500));

      _sentraList = _sentraService.generateSentraList(
        umkmList: umkmList,
        similarityThreshold: _similarityThreshold,
        maxDistanceKm: _maxDistanceKm,
      );

      _isAnalyzing = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isAnalyzing = false;
      notifyListeners();
    }
  }

  /// Update konfigurasi dan re-analyze
  void updateConfiguration({
    double? similarityThreshold,
    double? maxDistanceKm,
    List<Umkm>? umkmList,
  }) {
    bool needReanalyze = false;

    if (similarityThreshold != null && similarityThreshold != _similarityThreshold) {
      _similarityThreshold = similarityThreshold;
      needReanalyze = true;
    }

    if (maxDistanceKm != null && maxDistanceKm != _maxDistanceKm) {
      _maxDistanceKm = maxDistanceKm;
      needReanalyze = true;
    }

    if (needReanalyze && umkmList != null) {
      analyzeAndGenerateSentra(umkmList);
    }
  }

  /// Pilih sentra untuk detail view
  void selectSentra(SentraProduksi? sentra) {
    _selectedSentra = sentra;
    notifyListeners();
  }

  /// Hapus selection
  void clearSelection() {
    _selectedSentra = null;
    notifyListeners();
  }

  /// Mendapatkan sentra berdasarkan ID
  SentraProduksi? getSentraById(String id) {
    try {
      return _sentraList.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Mendapatkan sentra yang memiliki UMKM tertentu
  SentraProduksi? getSentraByUmkmId(String umkmId) {
    try {
      return _sentraList.firstWhere(
        (s) => s.umkmIds.contains(umkmId)
      );
    } catch (_) {
      return null;
    }
  }

  /// Mendapatkan rekomendasi untuk sentra tertentu
  List<String> getRecommendations(SentraProduksi sentra, List<Umkm> allUmkm) {
    return _sentraService.getRecommendations(sentra, allUmkm);
  }

  // ==================== STATS ====================

  /// Total jumlah sentra
  int get totalSentra => _sentraList.length;

  /// Total UMKM yang tergabung dalam sentra
  int get totalUmkmInSentra {
    return _sentraList.fold<int>(0, (sum, s) => sum + s.jumlahAnggota);
  }

  /// Total omzet dari semua sentra
  double get totalOmzetSentra {
    return _sentraList.fold<double>(0, (sum, s) => sum + s.totalOmzet);
  }

  /// Hitungan per tipe sentra
  Map<TipeSentra, int> get sentraByType {
    final map = <TipeSentra, int>{};
    for (var s in _sentraList) {
      map[s.tipeSentra] = (map[s.tipeSentra] ?? 0) + 1;
    }
    return map;
  }

  /// Sentra dengan anggota terbanyak
  SentraProduksi? get largestSentra {
    if (_sentraList.isEmpty) return null;
    return _sentraList.reduce(
      (a, b) => a.jumlahAnggota > b.jumlahAnggota ? a : b
    );
  }

  /// Sentra dengan omzet tertinggi
  SentraProduksi? get highestRevenueSentra {
    if (_sentraList.isEmpty) return null;
    return _sentraList.reduce(
      (a, b) => a.totalOmzet > b.totalOmzet ? a : b
    );
  }
}
