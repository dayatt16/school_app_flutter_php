import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../controllers/home_controller.dart';
import '../../models/information_model.dart';
import '../shared/loading_widget.dart';

class InformationPage extends StatefulWidget {
  const InformationPage({Key? key}) : super(key: key);

  @override
  _InformationPageState createState() => _InformationPageState();
}

class _InformationPageState extends State<InformationPage> {
  final HomeController _homeController = HomeController();
  late Future<List<Information>> _futureInformation;
  bool _isConnected = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
    _futureInformation = _loadInformation();
  }

  Future<void> _checkConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      _isConnected = connectivityResult != ConnectivityResult.none;
    });
  }

  Future<List<Information>> _loadInformation() async {
   List<Information> information = await _homeController.getInformation();
    return information.where((info) => info.statusInfo == 1).toList();
  }

  String _getErrorMessage(dynamic error) {
    if (error.toString().contains('SocketException') || 
        error.toString().contains('Failed host lookup')) {
      return 'Tidak dapat terhubung ke server. Periksa koneksi internet Anda atau coba lagi nanti.';
    }
    return 'Terjadi kesalahan: ${error.toString()}';
  }

  String formatDate(DateTime date) {
    return DateFormat('dd MMM, yyyy').format(date);
  }

  Future<void> _refreshInformation() async {
    setState(() {
      _errorMessage = '';
    });
    await _checkConnectivity();
    if (_isConnected) {
      setState(() {
        _futureInformation = _loadInformation();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: _isConnected
                ? RefreshIndicator(
                    onRefresh: _refreshInformation,
                    child: FutureBuilder<List<Information>>(
                      future: _futureInformation,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return LoadingWidget(message: 'Loading Information...');
                        } else if (snapshot.hasError || _errorMessage.isNotEmpty) {
                          return _buildErrorWidget();
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(child: Text('Tidak ada informasi tersedia'));
                        } else {
                          return _buildInformationList(snapshot.data!);
                        }
                      },
                    ),
                  )
                : _buildNoConnectionWidget(),
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
      child: const Center(
        child: Text(
          'Informasi',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _errorMessage.isNotEmpty ? _errorMessage : 'Terjadi kesalahan',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _refreshInformation,
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Coba Lagi'),
          ),
        ],
      ),
    );
  }

  Widget _buildNoConnectionWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.signal_wifi_off, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            'Tidak ada koneksi internet',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _refreshInformation,
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Refresh'),
          ),
        ],
      ),
    );
  }

  Widget _buildInformationList(List<Information> informationList) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: informationList.length,
      itemBuilder: (context, index) {
        Information info = informationList[index];
        DateTime dateTime = DateTime.parse(info.tglPostInfo);
        String formattedDate = formatDate(dateTime);

        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade700,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Center(
                  child: Text(
                    info.judulInfo,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  info.isiInfo,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(Icons.calendar_today, size: 16, color: Colors.blue.shade700),
                    const SizedBox(width: 8),
                    Text(
                      formattedDate,
                      style: TextStyle(fontSize: 14, color: Colors.blue.shade700),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}