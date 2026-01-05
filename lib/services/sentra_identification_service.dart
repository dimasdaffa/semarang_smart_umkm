import 'package:latlong2/latlong.dart';
import '../data/models/umkm.dart';
import '../data/models/sentra_produksi.dart';

/// Service untuk mengidentifikasi Sentra Produksi berdasarkan
/// clustering bahan baku dan alat produksi

class SentraIdentificationService {
  
  /// Menghitung Jaccard Similarity Index antara dua set
  double _jaccardSimilarity(Set<String> setA, Set<String> setB) {
    if (setA.isEmpty && setB.isEmpty) return 0.0;
    
    final intersection = setA.intersection(setB).length;
    final union = setA.union(setB).length;
    
    return union > 0 ? intersection / union : 0.0;
  }

  /// Menghitung similarity berdasarkan bahan baku antara dua UMKM
  double calculateMaterialSimilarity(Umkm a, Umkm b) {
    final materialsA = a.bahanBakuList.map((e) => e.kategori).toSet();
    final materialsB = b.bahanBakuList.map((e) => e.kategori).toSet();
    return _jaccardSimilarity(materialsA, materialsB);
  }

  /// Menghitung similarity berdasarkan alat produksi antara dua UMKM
  double calculateEquipmentSimilarity(Umkm a, Umkm b) {
    final equipmentA = a.alatProduksiList.map((e) => e.kategori).toSet();
    final equipmentB = b.alatProduksiList.map((e) => e.kategori).toSet();
    return _jaccardSimilarity(equipmentA, equipmentB);
  }

  /// Menghitung similarity gabungan (weighted average)
  double calculateCombinedSimilarity(
    Umkm a, 
    Umkm b, {
    double materialWeight = 0.5,
    double equipmentWeight = 0.5,
  }) {
    final materialSim = calculateMaterialSimilarity(a, b);
    final equipmentSim = calculateEquipmentSimilarity(a, b);
    return (materialSim * materialWeight) + (equipmentSim * equipmentWeight);
  }

  /// Menghitung jarak geografis antara dua UMKM (dalam km)
  double calculateDistance(Umkm a, Umkm b) {
    const Distance distance = Distance();
    return distance.as(LengthUnit.Kilometer, a.lokasi, b.lokasi);
  }

  /// Mengidentifikasi cluster UMKM yang memiliki kesamaan produksi
  /// Menggunakan algoritma sederhana berbasis threshold
  List<List<Umkm>> identifyClusters({
    required List<Umkm> umkmList,
    double similarityThreshold = 0.4,
    double maxDistanceKm = 10.0,
    TipeSentra? filterByType,
  }) {
    final List<List<Umkm>> clusters = [];
    final Set<String> assigned = {};

    for (var i = 0; i < umkmList.length; i++) {
      if (assigned.contains(umkmList[i].id)) continue;
      
      final cluster = <Umkm>[umkmList[i]];
      assigned.add(umkmList[i].id);

      for (var j = i + 1; j < umkmList.length; j++) {
        if (assigned.contains(umkmList[j].id)) continue;

        double similarity;
        switch (filterByType) {
          case TipeSentra.bahanBaku:
            similarity = calculateMaterialSimilarity(umkmList[i], umkmList[j]);
            break;
          case TipeSentra.alatProduksi:
            similarity = calculateEquipmentSimilarity(umkmList[i], umkmList[j]);
            break;
          default:
            similarity = calculateCombinedSimilarity(umkmList[i], umkmList[j]);
        }

        final distance = calculateDistance(umkmList[i], umkmList[j]);

        if (similarity >= similarityThreshold && distance <= maxDistanceKm) {
          cluster.add(umkmList[j]);
          assigned.add(umkmList[j].id);
        }
      }

      if (cluster.length >= 2) { // Minimal 2 UMKM untuk membentuk sentra
        clusters.add(cluster);
      }
    }

    return clusters;
  }

  /// Menentukan pusat geografis dari cluster UMKM
  LatLng _calculateCentroid(List<Umkm> cluster) {
    double sumLat = 0;
    double sumLng = 0;
    
    for (var umkm in cluster) {
      sumLat += umkm.lokasi.latitude;
      sumLng += umkm.lokasi.longitude;
    }
    
    return LatLng(sumLat / cluster.length, sumLng / cluster.length);
  }

  /// Menentukan radius coverage sentra (dalam km)
  double _calculateRadius(List<Umkm> cluster, LatLng centroid) {
    const Distance distance = Distance();
    double maxDist = 0;
    
    for (var umkm in cluster) {
      final dist = distance.as(LengthUnit.Kilometer, centroid, umkm.lokasi);
      if (dist > maxDist) maxDist = dist;
    }
    
    return maxDist + 0.5; // Tambahkan buffer 500m
  }

  /// Ekstrak bahan baku utama dari cluster
  List<String> _extractMainMaterials(List<Umkm> cluster) {
    final Map<String, int> materialCount = {};
    
    for (var umkm in cluster) {
      for (var bahan in umkm.bahanBakuList) {
        materialCount[bahan.nama] = (materialCount[bahan.nama] ?? 0) + 1;
      }
    }
    
    // Urutkan berdasarkan frekuensi dan ambil top 5
    final sorted = materialCount.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    return sorted.take(5).map((e) => e.key).toList();
  }

  /// Ekstrak alat produksi utama dari cluster
  List<String> _extractMainEquipment(List<Umkm> cluster) {
    final Map<String, int> equipmentCount = {};
    
    for (var umkm in cluster) {
      for (var alat in umkm.alatProduksiList) {
        equipmentCount[alat.nama] = (equipmentCount[alat.nama] ?? 0) + 1;
      }
    }
    
    final sorted = equipmentCount.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    return sorted.take(5).map((e) => e.key).toList();
  }

