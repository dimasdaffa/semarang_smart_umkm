import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../data/models/sentra_produksi.dart';
import '../../data/models/umkm.dart';
import '../providers/umkm_provider.dart';
import '../providers/sentra_provider.dart';

/// Halaman detail Sentra Produksi
/// Menampilkan informasi lengkap dan anggota UMKM

class SentraDetailPage extends StatelessWidget {
  final SentraProduksi sentra;

  const SentraDetailPage({super.key, required this.sentra});

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Consumer2<UmkmProvider, SentraProvider>(
      builder: (context, umkmProvider, sentraProvider, child) {
        // Get UMKM members of this sentra
        final members = umkmProvider.umkmList
            .where((u) => sentra.umkmIds.contains(u.id))
            .toList();

        // Get recommendations
        final recommendations = sentraProvider.getRecommendations(
          sentra,
          umkmProvider.umkmList,
        );

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              // App Bar with Map
              SliverAppBar(
                expandedHeight: 250,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    sentra.nama,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        const Shadow(
                          color: Colors.black54,
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Mini Map
                      FlutterMap(
                        options: MapOptions(
                          initialCenter: sentra.pusatLokasi,
                          initialZoom: 14.0,
                          interactionOptions: const InteractionOptions(
                            flags: InteractiveFlag.none,
                          ),
                        ),
                        children: [
                          TileLayer(
                            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName: 'com.example.semarang_umkm_map',
                          ),
                          // Zone circle
                          CircleLayer(
                            circles: [
                              CircleMarker(
                                point: sentra.pusatLokasi,
                                radius: sentra.radiusCoverage * 100, // Scale for visibility
                                color: Color(sentra.getColorValue()).withOpacity(0.2),
                                borderColor: Color(sentra.getColorValue()),
                                borderStrokeWidth: 2,
                              ),
                            ],
                          ),
                          // Member markers
                          MarkerLayer(
                            markers: members.map((umkm) {
                              return Marker(
                                point: umkm.lokasi,
                                width: 24,
                                height: 24,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: _getStatusColor(umkm.analyzeUmkmHealth()),
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 2),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.store,
                                    size: 12,
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                      // Gradient overlay
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        height: 80,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.7),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Type Badge & Stats
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Color(sentra.getColorValue()).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Color(sentra.getColorValue()),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  _getTypeIcon(sentra.tipeSentra),
                                  size: 16,
                                  color: Color(sentra.getColorValue()),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  "Sentra ${sentra.tipeSentra.label}",
                                  style: TextStyle(
                                    color: Color(sentra.getColorValue()),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Description
                      Text(
                        sentra.deskripsi,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Stats Cards
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              "Anggota",
                              "${sentra.jumlahAnggota}",
                              "UMKM",
                              Icons.store,
                              Colors.blue,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildStatCard(
                              "Total Omzet",
                              currencyFormatter.format(sentra.totalOmzet),
                              "Per Tahun",
                              Icons.monetization_on,
                              Colors.green,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              "Coverage",
                              "${sentra.radiusCoverage.toStringAsFixed(1)} km",
                              "Radius",
                              Icons.radar,
                              Colors.orange,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildStatCard(
                              "Rata-rata Omzet",
                              currencyFormatter.format(
                                sentra.totalOmzet / sentra.jumlahAnggota,
                              ),
                              "Per UMKM",
                              Icons.trending_up,
                              Colors.purple,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Recommendations
                      if (recommendations.isNotEmpty) ...[
                        Text(
                          "💡 Rekomendasi",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.amber.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.amber.withOpacity(0.3)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: recommendations.map((r) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("•"),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        r,
                                        style: TextStyle(
                                          color: Colors.amber[900],
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],

                      // Materials & Equipment
                      Row(
                        children: [
                          Expanded(
                            child: _buildTagSection(
                              "🏭 Bahan Baku Utama",
                              sentra.bahanBakuUtama,
                              Colors.green,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildTagSection(
                              "🔧 Alat Produksi",
                              sentra.alatProduksiUtama,
                              Colors.blue,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Member Health Chart
                      Text(
                        "📊 Kesehatan UMKM Anggota",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 150,
                        child: Row(
                          children: [
                            Expanded(
                              child: PieChart(
                                PieChartData(
                                  sectionsSpace: 2,
                                  centerSpaceRadius: 30,
                                  sections: _buildHealthChartSections(members),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLegendItem(Colors.green, "Mandiri"),
                                _buildLegendItem(Colors.amber, "Berkembang"),
                                _buildLegendItem(Colors.red, "Perlu Bantuan"),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Member List
                      Text(
                        "👥 Daftar UMKM Anggota",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),

              // Member List
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final umkm = members[index];
                    return _buildMemberCard(context, umkm, currencyFormatter);
                  },
                  childCount: members.length,
                ),
              ),

              // Bottom padding
              const SliverToBoxAdapter(
                child: SizedBox(height: 20),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    String subtitle,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            subtitle,
            style: TextStyle(color: Colors.grey[500], fontSize: 10),
          ),
        ],
      ),
    );
  }

  Widget _buildTagSection(String title, List<String> items, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 4,
          runSpacing: 4,
          children: items.map((item) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: color.withOpacity(0.3)),
              ),
              child: Text(
                item,
                style: TextStyle(fontSize: 11, color: color),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  List<PieChartSectionData> _buildHealthChartSections(List<Umkm> members) {
    int mandiri = 0, berkembang = 0, perluBantuan = 0;

    for (var umkm in members) {
      switch (umkm.analyzeUmkmHealth()) {
        case UmkmStatus.mandiri:
          mandiri++;
          break;
        case UmkmStatus.berkembang:
          berkembang++;
          break;
        case UmkmStatus.perluBantuan:
          perluBantuan++;
          break;
      }
    }

    final total = members.length;

    return [
      if (mandiri > 0)
        PieChartSectionData(
          color: Colors.green,
          value: mandiri.toDouble(),
          title: '${(mandiri / total * 100).toStringAsFixed(0)}%',
          radius: 40,
          titleStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 10,
          ),
        ),
      if (berkembang > 0)
        PieChartSectionData(
          color: Colors.amber,
          value: berkembang.toDouble(),
          title: '${(berkembang / total * 100).toStringAsFixed(0)}%',
          radius: 40,
          titleStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 10,
          ),
        ),
      if (perluBantuan > 0)
        PieChartSectionData(
          color: Colors.red,
          value: perluBantuan.toDouble(),
          title: '${(perluBantuan / total * 100).toStringAsFixed(0)}%',
          radius: 40,
          titleStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 10,
          ),
        ),
    ];
  }

  Widget _buildLegendItem(Color color, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildMemberCard(
    BuildContext context,
    Umkm umkm,
    NumberFormat currencyFormatter,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _getStatusColor(umkm.analyzeUmkmHealth()).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.store,
              color: _getStatusColor(umkm.analyzeUmkmHealth()),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  umkm.nama,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  umkm.kategori,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                currencyFormatter.format(umkm.omzet),
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: const Color(0xFF0D47A1),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: _getStatusColor(umkm.analyzeUmkmHealth()).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  umkm.getStatusText(),
                  style: TextStyle(
                    color: _getStatusColor(umkm.analyzeUmkmHealth()),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(UmkmStatus status) {
    switch (status) {
      case UmkmStatus.mandiri:
        return Colors.green;
      case UmkmStatus.berkembang:
        return Colors.amber;
      case UmkmStatus.perluBantuan:
        return Colors.red;
    }
  }

  IconData _getTypeIcon(TipeSentra type) {
    switch (type) {
      case TipeSentra.bahanBaku:
        return Icons.inventory_2;
      case TipeSentra.alatProduksi:
        return Icons.precision_manufacturing;
      case TipeSentra.kombinasi:
        return Icons.layers;
    }
  }
}
