import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../data/models/sentra_produksi.dart';
import '../providers/umkm_provider.dart';
import '../providers/sentra_provider.dart';
import 'sentra_detail_page.dart';

/// Halaman daftar Sentra Produksi
/// Menampilkan hasil analisis clustering UMKM

class SentraListPage extends StatefulWidget {
  const SentraListPage({super.key});

  @override
  State<SentraListPage> createState() => _SentraListPageState();
}

class _SentraListPageState extends State<SentraListPage> {
  String _filterType = 'Semua';
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Jalankan analisis saat halaman dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _runAnalysis();
    });
  }

  void _runAnalysis() {
    final umkmProvider = Provider.of<UmkmProvider>(context, listen: false);
    final sentraProvider = Provider.of<SentraProvider>(context, listen: false);
    sentraProvider.analyzeAndGenerateSentra(umkmProvider.umkmList);
  }

  List<SentraProduksi> _getFilteredSentra(List<SentraProduksi> sentraList) {
    return sentraList.where((sentra) {
      // Filter by type
      if (_filterType != 'Semua') {
        if (_filterType == 'Bahan Baku' && sentra.tipeSentra != TipeSentra.bahanBaku) return false;
        if (_filterType == 'Alat Produksi' && sentra.tipeSentra != TipeSentra.alatProduksi) return false;
        if (_filterType == 'Kombinasi' && sentra.tipeSentra != TipeSentra.kombinasi) return false;
      }
      
      // Filter by search
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        return sentra.nama.toLowerCase().contains(query) ||
               sentra.deskripsi.toLowerCase().contains(query) ||
               sentra.bahanBakuUtama.any((b) => b.toLowerCase().contains(query)) ||
               sentra.alatProduksiUtama.any((a) => a.toLowerCase().contains(query));
      }
      
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sentra Produksi"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: "Jalankan Ulang Analisis",
            onPressed: _runAnalysis,
          ),
        ],
      ),
      body: Consumer2<SentraProvider, UmkmProvider>(
        builder: (context, sentraProvider, umkmProvider, child) {
          if (sentraProvider.isAnalyzing) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text("Menganalisis data UMKM..."),
                  Text("Mengidentifikasi sentra produksi...", 
                    style: TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            );
          }

          if (sentraProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text("Error: ${sentraProvider.error}"),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _runAnalysis,
                    child: const Text("Coba Lagi"),
                  ),
                ],
              ),
            );
          }

          final filteredSentra = _getFilteredSentra(sentraProvider.sentraList);

          return Column(
            children: [
              // Summary Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0D47A1), Color(0xFF1976D2)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.auto_awesome, color: Colors.amber),
                        const SizedBox(width: 8),
                        Text(
                          "Hasil Analisis Sentra",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem(
                          "${sentraProvider.totalSentra}",
                          "Sentra",
                          Icons.hub,
                        ),
                        _buildStatItem(
                          "${sentraProvider.totalUmkmInSentra}",
                          "UMKM Tergabung",
                          Icons.store,
                        ),
                        _buildStatItem(
                          NumberFormat.compactCurrency(
                            locale: 'id_ID',
                            symbol: 'Rp ',
                            decimalDigits: 0,
                          ).format(sentraProvider.totalOmzetSentra),
                          "Total Omzet",
                          Icons.monetization_on,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Search & Filter
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      onChanged: (value) => setState(() => _searchQuery = value),
                      decoration: InputDecoration(
                        hintText: "Cari sentra...",
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildFilterChip("Semua", Icons.all_inclusive),
                          const SizedBox(width: 8),
                          _buildFilterChip("Bahan Baku", Icons.inventory_2),
                          const SizedBox(width: 8),
                          _buildFilterChip("Alat Produksi", Icons.precision_manufacturing),
                          const SizedBox(width: 8),
                          _buildFilterChip("Kombinasi", Icons.layers),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Sentra List
              Expanded(
                child: filteredSentra.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
                            const SizedBox(height: 16),
                            Text(
                              sentraProvider.sentraList.isEmpty
                                  ? "Belum ada sentra teridentifikasi"
                                  : "Tidak ada sentra yang cocok dengan filter",
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: filteredSentra.length,
                        itemBuilder: (context, index) {
                          return _SentraCard(
                            sentra: filteredSentra[index],
                            umkmProvider: umkmProvider,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => SentraDetailPage(
                                    sentra: filteredSentra[index],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatItem(String value, String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(
            color: Colors.white70,
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label, IconData icon) {
    final isSelected = _filterType == label;
    return FilterChip(
      selected: isSelected,
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: isSelected ? Colors.white : Colors.grey[700]),
          const SizedBox(width: 4),
          Text(label),
        ],
      ),
      onSelected: (_) => setState(() => _filterType = label),
      selectedColor: const Color(0xFF0D47A1),
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.grey[700],
      ),
      checkmarkColor: Colors.white,
    );
  }
}

class _SentraCard extends StatelessWidget {
  final SentraProduksi sentra;
  final UmkmProvider umkmProvider;
  final VoidCallback onTap;

  const _SentraCard({
    required this.sentra,
    required this.umkmProvider,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Color(sentra.getColorValue()).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getTypeIcon(sentra.tipeSentra),
                      color: Color(sentra.getColorValue()),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          sentra.nama,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Color(sentra.getColorValue()).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            sentra.tipeSentra.label,
                            style: TextStyle(
                              color: Color(sentra.getColorValue()),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: Colors.grey),
                ],
              ),
              const SizedBox(height: 12),

              // Description
              Text(
                sentra.deskripsi,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
              const SizedBox(height: 12),

              // Stats Row
              Row(
                children: [
                  _buildMiniStat(
                    Icons.store,
                    "${sentra.jumlahAnggota} UMKM",
                    Colors.blue,
                  ),
                  const SizedBox(width: 12),
                  _buildMiniStat(
                    Icons.monetization_on,
                    currencyFormatter.format(sentra.totalOmzet),
                    Colors.green,
                  ),
                  const SizedBox(width: 12),
                  _buildMiniStat(
                    Icons.radar,
                    "${sentra.radiusCoverage.toStringAsFixed(1)} km",
                    Colors.orange,
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Materials & Equipment Tags
              Wrap(
                spacing: 4,
                runSpacing: 4,
                children: [
                  ...sentra.bahanBakuUtama.take(3).map(
                    (b) => _buildTag(b, Colors.green),
                  ),
                  ...sentra.alatProduksiUtama.take(2).map(
                    (a) => _buildTag(a, Colors.blue),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMiniStat(IconData icon, String text, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(fontSize: 11, color: Colors.grey[700]),
        ),
      ],
    );
  }

  Widget _buildTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 10, color: color),
      ),
    );
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
