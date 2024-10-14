class Information {
  final int kdInfo;
  final String judulInfo;
  final String isiInfo;
  final String tglPostInfo;
  final int statusInfo;
  final int kdPetugas;

  Information({
    required this.kdInfo,
    required this.judulInfo,
    required this.isiInfo,
    required this.tglPostInfo,
    required this.statusInfo,
    required this.kdPetugas,
  });

  factory Information.fromJson(Map<String, dynamic> json) {
    return Information(
      kdInfo: json['kd_info'],
      judulInfo: json['judul_info'],
      isiInfo: json['isi_info'],
      tglPostInfo: json['tgl_post_info'],
      statusInfo: json['status_info'],
      kdPetugas: json['kd_petugas'],
    );
  }
}