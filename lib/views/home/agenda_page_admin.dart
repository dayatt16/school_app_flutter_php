import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../controllers/home_controller.dart';
import '../../models/agenda_model.dart';
import '../shared/loading_widget.dart';

class AgendasPageAdmin extends StatefulWidget {
  const AgendasPageAdmin({Key? key}) : super(key: key);

  @override
  _AgendasPageAdminState createState() => _AgendasPageAdminState();
}

class _AgendasPageAdminState extends State<AgendasPageAdmin> {
  final HomeController _homeController = HomeController();
  late Future<List<Agenda>> _futureAgendas;
  bool _isConnected = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _checkConnectivity().then((_) {
      if (_isConnected) {
        _loadAgenda();
      }
    });
  }

  Future<void> _checkConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      _isConnected = connectivityResult != ConnectivityResult.none;
    });
  }

  void _loadAgenda() {
    setState(() {
      _futureAgendas = _homeController.getAgendas().catchError((error) {
        setState(() {
          _errorMessage = _getErrorMessage(error);
        });
        return <Agenda>[];
      });
    });
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
    await _checkConnectivity();
    if (_isConnected) {
      _loadAgenda();
    }
  }

  Future<void> _showAgendaModal({Agenda? agenda}) async {
    final _formKey = GlobalKey<FormState>();
    String judul = agenda?.judulAgenda ?? '';
    String isi = agenda?.isiAgenda ?? '';
    String tglAgenda =
        agenda?.tglAgenda ?? DateFormat('yyyy-MM-dd').format(DateTime.now());
    String tglPostAgenda = agenda?.tglPostAgenda ??
        DateFormat('yyyy-MM-dd').format(DateTime.now());
    int statusAgenda = agenda?.statusAgenda ?? 1;
    int kdPetugas = agenda?.kdPetugas ?? 1;

    TextEditingController _tglAgendaController =
        TextEditingController(text: tglAgenda);
    TextEditingController _tglPostAgendaController =
        TextEditingController(text: tglPostAgenda);

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
                    agenda == null ? 'Tambah Agenda' : 'Edit Agenda',
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    initialValue: judul,
                    decoration: const InputDecoration(
                      labelText: 'Judul Agenda',
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
                      labelText: 'Isi Agenda',
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
                    controller: _tglAgendaController,
                    decoration: const InputDecoration(
                      labelText: 'Tanggal Agenda',
                      suffixIcon: Icon(Icons.calendar_today),
                      border: OutlineInputBorder(),
                    ),
                    readOnly: true,
                    onTap: () async {
                      DateTime initialDate =
                          DateTime.parse(_tglAgendaController.text);
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: initialDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          _tglAgendaController.text =
                              DateFormat('yyyy-MM-dd').format(pickedDate);
                        });
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Tanggal Agenda tidak boleh kosong';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      tglAgenda = value!;
                    },
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    controller: _tglPostAgendaController,
                    decoration: const InputDecoration(
                      labelText: 'Tanggal Post Agenda',
                      suffixIcon: Icon(Icons.calendar_today),
                      border: OutlineInputBorder(),
                    ),
                    readOnly: true,
                    onTap: () async {
                      DateTime initialDate =
                          DateTime.parse(_tglPostAgendaController.text);
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: initialDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          _tglPostAgendaController.text =
                              DateFormat('yyyy-MM-dd').format(pickedDate);
                        });
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Tanggal Post Agenda tidak boleh kosong';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      tglPostAgenda = value!;
                    },
                  ),
                  SizedBox(height: 15),
                  DropdownButtonFormField<int>(
                    value: statusAgenda,
                    decoration: const InputDecoration(
                      labelText: 'Status Agenda',
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
                        statusAgenda = value!;
                      });
                    },
                    onSaved: (value) {
                      statusAgenda = value!;
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Pilih status agenda';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 15),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          Agenda newAgenda = Agenda(
                            kdAgenda: agenda?.kdAgenda ?? 0,
                            judulAgenda: judul,
                            isiAgenda: isi,
                            tglAgenda: tglAgenda,
                            tglPostAgenda: tglPostAgenda,
                            statusAgenda: statusAgenda,
                            kdPetugas: kdPetugas,
                          );

                          try {
                            if (agenda == null) {
                              await _homeController.addAgendas(newAgenda);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('Agenda berhasil ditambahkan')),
                              );
                            } else {
                              await _homeController.updateAgendas(newAgenda);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('Agenda berhasil diperbarui')),
                              );
                            }
                            Navigator.of(context).pop();
                            _refreshAgendas();
                          } catch (e) {
                            print('Error: ${e.toString()}');
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error: ${e.toString()}')),
                            );
                          }
                        }
                      },
                      child: Text(agenda == null ? 'Tambah' : 'Simpan'),
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusBadge(int? status) {
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

  Future<void> _deleteAgenda(int kdAgenda) async {
    bool confirm = false;
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: const Text('Apakah Anda yakin ingin menghapus agenda ini?'),
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
        await _homeController.deleteAgendas(kdAgenda);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Agenda berhasil dihapus')),
        );
        _refreshAgendas();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
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
              color: Color.fromARGB(255, 22, 113, 205),
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
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return LoadingWidget(message: 'Loading Agenda...');
                        } else if (snapshot.hasError ||
                            _errorMessage.isNotEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(_errorMessage.isNotEmpty
                                    ? _errorMessage
                                    : 'Terjadi kesalahan'),
                                const SizedBox(height: 20),
                                ElevatedButton(
                                  onPressed: _refreshAgendas,
                                  child: const Text('Coba Lagi'),
                                ),
                              ],
                            ),
                          );
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Center(
                              child: Text('Tidak ada agenda tersedia'));
                        } else {
                          return ListView.builder(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              Agenda agenda = snapshot.data![index];
                              return Card(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 15.0),
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 80,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                            const Divider(
                                                thickness: 1.0,
                                                color: Colors.grey),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
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
                                            const SizedBox(height: 10.0),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                _buildStatusBadge(
                                                    agenda.statusAgenda),
                                                Row(
                                                  children: [
                                                    IconButton(
                                                      icon: const Icon(
                                                          Icons.edit,
                                                          color: Colors.blue),
                                                      onPressed: () =>
                                                          _showAgendaModal(
                                                              agenda: agenda),
                                                    ),
                                                    IconButton(
                                                      icon: const Icon(
                                                          Icons.delete,
                                                          color: Colors.red),
                                                      onPressed: () =>
                                                          _deleteAgenda(
                                                              agenda.kdAgenda),
                                                    ),
                                                  ],
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
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
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
      floatingActionButton: _isConnected
          ? FloatingActionButton(
              onPressed: () => _showAgendaModal(),
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
              backgroundColor: Color.fromARGB(255, 22, 113, 205),
            )
          : null,
    );
  }
}
