import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../routes/app_routes.dart';
class HomePageAdmin extends StatefulWidget {
  const HomePageAdmin({Key? key}) : super(key: key);

  @override
  _HomePageAdminState createState() => _HomePageAdminState();
}

class _HomePageAdminState extends State<HomePageAdmin> {
 
  final List<Map<String, dynamic>> menuItems = [
    {'icon': Icons.schedule, 'label': 'Jadwal Pelajaran'},
    {'icon': Icons.assignment, 'label': 'Tugas'},
    {'icon': Icons.grade, 'label': 'Nilai'},
    {'icon': Icons.notifications, 'label': 'Pengumuman'},
    {'icon': Icons.forum, 'label': 'Diskusi'},
    {'icon': Icons.book, 'label': 'Mata Pelajaran'},
  ];

  final List<Map<String, String>> scheduleItems = [
    {'matkul': 'Matematika', 'start': '08:00', 'end': '09:30'},
    {'matkul': 'Bahasa Inggris', 'start': '09:45', 'end': '11:15'},
    {'matkul': 'Fisika', 'start': '11:30', 'end': '13:00'},
    {'matkul': 'Kimia', 'start': '13:15', 'end': '14:45'},
    {'matkul': 'Biologi', 'start': '15:00', 'end': '16:30'},
  ];

  final List<Map<String, dynamic>> recentActivities = [
    {'icon': Icons.person_add, 'text': 'Siswa baru terdaftar', 'time': '5 menit yang lalu'},
    {'icon': Icons.edit, 'text': 'Jadwal pelajaran diperbarui', 'time': '1 jam yang lalu'},
    {'icon': Icons.announcement, 'text': 'Pengumuman baru ditambahkan', 'time': '2 jam yang lalu'},
  ];

  final List<Map<String, dynamic>> studentData = [
    {'grade': 'Kelas 10', 'count': 150, 'color': Colors.blue},
    {'grade': 'Kelas 11', 'count': 180, 'color': Colors.green},
    {'grade': 'Kelas 12', 'count': 170, 'color': Colors.orange},
  ];

  final List<Map<String, dynamic>> performanceData = [
    {'subject': 'MTK', 'average': 75.5},
    {'subject': 'IND', 'average': 80.2},
    {'subject': 'ENG', 'average': 78.7},
    {'subject': 'IPA', 'average': 76.8},
    {'subject': 'IPS', 'average': 79.3},
  ];

  void _showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Konfirmasi Log Out'),
        content: const Text('Apakah Anda yakin ingin keluar?'),
        actions: <Widget>[
          TextButton(
            child: const Text('Batal'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Log Out'),
            onPressed: () {
              // Implementasi log out di sini
              print('User logged out');
               Navigator.of(context).pop();
             Navigator.pushReplacementNamed(context,AppRoutes.login);
            },
          ),
        ],
      );
    },
  );
}

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 80), // Sesuaikan dengan tinggi header
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildQuickStats(),
                        const SizedBox(height: 24.0),
                        _buildMenuGrid(),
                        const SizedBox(height: 24.0),
                        _buildScheduleSection(),
                        const SizedBox(height: 24.0),
                        _buildStudentDistributionChart(),
                        const SizedBox(height: 24.0),
                        _buildPerformanceChart(),
                        const SizedBox(height: 24.0),
                        _buildRecentActivities(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _buildHeader(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(25.0),
      decoration: BoxDecoration(
        color: Colors.blue.shade700,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30.0),
          bottomRight: Radius.circular(30.0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage('assets/images/avatar.jpg'),
              ),
              const SizedBox(width: 16.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Selamat datang,',
                    style: TextStyle(fontSize: 16.0, color: Colors.white70),
                  ),
                  Text(
                    'Admin',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
         
          IconButton(
              icon: const Icon(Icons.logout, color: Colors.white),
               onPressed: () => _showLogoutDialog(context),
            ),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatCard('Siswa', '500', Icons.people, Colors.blue),
        _buildStatCard('Guru', '50', Icons.school, Colors.green),
        _buildStatCard('Kelas', '20', Icons.class_, Colors.orange),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, size: 30, color: color),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(title, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        childAspectRatio: 0.8,
      ),
      itemCount: menuItems.length,
      itemBuilder: (context, index) {
        final item = menuItems[index];
        return _buildMenuItem(item);
      },
    );
  }

  Widget _buildMenuItem(Map<String, dynamic> item) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: InkWell(
        onTap: () => print('${item['label']} tapped'),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(item['icon'], size: 40, color: Colors.blue.shade700),
            const SizedBox(height: 8),
            Text(
              item['label'],
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade800),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Jadwal Hari Ini',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: scheduleItems.length,
            itemBuilder: (context, index) {
              final schedule = scheduleItems[index];
              return _buildScheduleCard(schedule);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildScheduleCard(Map<String, String> schedule) {
    return Card(
      margin: const EdgeInsets.only(right: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.blue.shade100,
      child: Container(
        width: 200,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              schedule['matkul']!,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.access_time, size: 16, color: Colors.blue.shade700),
                const SizedBox(width: 4),
                Text(
                  '${schedule['start']} - ${schedule['end']}',
                  style: TextStyle(fontSize: 14, color: Colors.blue.shade700),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivities() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Aktivitas Terbaru',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: recentActivities.length,
          itemBuilder: (context, index) {
            final activity = recentActivities[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue.shade100,
                child: Icon(activity['icon'], color: Colors.blue.shade700),
              ),
              title: Text(activity['text']),
              subtitle: Text(activity['time']),
            );
          },
        ),
      ],
    );
  }

  Widget _buildPerformanceChart() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Rata-rata Nilai Mata Pelajaran',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 16),
      SizedBox(
        height: 200,
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: 100,
            barTouchData: BarTouchData(enabled: false),
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (double value, TitleMeta meta) {
                    return Text(
                      performanceData[value.toInt()]['subject'].toString().substring(0, 3),
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    );
                  },
                  reservedSize: 30,
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (double value, TitleMeta meta) {
                    if (value == 0) return const Text('0');
                    if (value == 50) return const Text('50');
                    if (value == 100) return const Text('100');
                    return const Text('');
                  },
                  reservedSize: 30,
                ),
              ),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            borderData: FlBorderData(show: false),
            barGroups: performanceData.asMap().entries.map((entry) {
              return BarChartGroupData(
                x: entry.key,
                barRods: [
                  BarChartRodData(
                    toY: entry.value['average'],
                    color: Colors.blue,
                    width: 22,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(6),
                      topRight: Radius.circular(6),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    ],
  );
}

  Widget _buildStudentDistributionChart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Distribusi Siswa per Angkatan',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: Row(
            children: [
              Expanded(
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 0,
                    centerSpaceRadius: 40,
                    sections: studentData.map((data) {
                      return PieChartSectionData(
                        color: data['color'] as Color,
                        value: data['count'].toDouble(),
                        title: '${data['count']}',
                        radius: 50,
                        titleStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: studentData.map((data) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      children: [
                        Container(
                          width: 16,
                          height: 16,
                          color: data['color'] as Color,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${data['grade']}: ${data['count']}',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}