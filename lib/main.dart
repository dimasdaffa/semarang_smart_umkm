import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';

// Data imports
import 'data/models/umkm.dart';
import 'data/models/bahan_baku.dart';
import 'data/models/alat_produksi.dart';
import 'data/mock/mock_catalogs.dart';

// Provider imports
import 'presentation/providers/umkm_provider.dart';
import 'presentation/providers/sentra_provider.dart';

// Page imports
import 'presentation/pages/sentra_list_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UmkmProvider()),
        ChangeNotifierProvider(create: (_) => SentraProvider()),
      ],
      child: const SemarangSmartApp(),
    ),
  );
}

/// --------------------------------------------------------------------------
/// MAIN APP & THEME
/// --------------------------------------------------------------------------

class SemarangSmartApp extends StatelessWidget {
  const SemarangSmartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Semarang Smart UMKM',
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: const Color(0xFF0D47A1),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0D47A1),
          primary: const Color(0xFF0D47A1),
          secondary: const Color(0xFF1976D2),
          surface: Colors.grey[50]!,
        ),
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
        scaffoldBackgroundColor: Colors.grey[100],
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          color: Colors.white,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: const Color(0xFF0D47A1),
          foregroundColor: Colors.white,
          centerTitle: true,
          titleTextStyle: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const DashboardPage(),
    const SmartMapPage(),
    const SentraListPage(), // NEW: Sentra Production Page
    const InputDataPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          backgroundColor: Colors.white,
          indicatorColor: const Color(0xFF0D47A1).withOpacity(0.1),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.dashboard_outlined),
              selectedIcon: Icon(Icons.dashboard, color: Color(0xFF0D47A1)),
              label: 'Dashboard',
            ),
            NavigationDestination(
              icon: Icon(Icons.map_outlined),
              selectedIcon: Icon(Icons.map, color: Color(0xFF0D47A1)),
              label: 'Smart Map',
            ),
            NavigationDestination(
              icon: Icon(Icons.hub_outlined),
              selectedIcon: Icon(Icons.hub, color: Color(0xFF0D47A1)),
              label: 'Sentra',
            ),
            NavigationDestination(
              icon: Icon(Icons.add_circle_outline),
              selectedIcon: Icon(Icons.add_circle, color: Color(0xFF0D47A1)),
              label: 'Input Data',
            ),
          ],
        ),
      ),
    );
  }
}