  /// Menentukan tipe sentra berdasarkan dominasi similarity
  TipeSentra _determineSentraType(List<Umkm> cluster) {
    double avgMaterialSim = 0;
    double avgEquipmentSim = 0;
    int count = 0;
    
    for (var i = 0; i < cluster.length; i++) {
      for (var j = i + 1; j < cluster.length; j++) {
        avgMaterialSim += calculateMaterialSimilarity(cluster[i], cluster[j]);
        avgEquipmentSim += calculateEquipmentSimilarity(cluster[i], cluster[j]);
        count++;
      }
    }
    
    if (count > 0) {
      avgMaterialSim /= count;
      avgEquipmentSim /= count;
    }
    
    if (avgMaterialSim > avgEquipmentSim + 0.2) {
      return TipeSentra.bahanBaku;
    } else if (avgEquipmentSim > avgMaterialSim + 0.2) {
      return TipeSentra.alatProduksi;
    }
    return TipeSentra.kombinasi;
  }

  /// Generate nama sentra berdasarkan karakteristik cluster
  String _generateSentraName(List<Umkm> cluster, TipeSentra type) {
    // Ambil kategori UMKM yang paling dominan
    final Map<String, int> kategoriCount = {};
    for (var umkm in cluster) {
      kategoriCount[umkm.kategori] = (kategoriCount[umkm.kategori] ?? 0) + 1;
    }
    
    final dominantKategori = kategoriCount.entries
      .reduce((a, b) => a.value > b.value ? a : b)
      .key;
    
    // Ambil lokasi dari UMKM pertama
    final locationHint = cluster.first.alamat.split(',').first;
    
    return "Sentra $dominantKategori $locationHint";
  }

  /// Generate deskripsi sentra
  String _generateDescription(List<Umkm> cluster, TipeSentra type) {
    final materials = _extractMainMaterials(cluster);
    final equipment = _extractMainEquipment(cluster);
    
    String desc = "Kawasan dengan ${cluster.length} UMKM yang memiliki kesamaan ";
    
    switch (type) {
      case TipeSentra.bahanBaku:
        desc += "penggunaan bahan baku seperti ${materials.take(3).join(', ')}.";
        break;
      case TipeSentra.alatProduksi:
        desc += "penggunaan alat produksi seperti ${equipment.take(3).join(', ')}.";
        break;
      case TipeSentra.kombinasi:
        desc += "bahan baku (${materials.take(2).join(', ')}) dan alat produksi (${equipment.take(2).join(', ')}).";
        break;
    }
    
    return desc;
  }

  /// Konversi cluster menjadi objek SentraProduksi
  List<SentraProduksi> generateSentraList({
    required List<Umkm> umkmList,
    double similarityThreshold = 0.4,
    double maxDistanceKm = 10.0,
  }) {
    final clusters = identifyClusters(
      umkmList: umkmList,
      similarityThreshold: similarityThreshold,
      maxDistanceKm: maxDistanceKm,
    );

    final List<SentraProduksi> sentraList = [];

    for (var i = 0; i < clusters.length; i++) {
      final cluster = clusters[i];
      final centroid = _calculateCentroid(cluster);
      final radius = _calculateRadius(cluster, centroid);
      final type = _determineSentraType(cluster);
      final materials = _extractMainMaterials(cluster);
      final equipment = _extractMainEquipment(cluster);
      final totalOmzet = cluster.fold<double>(0, (sum, u) => sum + u.omzet);

      sentraList.add(SentraProduksi(
        id: 'SENTRA-${i + 1}',
        nama: _generateSentraName(cluster, type),
        deskripsi: _generateDescription(cluster, type),
        pusatLokasi: centroid,
        radiusCoverage: radius,
        umkmIds: cluster.map((u) => u.id).toList(),
        bahanBakuUtama: materials,
        alatProduksiUtama: equipment,
        tipeSentra: type,
        jumlahAnggota: cluster.length,
        totalOmzet: totalOmzet,
      ));
    }

    return sentraList;
  }

  /// Mendapatkan rekomendasi untuk pengembangan sentra
  List<String> getRecommendations(SentraProduksi sentra, List<Umkm> allUmkm) {
    final recommendations = <String>[];
    
    // Rekomendasi berdasarkan jumlah anggota
    if (sentra.jumlahAnggota < 5) {
      recommendations.add(
        "Potensi pengembangan: Rekrut lebih banyak UMKM dengan kesamaan produksi untuk memperkuat sentra."
      );
    }
    
    // Rekomendasi berdasarkan tipe sentra
    if (sentra.tipeSentra == TipeSentra.bahanBaku) {
      recommendations.add(
        "Peluang: Bentuk koperasi pengadaan bahan baku bersama untuk efisiensi biaya."
      );
    } else if (sentra.tipeSentra == TipeSentra.alatProduksi) {
      recommendations.add(
        "Peluang: Pertimbangkan program sharing equipment atau workshop penggunaan alat bersama."
      );
    }
    
    // Rekomendasi berdasarkan kesehatan UMKM
    final umkmInSentra = allUmkm.where(
      (u) => sentra.umkmIds.contains(u.id)
    ).toList();
    
    final needHelp = umkmInSentra.where(
      (u) => u.analyzeUmkmHealth() == UmkmStatus.perluBantuan
    ).length;
    
    if (needHelp > 0) {
      final percentage = (needHelp / umkmInSentra.length * 100).toStringAsFixed(0);
      recommendations.add(
        "Perhatian: $percentage% UMKM dalam sentra ini membutuhkan bantuan. Prioritaskan program pemberdayaan."
      );
    }
    
    return recommendations;
  }
}
