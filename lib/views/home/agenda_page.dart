import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../controllers/home_controller.dart';
import '../../models/agenda_model.dart';
import '../shared/loading_widget.dart';

class AgendasPage extends StatefulWidget {
  const AgendasPage({Key? key}) : super(key: key);

  @override
  _AgendasPageState createState() => _AgendasPageState();
}

class _AgendasPageState extends State<AgendasPage> {
  final HomeController _homeController = HomeController();
  late Future<List<Agenda>> _futureAgendas;
  bool _isConnected = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
    _futureAgendas =_loadAgenda();
  }

  Future<void> _checkConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      _isConnected = connectivityResult != ConnectivityResult.none;
    });
  }

  Future<List<Agenda>> _loadAgenda() async {
    List<Agenda> agendas = await _homeController.getAgendas();
    return agendas.where((agenda) => agenda.statusAgenda == 1).toList();
  }

  String _getErrorMessage(dynamic error) {
    if (error.toString().contains('SocketException') || 
        error.toString().contains('Failed host lookup')) {
      return 'Periksa koneksi internet Anda atau coba lagi nanti.';
    }
    return 'Terjadi kesalahan: ${error.toString()}';
  }

  String formatDate(String date) {
    DateTime dateTime = DateTime.parse(date);
    return DateFormat('dd').format(dateTime);
  }

  String formatMonth(String date) {
    DateTime dateTime = DateTime.parse(date);
    return DateFormat('MMM').format(dateTime);
  }

  String formatYear(String date) {
    DateTime dateTime = DateTime.parse(date);
    return DateFormat('yyyy').format(dateTime);
  }

  Future<void> _refreshAgendas() async {
    setState(() {
      _errorMessage = '';
    });
    await _checkConnectivity();
    if (_isConnected) {
      setState(() {
        _futureAgendas = _loadAgenda();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(25.0),
            decoration: const BoxDecoration(
              color:  Color.fromARGB(255, 22, 113, 205),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
              ),
            ),
            child: const Center(
              child: Text(
                'Agenda',
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Expanded(
            child: _isConnected
                ? RefreshIndicator(
                    onRefresh: _refreshAgendas,
                    child: FutureBuilder<List<Agenda>>(
                      future: _futureAgendas,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return LoadingWidget(message: 'Loading Agenda...');
                        } else if (snapshot.hasError || _errorMessage.isNotEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(_errorMessage.isNotEmpty ? _errorMessage : 'Terjadi kesalahan'),
                                ElevatedButton(
                                  onPressed: _refreshAgendas,
                                  child: const Text('Coba Lagi'),
                                ),
                              ],
                            ),
                          );
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(child: Text('Tidak ada agenda tersedia'));
                        } else {
                          return ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              Agenda agenda = snapshot.data![index];
                              return Card(
                                margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 80,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            const Icon(
                                              Icons.calendar_today,
                                              color: Colors.blue,
                                              size: 30.0,
                                            ),
                                            const SizedBox(height: 8.0),
                                            Text(
                                              formatDate(agenda.tglAgenda),
                                              style: const TextStyle(
                                                fontSize: 24.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              formatMonth(agenda.tglAgenda),
                                              style: const TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Text(
                                              formatYear(agenda.tglAgenda),
                                              style: const TextStyle(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 16.0),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              agenda.judulAgenda,
                                              style: const TextStyle(
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black87,
                                              ),
                                            ),
                                            const SizedBox(height: 4.0),
                                            Text(
                                              agenda.isiAgenda,
                                              style: const TextStyle(
                                                fontSize: 14.0,
                                                color: Colors.black54,
                                              ),
                                            ),
                                            const SizedBox(height: 10.0),
                                            const Divider(thickness: 1.0, color: Colors.grey),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                const Icon(
                                                  Icons.post_add,
                                                  size: 16.0,
                                                  color: Colors.grey,
                                                ),
                                                const SizedBox(width: 4.0),
                                                Text(
                                                  'Posted: ${formatDate(agenda.tglPostAgenda)} ${formatMonth(agenda.tglPostAgenda)} ${formatYear(agenda.tglPostAgenda)}',
                                                  style: const TextStyle(
                                                    fontSize: 12.0,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'No internet connection',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _refreshAgendas,
                          child: const Text('Refresh'),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}