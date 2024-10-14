import 'dart:io';

import '../services/api_service.dart';
import '../models/information_model.dart';
import '../models/agenda_model.dart';
import '../models/gallery_model.dart';

class HomeController {
  final ApiService _apiService = ApiService();

  Future<List<Agenda>> getAgendas() {
    return _apiService.fetchAgendas();
  }
  Future<void> addAgendas(Agenda agenda) {
    return _apiService.addAgendas(agenda);
  }

  Future<void> updateAgendas(Agenda agenda) {
    return _apiService.updateAgendas(agenda);
  }

  Future<void> deleteAgendas(int kdAgenda) {
    return _apiService.deleteAgendas(kdAgenda);
  }
// gallery
  Future<List<Gallery>> getGalleries() {
    return _apiService.fetchGalleries();
  }

  Future<void> addGalleries(Gallery gallery,File imageFile) {
    return _apiService.addGalleries(gallery,imageFile);
  }

  Future<Gallery> updateGalleries(Gallery gallery, File? imageFile) async {
  return await _apiService.updateGalleries(gallery, imageFile);
}

  Future<void> deleteGalleries(int kdGallery) {
    return _apiService.deleteGalleries(kdGallery);
  }

  // information

  Future<List<Information>> getInformation() {
    return _apiService.fetchInformation();
  }

  Future<void> addInformation(Information info) {
    return _apiService.addInformation(info);
  }

  Future<void> updateInformation(Information info) {
    return _apiService.updateInformation(info);
  }

  Future<void> deleteInformation(int kdInfo) {
    return _apiService.deleteInformation(kdInfo);
  }
}
