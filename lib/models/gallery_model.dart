class Gallery {
  final int? kdGallery;
  final String? judulGallery;
  final String? fotoGallery;
  final String? isiGallery;
  final String? tglPostGallery;
  final int? statusGallery;
  final int? kdPetugas;

  Gallery({
    this.kdGallery,
    this.judulGallery,
    this.fotoGallery,
    this.isiGallery,
    this.tglPostGallery,
    this.statusGallery,
    this.kdPetugas,
  });

  factory Gallery.fromJson(Map<String, dynamic> json) {
    return Gallery(
      kdGallery: json['kd_galery'] != null ? int.parse(json['kd_galery'].toString()) : null,
      judulGallery: json['judul_galery'],
      fotoGallery: json['foto_galery'],
      isiGallery: json['isi_galery'],
      tglPostGallery: json['tgl_post_galery'],
      statusGallery: json['status_galery'] != null ? int.parse(json['status_galery'].toString()) : null,
      kdPetugas: json['kd_petugas'] != null ? int.parse(json['kd_petugas'].toString()) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'kd_galery': kdGallery?.toString(),
      'judul_galery': judulGallery,
      'foto_galery': fotoGallery,
      'isi_galery': isiGallery,
      'tgl_post_galery': tglPostGallery,
      'status_galery': statusGallery?.toString(),
      'kd_petugas': kdPetugas?.toString(),
    };
  }
}