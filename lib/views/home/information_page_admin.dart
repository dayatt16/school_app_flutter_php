import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../controllers/home_controller.dart';
import '../../models/information_model.dart';
import '../shared/loading_widget.dart';

class InformationPageAdmin extends StatefulWidget {
  const InformationPageAdmin({Key? key}) : super(key: key);

  @override
  _InformationPageAdminState createState() => _InformationPageAdminState();
}

class _InformationPageAdminState extends State<InformationPageAdmin> {
  final HomeController _homeController = HomeController();
  late Future<List<Information>> _futureInformation;
  bool _isConnected = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
    _loadInformation();
  }

  Future<void> _checkConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      _isConnected = connectivityResult != ConnectivityResult.none;
    });
  }

  void _loadInformation() {
    _futureInformation = _homeController.getInformation().catchError((error) {
      setState(() {
        _errorMessage = _getErrorMessage(error);
      });
      return <Information>[];
    });
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
      _loadInformation();
    }
  }

  // Fungsi untuk menampilkan Modal Bottom Sheet tambah atau edit informasi
  Future<void> _showInformationModal({Information? info}) async {
    final _formKey = GlobalKey<FormState>();
    String judul = info?.judulInfo ?? '';
    String isi = info?.isiInfo ?? '';
    int kdPetugas = info?.kdPetugas ?? 1; // Contoh nilai
    int? statusInfo = info?.statusInfo;
    int? selectedStatus =
        statusInfo ?? 1; // Default ke 1 (Active) jika menambah

    TextEditingController _dateController = TextEditingController(
      text: info != null
          ? info.tglPostInfo
          : DateFormat('yyyy-MM-dd').format(DateTime.now()),
    );

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 20,
            left: 20,
            right: 20,
          ),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    info == null ? 'Tambah Informasi' : 'Edit Informasi',
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    initialValue: judul,
                    decoration: const InputDecoration(
                      labelText: 'Judul Informasi',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Judul tidak boleh kosong';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      judul = value!;
                    },
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    initialValue: isi,
                    decoration: const InputDecoration(
                      labelText: 'Isi Informasi',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 4,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Isi tidak boleh kosong';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      isi = value!;
                    },
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    controller: _dateController,
                    decoration: const InputDecoration(
                      labelText: 'Tanggal Post',
                      suffixIcon: Icon(Icons.calendar_today),
                      border: OutlineInputBorder(),
                    ),
                    readOnly: true,
                    onTap: () async {
                      DateTime initialDate = info != null
                          ? DateTime.parse(info.tglPostInfo)
                          : DateTime.now();
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: initialDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          _dateController.text =
                              DateFormat('yyyy-MM-dd').format(pickedDate);
                        });
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Tanggal tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 15),
                  DropdownButtonFormField<int>(
                    value: selectedStatus,
                    decoration: const InputDecoration(
                      labelText: 'Status',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 1,
                        child: Text('Aktif'),
                      ),
                      DropdownMenuItem(
                        value: 0,
                        child: Text('Tidak Aktif'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedStatus = value;
                      });
                    },
                    onSaved: (value) {
                      selectedStatus = value;
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Pilih status';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 25),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          String tanggal = _dateController.text;

                          Information newInfo = Information(
                            kdInfo: info?.kdInfo ?? 0,
                            judulInfo: judul,
                            isiInfo: isi,
                            tglPostInfo: tanggal,
                            statusInfo: selectedStatus ?? 0,
                            kdPetugas: kdPetugas,
                          );

                          try {
                            if (info == null) {
                              await _homeController.addInformation(newInfo);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('Informasi berhasil ditambahkan')),
                              );
                            } else {
                              await _homeController.updateInformation(newInfo);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('Informasi berhasil diperbarui')),
                              );
                            }
                            Navigator.of(context).pop();
                            _refreshInformation();
                          } catch (e) {
                            print('Error: ${e.toString()}');
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error: ${e.toString()}')),
                            );
                          }
                        }
                      },
                      child: Text(info == null ? 'Tambah' : 'Simpan'),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Fungsi untuk menghapus informasi
  Future<void> _deleteInformation(int kdInfo) async {
    bool confirm = false;
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: const Text('Apakah Anda yakin ingin menghapus informasi ini?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              confirm = false;
            },
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              confirm = true;
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirm) {
      try {
        await _homeController.deleteInformation(kdInfo);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Informasi berhasil dihapus')),
        );
        _refreshInformation();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  Widget _buildStatusBadge(int status) {
    Color badgeColor = status == 1 ? Colors.green : Colors.grey;
    String badgeText = status == 1 ? 'Aktif' : 'Tidak Aktif';

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        badgeText,
        style: TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _isConnected
          ? FloatingActionButton(
              onPressed: () => _showInformationModal(),
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
              backgroundColor: Color.fromARGB(255, 22, 113, 205),
            )
          : null,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(25.0),
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 22, 113, 205),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
              ),
            ),
            child: const Center(
              child: Text(
                'Information',
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshInformation,
              child: _isConnected
                  ? FutureBuilder<List<Information>>(
                      future: _futureInformation,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return LoadingWidget(
                              message: 'Loading Information...');
                        } else if (snapshot.hasError ||
                            _errorMessage.isNotEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(_errorMessage.isNotEmpty
                                    ? _errorMessage
                                    : 'Terjadi kesalahan'),
                                ElevatedButton(
                                  onPressed: _refreshInformation,
                                  child: const Text('Coba Lagi'),
                                ),
                              ],
                            ),
                          );
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Center(
                              child: Text('Tidak ada informasi tersedia'));
                        } else {
                          return ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              Information info = snapshot.data![index];
                              DateTime dateTime =
                                  DateTime.parse(info.tglPostInfo);
                              String formattedDate = formatDate(dateTime);

                              return Card(
                                margin: const EdgeInsets.all(8.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                elevation: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(16.0),
                                      decoration: const BoxDecoration(
                                        color:
                                            Color.fromARGB(255, 22, 113, 205),
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10.0),
                                          topRight: Radius.circular(10.0),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              info.judulInfo,
                                              style: const TextStyle(
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              IconButton(
                                                icon: const Icon(Icons.edit,
                                                    color: Colors.white),
                                                onPressed: () =>
                                                    _showInformationModal(
                                                        info: info),
                                              ),
                                              IconButton(
                                                icon: const Icon(Icons.delete,
                                                    color: Colors.white),
                                                onPressed: () =>
                                                    _deleteInformation(
                                                        info.kdInfo),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            info.isiInfo,
                                            style: const TextStyle(
                                              fontSize: 16.0,
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0, vertical: 10.0),
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFF0F0F0),
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(10.0),
                                          bottomRight: Radius.circular(10.0),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          _buildStatusBadge(info.statusInfo),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.calendar_today,
                                                size: 16.0,
                                                color: Colors.grey,
                                              ),
                                              const SizedBox(width: 8.0),
                                              Text(
                                                formattedDate,
                                                style: const TextStyle(
                                                  fontSize: 14.0,
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
                              );
                            },
                          );
                        }
                      },
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Tidak ada koneksi internet',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: _refreshInformation,
                            child: const Text('Refresh'),
                          ),
                        ],
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
