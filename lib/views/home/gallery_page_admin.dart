import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../controllers/home_controller.dart';
import '../../models/gallery_model.dart';
import '../shared/loading_widget.dart';

class GalleriesPageAdmin extends StatefulWidget {
  const GalleriesPageAdmin({Key? key}) : super(key: key);

  @override
  _GalleriesPageAdminState createState() => _GalleriesPageAdminState();
}

class _GalleriesPageAdminState extends State<GalleriesPageAdmin> {
  final HomeController _homeController = HomeController();
  List<Gallery> _galleries = [];
  bool _isLoading = false;
  bool _isConnected = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await _checkConnectivity();
    if (_isConnected) {
      _loadGalleries();
    }
  }

  Future<void> _checkConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    bool connected = connectivityResult != ConnectivityResult.none;

    setState(() {
      _isConnected = connected;
    });
  }

  void _loadGalleries() {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    _homeController.getGalleries().then((galleries) {
      setState(() {
        _galleries = galleries;
        _isLoading = false;
      });
    }).catchError((error) {
      setState(() {
        _errorMessage = _getErrorMessage(error);
        _isLoading = false;
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
    return DateFormat('dd MMM, yyyy').format(dateTime);
  }

  Future<void> _refreshGalleries() async {
    setState(() {
      _errorMessage = '';
    });
    await _checkConnectivity();
    if (_isConnected) {
      _loadGalleries();
    }
  }

  Future<void> _updateGallery(Gallery gallery, File? imageFile) async {
    try {
      final updatedGallery = await _homeController.updateGalleries(gallery, imageFile);
      setState(() {
        int index = _galleries.indexWhere((g) => g.kdGallery == updatedGallery.kdGallery);
        if (index != -1) {
          _galleries[index] = updatedGallery;
        } else {
          print('Galeri dengan id ${updatedGallery.kdGallery} tidak ditemukan');
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Galeri berhasil diperbarui')),
      );
      Navigator.of(context).pop();
    } catch (e) {
      String errorMessage = e.toString().replaceAll('Exception: ', '');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _showGalleryModal({Gallery? gallery}) async {
    final _formKey = GlobalKey<FormState>();
    String judul = gallery?.judulGallery ?? '';
    String isi = gallery?.isiGallery ?? '';
    String tglPostGallery = gallery?.tglPostGallery ??
        DateFormat('yyyy-MM-dd').format(DateTime.now());
    int statusGallery = gallery?.statusGallery ?? 1;
    int kdPetugas = gallery?.kdPetugas ?? 1;

    File? _selectedImage;
    String _imageUrl = gallery?.fotoGallery ?? '';

    TextEditingController _tglPostGalleryController =
        TextEditingController(text: tglPostGallery);

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
          child: StatefulBuilder(
            builder: (context, setStateModal) {
              Future<void> _pickImage() async {
                final ImagePicker _picker = ImagePicker();
                final XFile? pickedFile =
                    await _picker.pickImage(source: ImageSource.gallery);
                if (pickedFile != null) {
                  setStateModal(() {
                    _selectedImage = File(pickedFile.path);
                    _imageUrl = '';
                  });
                }
              }

              return SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        gallery == null ? 'Tambah Galeri' : 'Edit Galeri',
                        style: const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        initialValue: judul,
                        decoration: const InputDecoration(
                          labelText: 'Judul Galeri',
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
                          labelText: 'Isi Galeri',
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
                        controller: _tglPostGalleryController,
                        decoration: const InputDecoration(
                          labelText: 'Tanggal Post Galeri',
                          suffixIcon: Icon(Icons.calendar_today),
                          border: OutlineInputBorder(),
                        ),
                        readOnly: true,
                        onTap: () async {
                          DateTime initialDate =
                              DateTime.parse(_tglPostGalleryController.text);
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: initialDate,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (pickedDate != null) {
                            setStateModal(() {
                              _tglPostGalleryController.text =
                                  DateFormat('yyyy-MM-dd').format(pickedDate);
                            });
                          }
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Tanggal Post Galeri tidak boleh kosong';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          tglPostGallery = value!;
                        },
                      ),
                      SizedBox(height: 15),
                      GestureDetector(
                        onTap: _pickImage,
                        child: DottedBorder(
                          color: Colors.blue,
                          strokeWidth: 2,
                          dashPattern: [6, 3],
                          borderType: BorderType.RRect,
                          radius: Radius.circular(12),
                          child: Container(
                            height: 150,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: _selectedImage != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.file(
                                      _selectedImage!,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                    ),
                                  )
                                : _imageUrl.isNotEmpty
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              'https://praktikum-cpanel-unbin.com/kelompok_ojan/api_school_app_fauzan/uploads/${_imageUrl}',
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          placeholder: (context, url) => Center(
                                              child:
                                                  CircularProgressIndicator()),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                        ),
                                      )
                                    : Center(
                                        child: Text(
                                          'Pilih Gambar',
                                          style: TextStyle(
                                              color: Colors.blue, fontSize: 16),
                                        ),
                                      ),
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      DropdownButtonFormField<int?>(
                        value: statusGallery,
                        decoration: const InputDecoration(
                          labelText: 'Status Galeri',
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
                          if (value != null) {
                            setStateModal(() {
                              statusGallery = value;
                            });
                          }
                        },
                        onSaved: (value) {
                          statusGallery = value ?? 0;
                        },
                      ),
                      SizedBox(height: 25),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();

                              if (_selectedImage == null && _imageUrl.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Silakan pilih gambar')),
                                );
                                return;
                              }

                              Gallery newGallery = Gallery(
                                kdGallery: gallery?.kdGallery ?? 0,
                                judulGallery: judul,
                                isiGallery: isi,
                                tglPostGallery: tglPostGallery,
                                statusGallery: statusGallery,
                                fotoGallery: _selectedImage != null ? '' : _imageUrl,
                                kdPetugas: kdPetugas,
                              );

                              try {
                                if (gallery == null) {
                                  await _homeController.addGalleries(newGallery, _selectedImage!);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Galeri berhasil ditambahkan')),
                                  );
                                  Navigator.of(context).pop();
                                  _refreshGalleries();
                                } else {
                                  await _updateGallery(newGallery, _selectedImage);
                                }
                              } catch (e) {
                                String errorMessage = e.toString().replaceAll('Exception: ', '');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(errorMessage),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          },
                          child: Text(gallery == null ? 'Tambah' : 'Simpan'),
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Future<void> _deleteGallery(int kdGallery) async {
    bool confirm = false;
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: const Text('Apakah Anda yakin ingin menghapus galeri ini?'),
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
        await _homeController.deleteGalleries(kdGallery);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Galeri berhasil dihapus')),
        );
        _refreshGalleries();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
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
                'Gallery',
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
                  onRefresh: _refreshGalleries,
                  child: _isLoading
                    ? LoadingWidget(message: 'Loading Galleries...')
                    : _errorMessage.isNotEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(_errorMessage),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: _refreshGalleries,
                                child: const Text('Coba Lagi'),
                              ),
                            ],
                          ),
                        )
                      : _galleries.isEmpty
                        ? const Center(child: Text('Tidak ada galeri tersedia'))
                        : GridView.builder(
  padding: const EdgeInsets.all(12.0),
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 1,
    crossAxisSpacing: 12.0,
    mainAxisSpacing: 12.0,
    childAspectRatio: 0.8,
  ),
  itemCount: _galleries.length,
  itemBuilder: (context, index) {
    Gallery gallery = _galleries[index];
    String formattedDate = gallery.tglPostGallery != null
        ? formatDate(gallery.tglPostGallery!)
        : 'Tanggal tidak tersedia';

    return Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 22, 113, 205),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    gallery.judulGallery ?? 'Judul tidak tersedia',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                PopupMenuButton<String>(
                  icon: Icon(Icons.more_vert, color: Colors.white),
                  onSelected: (String result) {
                    if (result == 'edit') {
                      _showGalleryModal(gallery: gallery);
                    } else if (result == 'delete') {
                      _deleteGallery(gallery.kdGallery!);
                    }
                  },
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      value: 'edit',
                      child: Text('Edit'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'delete',
                      child: Text('Hapus'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              height: 200,
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: CachedNetworkImage(
                  imageUrl: 'https://praktikum-cpanel-unbin.com/kelompok_ojan/api_school_app_fauzan/uploads/${gallery.fotoGallery}',
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Image.network(
                    'https://praktikum-cpanel-unbin.com/kelompok_ojan/api_school_app_fauzan/uploads/placeholder_image.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(15.0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    gallery.isiGallery ?? 'Isi tidak tersedia',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 14.0, color: Colors.black87),
                    textAlign: TextAlign.center,
                  ),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStatusBadge(gallery.statusGallery),
                      Row(
                        children: [
                          Icon(Icons.calendar_today, size: 14.0, color: Colors.grey),
                          SizedBox(width: 4.0),
                          Text(
                            formattedDate,
                            style: TextStyle(fontSize: 12.0, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
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
                        onPressed: _refreshGalleries,
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
            onPressed: () => _showGalleryModal(),
            child: const Icon(Icons.add, color: Colors.white),
            backgroundColor: const Color.fromARGB(255, 22, 113, 205),
          )
        : null,
    );
  }
}