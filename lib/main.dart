
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UmkmProvider()),
      ],
      child: const SemarangSmartApp(),
    ),
  );
}

/// --------------------------------------------------------------------------
/// 1. MODEL & DATA
/// --------------------------------------------------------------------------

enum UmkmStatus { mandiri, berkembang, perluBantuan }

class Umkm {
  final String id;
  final String nama;
  final String kategori;
  final double omzet;
  final LatLng lokasi;
  final String alamat;

  Umkm({
    required this.id,
    required this.nama,
    required this.kategori,
    required this.omzet,
    required this.lokasi,
    required this.alamat,
  });

  /// "BAU AI" Logic: Analyze Health based on Omzet
  UmkmStatus analyzeUmkmHealth() {
    if (omzet > 200000000) return UmkmStatus.mandiri;
    if (omzet >= 50000000) return UmkmStatus.berkembang;
    return UmkmStatus.perluBantuan;
  }

  Color getStatusColor() {
    switch (analyzeUmkmHealth()) {
      case UmkmStatus.mandiri:
        return Colors.green;
      case UmkmStatus.berkembang:
        return Colors.amber;
      case UmkmStatus.perluBantuan:
        return Colors.red;
    }
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
}

class UmkmProvider extends ChangeNotifier {
  final List<Umkm> _umkmList = [
    Umkm(
      id: '1',
      nama: "Lumpia Gang Lombok",
      kategori: "Kuliner",
      omzet: 150000000,
      lokasi: const LatLng(-6.9744, 110.4263),
      alamat: "Gg. Lombok No.11, Purwodinatan",
    ),
    Umkm(
      id: '2',
      nama: "Bandeng Juwana Elrina",
      kategori: "Oleh-oleh",
      omzet: 500000000,
      lokasi: const LatLng(-6.9890, 110.4100),
      alamat: "Jl. Pandanaran No.57",
    ),
    Umkm(
      id: '3',
      nama: "Soto Bangkong",
      kategori: "Kuliner",
      omzet: 250000000,
      lokasi: const LatLng(-6.9961, 110.4300),
      alamat: "Jl. Bridjen Katamso",
    ),
    Umkm(
      id: '4',
      nama: "Tahu Bakso Ungaran (Cabang Kota)",
      kategori: "Oleh-oleh",
      omzet: 45000000, // Perlu Bantuan
      lokasi: const LatLng(-7.0000, 110.4200),
      alamat: "Sekitar Simpang Lima",
    ),
    Umkm(
      id: '5',
      nama: "Batik Semarang Indah",
      kategori: "Fashion",
      omzet: 80000000,
      lokasi: const LatLng(-6.9800, 110.4350),
      alamat: "Kawasan Kota Lama",
    ),
    Umkm(
      id: '6',
      nama: "Warung Makan Mbok Berek",
      kategori: "Kuliner",
      omzet: 30000000, // Perlu Bantuan
      lokasi: const LatLng(-6.9850, 110.4000),
      alamat: "Jl. Jendral Sudirman",
    ),
    Umkm(
      id: '7',
      nama: "Kerajinan Rotan Khas",
      kategori: "Kriya",
      omzet: 60000000,
      lokasi: const LatLng(-6.9920, 110.4150),
      alamat: "Dekat Tugu Muda",
    ),
    Umkm(
      id: '8',
      nama: "Wingko Babat Kereta Api",
      kategori: "Oleh-oleh",
      omzet: 220000000,
      lokasi: const LatLng(-6.9680, 110.4230),
      alamat: "Stasiun Tawang Area",
    ),
    Umkm(
      id: '9',
      nama: "Kopi Banaran Point",
      kategori: "Kuliner",
      omzet: 180000000,
      lokasi: const LatLng(-6.9900, 110.4050),
      alamat: "Jl. Pemuda",
    ),
    Umkm(
      id: '10',
      nama: "Souvenir Kaos Semarang",
      kategori: "Fashion",
      omzet: 40000000, // Perlu Bantuan
      lokasi: const LatLng(-6.9950, 110.4250),
      alamat: "Simpang Lima Area Plaza",
    ),
  ];

  List<Umkm> get umkmList => _umkmList;

  void addUmkm(Umkm umkm) {
    _umkmList.add(umkm);
    notifyListeners();
  }

  // Helper Stats
  double get totalOmzet => _umkmList.fold(0, (sum, item) => sum + item.omzet);
  int get totalUmkm => _umkmList.length;

