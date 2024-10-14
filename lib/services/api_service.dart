import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/information_model.dart';
import '../models/agenda_model.dart';
import '../models/gallery_model.dart';
import 'dart:io'; // Import the dart:io package to handle file input.

class ApiService {
  static const String baseUrl =
      'https://praktikum-cpanel-unbin.com/kelompok_ojan/api_school_app_fauzan'; // Ganti dengan URL API Anda

  Future<List<Agenda>> fetchAgendas() async {
    final response = await http.get(Uri.parse('$baseUrl/agendas'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'] as List;
      return data.map((json) => Agenda.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load agendas');
    }
  }

  Future<void> addAgendas(Agenda agenda) async {
    final response = await http.post(
      Uri.parse('$baseUrl/agendas'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'judul_agenda': agenda.judulAgenda,
        'isi_agenda': agenda.isiAgenda,
        'tgl_agenda': agenda.tglAgenda,
        'tgl_post_agenda': agenda.tglPostAgenda,
        'status_agenda': agenda.statusAgenda,
        'kd_petugas': agenda.kdPetugas,
      }),
    );

    if (response.statusCode != 201) {
      // Anda bisa menambahkan log atau print response.body untuk debugging
      print('Response Body: ${response.body}');
      throw Exception('Gagal menambahkan agenda');
    }
  }

  Future<void> updateAgendas(Agenda agenda) async {
    final response = await http.put(
      Uri.parse('$baseUrl/agendas/${agenda.kdAgenda}'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'judul_agenda': agenda.judulAgenda,
        'isi_agenda': agenda.isiAgenda,
        'tgl_agenda': agenda.tglAgenda,
        'tgl_post_agenda': agenda.tglPostAgenda,
        'status_agenda': agenda.statusAgenda,
        'kd_petugas': agenda.kdPetugas,
      }),
    );

    if (response.statusCode != 200) {
      // Anda bisa menambahkan log atau print response.body untuk debugging
      print('Response Body: ${response.body}');
      throw Exception('Gagal memperbarui agenda');
    }
  }

  Future<void> deleteAgendas(int kdAgenda) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/agendas/$kdAgenda'),
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal menghapus agenda');
    }
  }

  // galleries

  Future<List<Gallery>> fetchGalleries() async {
    final response = await http.get(Uri.parse('$baseUrl/galleries'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'] as List;
      return data.map((json) => Gallery.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load galleries');
    }
  }

   Future<void> addGalleries(Gallery gallery, File? imageFile) async {
  var request = http.MultipartRequest(
    'POST',
    Uri.parse('$baseUrl/galleries'),
  );

  // Attach form fields
  request.fields['judul_galery'] = gallery.judulGallery ?? '';
  request.fields['isi_galery'] = gallery.isiGallery ?? '';
  request.fields['tgl_post_galery'] = gallery.tglPostGallery ?? '';
  request.fields['status_galery'] = gallery.statusGallery?.toString() ?? '1'; // Default to 1 if null
  request.fields['kd_petugas'] = gallery.kdPetugas?.toString() ?? '1'; // Default to 1 if null

  // Attach image file if it exists
  if (imageFile != null) {
    request.files.add(
      await http.MultipartFile.fromPath(
        'foto_galery', // The field name on the server side
        imageFile.path, // The path to the image file
      ),
    );
  }

  try {
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode != 201) {
      // Decode the response body to get the error message
      final responseBody = json.decode(response.body);
      final errorMessage = responseBody['details'] ?? 'Gagal menambahkan gallery';
      throw Exception(errorMessage);
    }
  } catch (e) {
   throw Exception('Error adding gallery: ${e.toString()}');
  }
}



Future<Gallery> updateGalleries(Gallery gallery, File? imageFile) async {
  var uri = Uri.parse('$baseUrl/galleries/${gallery.kdGallery}');
  
  Map<String, dynamic> jsonData = gallery.toJson();
  
  // Hapus kunci foto_galery jika tidak ada gambar baru
  if (imageFile == null) {
    jsonData.remove('foto_galery');
  } else {
    List<int> imageBytes = await imageFile.readAsBytes();
    String base64Image = base64Encode(imageBytes);
    jsonData['foto_galery'] = 'data:image/png;base64,$base64Image';
  }

  try {
    final response = await http.put(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(jsonData),
    );

     final responseBody = json.decode(response.body);

    if (response.statusCode == 200) {
      if (responseBody['data'] is Map<String, dynamic>) {
        return Gallery.fromJson(responseBody['data']);
      } else {
        throw Exception('Invalid response format');
      }
    } else {
      throw Exception(responseBody['details'] ?? 'Gagal memperbarui gallery');
    }
  } catch (e) {
    print('Error updating gallery: $e');
   throw Exception('Error updating gallery: ${e.toString()}');
  }
}


  Future<void> deleteGalleries(int kdGallery) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/galleries/$kdGallery'),
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal menghapus gallery');
    }
  }

  // information

  Future<List<Information>> fetchInformation() async {
    final response = await http.get(Uri.parse('$baseUrl/information'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'] as List;
      return data.map((json) => Information.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load information');
    }
  }

  Future<void> addInformation(Information info) async {
    final response = await http.post(
      Uri.parse('$baseUrl/information'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'judul_info': info.judulInfo,
        'isi_info': info.isiInfo,
        'tgl_post_info': info.tglPostInfo,
        'status_info': info.statusInfo,
        'kd_petugas': info.kdPetugas,
      }),
    );

    if (response.statusCode != 201) {
      // Anda bisa menambahkan log atau print response.body untuk debugging
      print('Response Body: ${response.body}');
      throw Exception('Gagal menambahkan informasi');
    }
  }

  Future<void> updateInformation(Information info) async {
    final response = await http.put(
      Uri.parse('$baseUrl/information/${info.kdInfo}'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'judul_info': info.judulInfo,
        'isi_info': info.isiInfo,
        'tgl_post_info': info.tglPostInfo,
        'status_info': info.statusInfo,
        'kd_petugas': info.kdPetugas,
      }),
    );

    if (response.statusCode != 200) {
      // Anda bisa menambahkan log atau print response.body untuk debugging
      print('Response Body: ${response.body}');
      throw Exception('Gagal memperbarui informasi');
    }
  }

  Future<void> deleteInformation(int kdInfo) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/information/$kdInfo'),
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal menghapus informasi');
    }
  }
}
