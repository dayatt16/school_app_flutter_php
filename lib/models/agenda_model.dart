class Agenda {
  final int kdAgenda;
  final String judulAgenda;
  final String isiAgenda;
  final String tglAgenda;
  final String tglPostAgenda;
  final int statusAgenda;
  final int kdPetugas;

  Agenda({
    required this.kdAgenda,
    required this.judulAgenda,
    required this.isiAgenda,
    required this.tglAgenda,
    required this.tglPostAgenda,
    required this.statusAgenda,
    required this.kdPetugas,
  });

  factory Agenda.fromJson(Map<String, dynamic> json) {
    return Agenda(
      kdAgenda: json['kd_agenda'],
      judulAgenda: json['judul_agenda'],
      isiAgenda: json['isi_agenda'],
      tglAgenda: json['tgl_agenda'],
      tglPostAgenda: json['tgl_post_agenda'],
      statusAgenda: json['status_agenda'],
      kdPetugas: json['kd_petugas'],
    );
  }

  get statusInfo => null;
}