  Map<String, int> get categoryCounts {
    final map = <String, int>{};
    for (var u in _umkmList) {
      map[u.kategori] = (map[u.kategori] ?? 0) + 1;
    }
    return map;
  }
}

/// --------------------------------------------------------------------------
/// 2. MAIN APP & THEME
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
        primaryColor: const Color(0xFF0D47A1), // Deep Blue
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
/// 3. DASHBOARD PAGE
/// --------------------------------------------------------------------------

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final umkmProvider = Provider.of<UmkmProvider>(context);
    final currencyFormatter =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    // AI Analysis Data
    int perluBantuanCount = umkmProvider.umkmList
        .where((u) => u.analyzeUmkmHealth() == UmkmStatus.perluBantuan)
        .length;
    double percentagePerluBantuan =
        (perluBantuanCount / umkmProvider.totalUmkm) * 100;

    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard Eksekutif")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Welcome Section
            Text(
              "Selamat Datang, Dimas Daffa",
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

            // Summary Cards
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
                    "Terdeteksi ${percentagePerluBantuan.toStringAsFixed(1)}% UMKM berada dalam kategori 'Perlu Bantuan'. Disarankan untuk membuka program KUR Daerag prioritas untuk sektor ${umkmProvider.umkmList.where((u) => u.analyzeUmkmHealth() == UmkmStatus.perluBantuan).firstOrNull?.kategori ?? 'Terkait'}.",
                    style:
                        GoogleFonts.poppins(color: Colors.white.withOpacity(0.9)),
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

  List<PieChartSectionData> _buildChartSections(UmkmProvider provider) {
    final counts = provider.categoryCounts;
    final total = provider.totalUmkm;
    
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
      case 'Kuliner': return Colors.orange;
      case 'Oleh-oleh': return Colors.blue;
      case 'Fashion': return Colors.pink;
      case 'Kriya': return Colors.purple;
      default: return Colors.grey;
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
                      style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
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
/// 4. SMART MAP PAGE
/// --------------------------------------------------------------------------

class SmartMapPage extends StatelessWidget {
  const SmartMapPage({super.key});

  @override
  Widget build(BuildContext context) {
    final umkmProvider = Provider.of<UmkmProvider>(context);

    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            options: const MapOptions(
              initialCenter: LatLng(-6.9932, 110.4203), // Semarang Center
              initialZoom: 13.5,
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
                    width: 60,
                    height: 80,
                    child: GestureDetector(
                      onTap: () => _showUmkmDetail(context, umkm),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.location_on,
                            color: umkm.getStatusColor(),
                            size: 40,
                          ),
                          Flexible(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: Colors.grey, width: 0.5),
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
                                style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold),
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
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: Card(
              color: Colors.white.withOpacity(0.95),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
          Positioned(
            bottom: 20,
            left: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLegendItem(Colors.green, "Mandiri (>200jt)"),
                _buildLegendItem(Colors.amber, "Berkembang (50-200jt)"),
                _buildLegendItem(Colors.red, "Perlu Bantuan (<50jt)"),
              ],
            ),
          )
        ],
      ),
    );
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
          Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  void _showUmkmDetail(BuildContext context, Umkm umkm) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
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
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                        color: umkm.getStatusColor().withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20)),
                    child: Text(
                      umkm.getStatusText(),
                      style: TextStyle(
                          color: umkm.getStatusColor(), fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.store, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(umkm.kategori, style: GoogleFonts.poppins(color: Colors.grey)),
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
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0D47A1),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("Tutup"),
                  )
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

/// --------------------------------------------------------------------------
/// 5. INPUT DATA PAGE
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

  final List<String> _kategoriOptions = ['Kuliner', 'Fashion', 'Kriya', 'Oleh-oleh', 'Jasa'];

  void _submitData() {
    if (_formKey.currentState!.validate()) {
      // Simulation Logic
      final random = Random();
      
      // Random location around Semarang center (-6.9932, 110.4203)
      // Variation approx +/- 0.02 degrees
      final lat = -6.9932 + (random.nextDouble() * 0.04 - 0.02);
      final lng = 110.4203 + (random.nextDouble() * 0.04 - 0.02);

      final newUmkm = Umkm(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        nama: _namaController.text,
        alamat: _alamatController.text,
        kategori: _selectedKategori,
        omzet: double.parse(_omzetController.text.replaceAll(RegExp(r'[^0-9]'), '')), // Simple parsing
        lokasi: LatLng(lat, lng),
      );

      // Add to Provider
      Provider.of<UmkmProvider>(context, listen: false).addUmkm(newUmkm);

      // Show Dialog
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
              "UMKM '${newUmkm.nama}' telah ditambahkan ke database.\nLokasi terdeteksi otomatis oleh sistem di:\nLat: ${lat.toStringAsFixed(4)}, Lng: ${lng.toStringAsFixed(4)}"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx); // Close Dialog
                // Reset Form
                _namaController.clear();
                _alamatController.clear();
                _omzetController.clear();
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
              const Text("Isi data berikut untuk menambahkan UMKM baru ke sistem."),
              const SizedBox(height: 24),

              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(
                  labelText: "Nama Usaha",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.store),
                ),
                validator: (val) => val == null || val.isEmpty ? "Wajib diisi" : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _alamatController,
                decoration: const InputDecoration(
                  labelText: "Alamat Lengkap",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_on_outlined),
                ),
                validator: (val) => val == null || val.isEmpty ? "Wajib diisi" : null,
              ),
              const SizedBox(height: 16),

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

              TextFormField(
                controller: _omzetController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Estimasi Omzet Tahunan (Rp)",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.monetization_on_outlined),
                  hintText: "Contoh: 150000000",
                ),
                validator: (val) => val == null || val.isEmpty ? "Wajib diisi" : null,
              ),
              const SizedBox(height: 32),

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
}
