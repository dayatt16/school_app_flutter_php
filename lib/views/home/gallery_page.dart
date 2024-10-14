import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../../controllers/home_controller.dart';
import '../../models/gallery_model.dart';
import '../shared/loading_widget.dart';

class GalleriesPage extends StatefulWidget {
  const GalleriesPage({Key? key}) : super(key: key);

  @override
  _GalleriesPageState createState() => _GalleriesPageState();
}

class _GalleriesPageState extends State<GalleriesPage> {
  final HomeController _homeController = HomeController();
  late Future<List<Gallery>> _futureGalleries;

  @override
  void initState() {
    super.initState();
    _futureGalleries = _loadGalleries();
  }

  Future<List<Gallery>> _loadGalleries() async {
    List<Gallery> galleries = await _homeController.getGalleries();
    return galleries.where((gallery) => gallery.statusGallery == 1).toList();
  }

  String formatDate(String date) {
    DateTime dateTime = DateTime.parse(date);
    return DateFormat('dd MMM, yyyy').format(dateTime);
  }

  Future<void> _refreshGalleries() async {
    setState(() {
      _futureGalleries = _loadGalleries();
    });
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
            child: RefreshIndicator(
              onRefresh: _refreshGalleries,
              child: FutureBuilder<List<Gallery>>(
                future: _futureGalleries,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return LoadingWidget(message: 'Loading Galleries...');
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No Galleries Available'));
                  } else {
                    return GridView.builder(
                      padding: const EdgeInsets.all(12.0),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        crossAxisSpacing: 12.0,
                        mainAxisSpacing: 12.0,
                        childAspectRatio: 0.8,
                      ),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        Gallery gallery = snapshot.data![index];
                        String formattedDate = formatDate(gallery.tglPostGallery!);

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
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                                        mainAxisAlignment: MainAxisAlignment.end,
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
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}