/// --------------------------------------------------------------------------
/// DASHBOARD PAGE
/// --------------------------------------------------------------------------

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final umkmProvider = Provider.of<UmkmProvider>(context);
    final sentraProvider = Provider.of<SentraProvider>(context);
    final currencyFormatter =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    // AI Analysis Data
    int perluBantuanCount = umkmProvider.umkmList
        .where((u) => u.analyzeUmkmHealth() == UmkmStatus.perluBantuan)
        .length;
    double percentagePerluBantuan =
        umkmProvider.totalUmkm > 0 
          ? (perluBantuanCount / umkmProvider.totalUmkm) * 100 
          : 0;

    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard Eksekutif")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Welcome Section
            Text(
              "Selamat Datang",
              style: GoogleFonts.poppins(
                  fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 4),
            Text(
              "Laporan Real-time UMKM Semarang",
              style:
                  GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Summary Cards Row 1
            Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(
                    context,
                    "Total UMKM",
                    "${umkmProvider.totalUmkm} Unit",
                    Icons.store,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSummaryCard(
                    context,
                    "Total Omzet",
                    currencyFormatter.format(umkmProvider.totalOmzet),
                    Icons.monetization_on,
                    Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Summary Cards Row 2 - NEW: Sentra Stats
            Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(
                    context,
                    "Sentra Produksi",
                    "${sentraProvider.totalSentra} Sentra",
                    Icons.hub,
                    Colors.purple,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSummaryCard(
                    context,
                    "UMKM Tergabung",
                    "${sentraProvider.totalUmkmInSentra} Unit",
                    Icons.groups,
                    Colors.orange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // AI Recommendation Widget
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0D47A1), Color(0xFF1976D2)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black26, blurRadius: 8, offset: Offset(0, 4))
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.auto_awesome, color: Colors.amber),
                      const SizedBox(width: 8),
                      Text(
                        "AI Policy Recommendation",
                        style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Terdeteksi ${percentagePerluBantuan.toStringAsFixed(1)}% UMKM dalam kategori 'Perlu Bantuan'. "
                    "${sentraProvider.totalSentra} sentra produksi teridentifikasi berdasarkan kesamaan bahan baku dan alat produksi. "
                    "Disarankan program KUR prioritas dan pengadaan bahan baku bersama.",
                    style:
                        GoogleFonts.poppins(color: Colors.white.withOpacity(0.9)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Map Preview Section
            Card(
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Sebaran Lokasi UMKM",
                            style: GoogleFonts.poppins(
                                fontSize: 16, fontWeight: FontWeight.w600)),
                        const Text("Lihat Full Map",
                            style: TextStyle(
                                color: Color(0xFF0D47A1), fontSize: 12)),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 250,
                    child: FlutterMap(
                      options: const MapOptions(
                        initialCenter: LatLng(-6.9932, 110.4203),
                        initialZoom: 12.0,
                        interactionOptions: InteractionOptions(
                          flags: InteractiveFlag.none,
                        ),
                      ),
                      children: [
                        TileLayer(
                          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.example.semarang_umkm_map',
                        ),
                        MarkerLayer(
                          markers: umkmProvider.umkmList.map((umkm) {
                            return Marker(
                              point: umkm.lokasi,
                              width: 10,
                              height: 10,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: _getStatusColor(umkm.analyzeUmkmHealth()),
                                  shape: BoxShape.circle,
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 2,
                                      offset: Offset(0, 1),
                                    )
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Chart Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text("Sebaran Kategori Usaha",
                        style: GoogleFonts.poppins(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 200,
                      child: PieChart(
                        PieChartData(
                          sectionsSpace: 0,
                          centerSpaceRadius: 40,
                          sections: _buildChartSections(umkmProvider),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 16,
                      children: umkmProvider.categoryCounts.entries.map((e) {
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              color: _getColorForCategory(e.key),
                            ),
                            const SizedBox(width: 4),
                            Text("${e.key} (${e.value})"),
                          ],
                        );
                      }).toList(),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
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

  List<PieChartSectionData> _buildChartSections(UmkmProvider provider) {
    final counts = provider.categoryCounts;
    final total = provider.totalUmkm;

    if (total == 0) return [];

    return counts.entries.map((entry) {
      final percentage = (entry.value / total) * 100;
      return PieChartSectionData(
        color: _getColorForCategory(entry.key),
        value: percentage,
        title: '${percentage.toStringAsFixed(0)}%',
        radius: 50,
        titleStyle: const TextStyle(
            fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
      );
    }).toList();
  }

  Color _getColorForCategory(String category) {
    switch (category) {
      case 'Kuliner':
        return Colors.orange;
      case 'Oleh-oleh':
        return Colors.blue;
      case 'Fashion':
        return Colors.pink;
      case 'Kriya':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  Widget _buildSummaryCard(BuildContext context, String title, String value,
      IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color, size: 30),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8)),
                  child: Text("YTD",
                      style: TextStyle(
                          color: color,
                          fontSize: 10,
                          fontWeight: FontWeight.bold)),
                )
              ],
            ),
            const SizedBox(height: 12),
            Text(value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                    fontSize: 16, fontWeight: FontWeight.bold)),
            Text(title,
                style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

/// --------------------------------------------------------------------------
/// SMART MAP PAGE
/// --------------------------------------------------------------------------

class SmartMapPage extends StatelessWidget {
  const SmartMapPage({super.key});

  @override
  Widget build(BuildContext context) {
    final umkmProvider = Provider.of<UmkmProvider>(context);
    final sentraProvider = Provider.of<SentraProvider>(context);

    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            options: const MapOptions(
              initialCenter: LatLng(-6.9932, 110.4203),
              initialZoom: 13.5,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.semarang_umkm_map',
              ),
              // Sentra Zone Circles
              CircleLayer(
                circles: sentraProvider.sentraList.map((sentra) {
                  return CircleMarker(
                    point: sentra.pusatLokasi,
                    radius: sentra.radiusCoverage * 80, // Scale for visibility
                    color: Color(sentra.getColorValue()).withOpacity(0.15),
                    borderColor: Color(sentra.getColorValue()),
                    borderStrokeWidth: 2,
                  );
                }).toList(),
              ),
              // UMKM Markers
              MarkerLayer(
                markers: umkmProvider.umkmList.map((umkm) {
                  return Marker(
                    point: umkm.lokasi,
                    width: 60,
                    height: 80,
                    child: GestureDetector(
                      onTap: () => _showUmkmDetail(context, umkm),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.location_on,
                            color: _getStatusColor(umkm.analyzeUmkmHealth()),
                            size: 40,
                          ),
                          Flexible(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 4, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4),
                                border:
                                    Border.all(color: Colors.grey, width: 0.5),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 2,
                                    offset: const Offset(0, 1),
                                  )
                                ],
                              ),
                              child: Text(
                                umkm.nama,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 8, fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          // Header Card
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: Card(
              color: Colors.white.withOpacity(0.95),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    const Icon(Icons.map, color: Color(0xFF0D47A1)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Semarang Smart Mapping System",
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Legend
          Positioned(
            bottom: 20,
            left: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLegendItem(Colors.green, "Mandiri (>200jt)"),
                _buildLegendItem(Colors.amber, "Berkembang (50-200jt)"),
                _buildLegendItem(Colors.red, "Perlu Bantuan (<50jt)"),
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.purple, width: 2),
                          color: Colors.purple.withOpacity(0.2),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text("Zona Sentra",
                          style: TextStyle(
                              fontSize: 10, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
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

  Widget _buildLegendItem(Color color, String label) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(4)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(backgroundColor: color, radius: 4),
          const SizedBox(width: 8),
          Text(label,
              style:
                  const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  void _showUmkmDetail(BuildContext context, Umkm umkm) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      umkm.nama,
                      style: GoogleFonts.poppins(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                        color: _getStatusColor(umkm.analyzeUmkmHealth())
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20)),
                    child: Text(
                      umkm.getStatusText(),
                      style: TextStyle(
                          color: _getStatusColor(umkm.analyzeUmkmHealth()),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.store, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(umkm.kategori,
                      style: GoogleFonts.poppins(color: Colors.grey)),
                  const SizedBox(width: 16),
                  const Icon(Icons.location_city, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(umkm.alamat,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(color: Colors.grey)),
                  ),
                ],
              ),
              const Divider(height: 32),
              
              // Omzet
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Estimasi Omzet Tahunan",
                            style: TextStyle(color: Colors.grey, fontSize: 12)),
                        Text(
                          NumberFormat.currency(
                                  locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0)
                              .format(umkm.omzet),
                          style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF0D47A1)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              // NEW: Bahan Baku & Alat Produksi
              if (umkm.bahanBakuList.isNotEmpty || umkm.alatProduksiList.isNotEmpty) ...[
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 8),
                
                if (umkm.bahanBakuList.isNotEmpty) ...[
                  Text("🏭 Bahan Baku",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600, fontSize: 14)),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: umkm.bahanBakuList.map((b) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: Colors.green.withOpacity(0.3)),
                        ),
                        child: Text(b.nama,
                            style: const TextStyle(
                                fontSize: 11, color: Colors.green)),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),
                ],
                
                if (umkm.alatProduksiList.isNotEmpty) ...[
                  Text("🔧 Alat Produksi",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600, fontSize: 14)),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: umkm.alatProduksiList.map((a) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: Colors.blue.withOpacity(0.3)),
                        ),
                        child: Text(a.nama,
                            style:
                                const TextStyle(fontSize: 11, color: Colors.blue)),
                      );
                    }).toList(),
                  ),
                ],
              ],
              
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D47A1),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text("Tutup"),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// --------------------------------------------------------------------------
/// INPUT DATA PAGE
/// --------------------------------------------------------------------------

class InputDataPage extends StatefulWidget {
  const InputDataPage({super.key});

  @override
  State<InputDataPage> createState() => _InputDataPageState();
}

class _InputDataPageState extends State<InputDataPage> {
  final _formKey = GlobalKey<FormState>();

  final _namaController = TextEditingController();
  final _alamatController = TextEditingController();
  final _omzetController = TextEditingController();
  String _selectedKategori = 'Kuliner';

  // NEW: Selected materials and equipment
  List<BahanBaku> _selectedMaterials = [];
  List<AlatProduksi> _selectedEquipment = [];

  final List<String> _kategoriOptions = [
    'Kuliner',
    'Fashion',
    'Kriya',
    'Oleh-oleh',
    'Jasa'
  ];

  void _submitData() {
    if (_formKey.currentState!.validate()) {
      final random = Random();

      final lat = -6.9932 + (random.nextDouble() * 0.04 - 0.02);
      final lng = 110.4203 + (random.nextDouble() * 0.04 - 0.02);

      final newUmkm = Umkm(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        nama: _namaController.text,
        alamat: _alamatController.text,
        kategori: _selectedKategori,
        omzet:
            double.parse(_omzetController.text.replaceAll(RegExp(r'[^0-9]'), '')),
        lokasi: LatLng(lat, lng),
        bahanBakuList: _selectedMaterials,
        alatProduksiList: _selectedEquipment,
      );

      Provider.of<UmkmProvider>(context, listen: false).addUmkm(newUmkm);

      // Re-run sentra analysis
      final umkmProvider = Provider.of<UmkmProvider>(context, listen: false);
      Provider.of<SentraProvider>(context, listen: false)
          .analyzeAndGenerateSentra(umkmProvider.umkmList);

      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 8),
              Text("Data Berhasil Disimpan"),
            ],
          ),
          content: Text(
              "UMKM '${newUmkm.nama}' telah ditambahkan ke database.\n"
              "Bahan baku: ${_selectedMaterials.length} item\n"
              "Alat produksi: ${_selectedEquipment.length} item\n"
              "Lokasi: Lat ${lat.toStringAsFixed(4)}, Lng ${lng.toStringAsFixed(4)}"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                _namaController.clear();
                _alamatController.clear();
                _omzetController.clear();
                setState(() {
                  _selectedMaterials = [];
                  _selectedEquipment = [];
                });
              },
              child: const Text("OK"),
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Input Data Lapangan")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Form Survey UMKM",
                style: GoogleFonts.poppins(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Text("Isi data untuk menambahkan UMKM baru ke sistem."),
              const SizedBox(height: 24),

              // Nama Usaha
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(
                  labelText: "Nama Usaha",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.store),
                ),
                validator: (val) =>
                    val == null || val.isEmpty ? "Wajib diisi" : null,
              ),
              const SizedBox(height: 16),

              // Alamat
              TextFormField(
                controller: _alamatController,
                decoration: const InputDecoration(
                  labelText: "Alamat Lengkap",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_on_outlined),
                ),
                validator: (val) =>
                    val == null || val.isEmpty ? "Wajib diisi" : null,
              ),
              const SizedBox(height: 16),

              // Kategori
              DropdownButtonFormField<String>(
                value: _selectedKategori,
                decoration: const InputDecoration(
                  labelText: "Kategori Usaha",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category),
                ),
                items: _kategoriOptions.map((e) {
                  return DropdownMenuItem(value: e, child: Text(e));
                }).toList(),
                onChanged: (val) => setState(() => _selectedKategori = val!),
              ),
              const SizedBox(height: 16),

              // Omzet
              TextFormField(
                controller: _omzetController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Estimasi Omzet Tahunan (Rp)",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.monetization_on_outlined),
                  hintText: "Contoh: 150000000",
                ),
                validator: (val) =>
                    val == null || val.isEmpty ? "Wajib diisi" : null,
              ),
              const SizedBox(height: 24),

              // NEW: Bahan Baku Section
              Text(
                "🏭 Bahan Baku",
                style: GoogleFonts.poppins(
                    fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: _selectedMaterials.map((m) {
                        return Chip(
                          label: Text(m.nama, style: const TextStyle(fontSize: 12)),
                          deleteIcon: const Icon(Icons.close, size: 16),
                          onDeleted: () {
                            setState(() {
                              _selectedMaterials.remove(m);
                            });
                          },
                          backgroundColor: Colors.green.withOpacity(0.1),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () => _showMaterialPicker(),
                        icon: const Icon(Icons.add),
                        label: const Text("Tambah Bahan Baku"),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // NEW: Alat Produksi Section
              Text(
                "🔧 Alat Produksi",
                style: GoogleFonts.poppins(
                    fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: _selectedEquipment.map((e) {
                        return Chip(
                          label: Text(e.nama, style: const TextStyle(fontSize: 12)),
                          deleteIcon: const Icon(Icons.close, size: 16),
                          onDeleted: () {
                            setState(() {
                              _selectedEquipment.remove(e);
                            });
                          },
                          backgroundColor: Colors.blue.withOpacity(0.1),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () => _showEquipmentPicker(),
                        icon: const Icon(Icons.add),
                        label: const Text("Tambah Alat Produksi"),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Submit Button
              SizedBox(
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _submitData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D47A1),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  icon: const Icon(Icons.save),
                  label: const Text("SIMPAN DATA UMKM"),
                ),
              ),

              const SizedBox(height: 16),
              const Center(
                child: Text(
                  "*Lokasi akan di-generate otomatis oleh sistem (Mock GPS)",
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _showMaterialPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          maxChildSize: 0.9,
          minChildSize: 0.5,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Pilih Bahan Baku",
                    style: GoogleFonts.poppins(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: MockMaterialCatalog.allMaterials.length,
                      itemBuilder: (context, index) {
                        final material = MockMaterialCatalog.allMaterials[index];
                        final isSelected = _selectedMaterials.contains(material);
                        return ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.inventory_2,
                                color: Colors.green),
                          ),
                          title: Text(material.nama),
                          subtitle:
                              Text("${material.kategori} • ${material.satuan}"),
                          trailing: isSelected
                              ? const Icon(Icons.check_circle,
                                  color: Colors.green)
                              : const Icon(Icons.add_circle_outline),
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                _selectedMaterials.remove(material);
                              } else {
                                _selectedMaterials.add(material);
                              }
                            });
                            Navigator.pop(context);
                            _showMaterialPicker(); // Reopen to continue selecting
                          },
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Selesai"),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showEquipmentPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          maxChildSize: 0.9,
          minChildSize: 0.5,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Pilih Alat Produksi",
                    style: GoogleFonts.poppins(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: MockEquipmentCatalog.allEquipment.length,
                      itemBuilder: (context, index) {
                        final equipment =
                            MockEquipmentCatalog.allEquipment[index];
                        final isSelected =
                            _selectedEquipment.contains(equipment);
                        return ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.precision_manufacturing,
                                color: Colors.blue),
                          ),
                          title: Text(equipment.nama),
                          subtitle: Text(
                              "${equipment.kategori} • ${equipment.jenisAlat}"),
                          trailing: isSelected
                              ? const Icon(Icons.check_circle,
                                  color: Colors.blue)
                              : const Icon(Icons.add_circle_outline),
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                _selectedEquipment.remove(equipment);
                              } else {
                                _selectedEquipment.add(equipment);
                              }
                            });
                            Navigator.pop(context);
                            _showEquipmentPicker(); // Reopen to continue selecting
                          },
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Selesai"),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
