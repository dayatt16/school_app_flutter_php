import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../routes/app_routes.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, dynamic>> menuItems = [
    {'icon': Icons.schedule, 'label': 'Jadwal'},
    {'icon': Icons.assignment, 'label': 'Tugas'},
    {'icon': Icons.grade, 'label': 'Nilai'},
    {'icon': Icons.notifications, 'label': 'Pengumuman'},
    {'icon': Icons.forum, 'label': 'Diskusi'},
    {'icon': Icons.book, 'label': 'E-Learning'},
  ];

  final List<Map<String, String>> scheduleItems = [
    {'matkul': 'Matematika', 'start': '08:00', 'end': '09:30', 'room': 'R. 101'},
    {'matkul': 'Bahasa Inggris', 'start': '09:45', 'end': '11:15', 'room': 'R. 202'},
    {'matkul': 'Fisika', 'start': '11:30', 'end': '13:00', 'room': 'Lab Fisika'},
  ];

  final List<Map<String, dynamic>> upcomingTasks = [
    {'subject': 'Matematika', 'task': 'PR Bab 3', 'deadline': '2023-05-20', 'daysLeft': 3},
    {'subject': 'Bahasa Inggris', 'task': 'Essay', 'deadline': '2023-05-22', 'daysLeft': 5},
    {'subject': 'Fisika', 'task': 'Laporan Praktikum', 'deadline': '2023-05-25', 'daysLeft': 8},
  ];

  final List<Map<String, dynamic>> recentGrades = [
    {'subject': 'Matematika', 'grade': 85, 'date': '2023-05-15'},
    {'subject': 'Bahasa Indonesia', 'grade': 78, 'date': '2023-05-14'},
    {'subject': 'Biologi', 'grade': 92, 'date': '2023-05-13'},
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
               Navigator.pop(context);
              
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
                        _buildMenuGrid(),
                        const SizedBox(height: 24.0),
                        _buildScheduleSection(),
                        const SizedBox(height: 24.0),
                        _buildUpcomingTasksSection(),
                        const SizedBox(height: 24.0),
                        _buildRecentGradesSection(),
                        const SizedBox(height: 24.0),
                        _buildAttendanceChart(),
                        
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
                  'Fauzan Taslim',
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
        Row(
          children: [
           
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.white),
              onPressed: () {
                _showLogoutDialog(context);
              },
            ),
          ],
        ),
      ],
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
        childAspectRatio: 1.0,
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
            Icon(item['icon'], size: 32, color: Colors.blue.shade700),
            const SizedBox(height: 8),
            Text(
              item['label'],
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade800),
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
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.room, size: 16, color: Colors.blue.shade700),
                const SizedBox(width: 4),
                Text(
                  schedule['room']!,
                  style: TextStyle(fontSize: 14, color: Colors.blue.shade700),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingTasksSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tugas Mendatang',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: upcomingTasks.length,
          itemBuilder: (context, index) {
            final task = upcomingTasks[index];
            return _buildUpcomingTaskCard(task);
          },
        ),
      ],
    );
  }

  Widget _buildUpcomingTaskCard(Map<String, dynamic> task) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Center(
                child: Text(
                  '${task['daysLeft']}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade700,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task['subject'],
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(task['task'], style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(
                    'Deadline: ${task['deadline']}',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentGradesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Nilai Terbaru',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: recentGrades.length,
          itemBuilder: (context, index) {
            final grade = recentGrades[index];
            return _buildRecentGradeCard(grade);
          },
        ),
      ],
    );
  }

  Widget _buildRecentGradeCard(Map<String, dynamic> grade) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  grade['subject'],
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'Tanggal: ${grade['date']}',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
              ],
            ),
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Center(
                child: Text(
                  '${grade['grade']}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

 Widget _buildAttendanceChart() {
  return Card(
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    child: Padding(
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Kehadiran Bulan Ini',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              SizedBox(
                height: 100,
                width: 100,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 0,
                    centerSpaceRadius: 30,
                    sections: [
                      PieChartSectionData(
                        color: Colors.green.shade400,
                        value: 80,
                        title: '',
                        radius: 35,
                      ),
                      PieChartSectionData(
                        color: Colors.red.shade400,
                        value: 15,
                        title: '',
                        radius: 35,
                      ),
                      PieChartSectionData(
                        color: Colors.orange.shade400,
                        value: 5,
                        title: '',
                        radius: 35,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLegendItem('Hadir', '80%', Colors.green.shade400),
                    const SizedBox(height: 8),
                    _buildLegendItem('Absen', '15%', Colors.red.shade400),
                    const SizedBox(height: 8),
                    _buildLegendItem('Izin', '5%', Colors.orange.shade400),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget _buildLegendItem(String label, String percentage, Color color) {
  return Row(
    children: [
      Container(
        width: 16,
        height: 16,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
      const SizedBox(width: 8),
      Text(
        '$label: $percentage',
        style: const TextStyle(fontSize: 14),
      ),
    ],
  );
}


}