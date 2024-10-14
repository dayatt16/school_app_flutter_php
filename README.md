# School App MP4

School App MP4 adalah aplikasi Flutter yang dirancang untuk manajemen sekolah, dengan backend RESTful API menggunakan PHP native. Aplikasi ini mendukung dua peran: murid untuk mendapatkan data dan petugas untuk melakukan CRUD pada informasi, agenda, dan galeri.

## Fitur

- **Murid**: Dapat melihat data sekolah yang relevan.
- **Petugas**: Dapat mengelola informasi sekolah, termasuk menambah, mengedit, dan menghapus data terkait informasi, agenda, dan galeri.

## Teknologi yang Digunakan

- **Flutter**: Untuk pengembangan aplikasi mobile.
- **PHP Native**: Untuk backend RESTful API.
- **HTTP**: Untuk komunikasi antara aplikasi dan server.
- **Persistent Bottom Nav Bar**: Untuk navigasi yang konsisten.
- **Cached Network Image**: Untuk caching gambar.
- **Intl**: Untuk internasionalisasi.
- **Connectivity Plus**: Untuk memeriksa status koneksi.
- **Image Picker**: Untuk memilih gambar dari galeri atau kamera.
- **Dotted Border**: Untuk membuat border dengan titik-titik.
- **FL Chart**: Untuk menampilkan grafik.

## Instalasi

1. **Clone repository ini**:
   ```bash
   git clone https://github.com/username/school_app_mp4.git
   ```
2. **Navigasi ke direktori proyek**:
   ```bash
   cd school_app_mp4
   ```
3. **Install dependencies**:
   ```bash
   flutter pub get
   ```

## Menjalankan Aplikasi

1. **Jalankan aplikasi di emulator atau perangkat fisik**:
   ```bash
   flutter run
   ```

## Struktur Proyek

- `lib/`: Berisi kode sumber aplikasi Flutter.
- `assets/`: Berisi gambar dan font yang digunakan dalam aplikasi.
- `pubspec.yaml`: Berisi informasi proyek dan dependencies.

## Dokumentasi API

### Endpoint Informasi

- **GET /information**: Mendapatkan daftar semua informasi.
  - **Response**: JSON array dari objek informasi.

- **GET /information/{id}**: Mendapatkan detail informasi berdasarkan ID.
  - **Response**: JSON objek dari informasi.

- **POST /information**: Menambah informasi baru.
  - **Body**: JSON objek dengan detail informasi.
  - **Response**: JSON objek dari informasi yang baru ditambahkan.

- **PUT /information/{id}**: Memperbarui informasi berdasarkan ID.
  - **Body**: JSON objek dengan detail informasi yang diperbarui.
  - **Response**: JSON objek dari informasi yang diperbarui.

- **DELETE /information/{id}**: Menghapus informasi berdasarkan ID.
  - **Response**: Status penghapusan.

### Endpoint Agenda

- **GET /agendas**: Mendapatkan daftar semua agenda.
  - **Response**: JSON array dari objek agenda.

- **GET /agendas/{id}**: Mendapatkan detail agenda berdasarkan ID.
  - **Response**: JSON objek dari agenda.

- **POST /agendas**: Menambah agenda baru.
  - **Body**: JSON objek dengan detail agenda.
  - **Response**: JSON objek dari agenda yang baru ditambahkan.

- **PUT /agendas/{id}**: Memperbarui agenda berdasarkan ID.
  - **Body**: JSON objek dengan detail agenda yang diperbarui.
  - **Response**: JSON objek dari agenda yang diperbarui.

- **DELETE /agendas/{id}**: Menghapus agenda berdasarkan ID.
  - **Response**: Status penghapusan.

### Endpoint Galeri

- **GET /galleries**: Mendapatkan daftar semua galeri.
  - **Response**: JSON array dari objek galeri.

- **GET /galleries/{id}**: Mendapatkan detail galeri berdasarkan ID.
  - **Response**: JSON objek dari galeri.

- **POST /galleries**: Menambah gambar ke galeri.
  - **Body**: JSON objek dengan detail gambar.
  - **Response**: JSON objek dari gambar yang baru ditambahkan.

- **PUT /galleries/{id}**: Memperbarui gambar di galeri berdasarkan ID.
  - **Body**: JSON objek dengan detail gambar yang diperbarui.
  - **Response**: JSON objek dari gambar yang diperbarui.

- **DELETE /galleries/{id}**: Menghapus gambar dari galeri berdasarkan ID.
  - **Response**: Status penghapusan.

## Demo APK

Anda dapat mengunduh APK demo dari aplikasi ini melalui tautan berikut: [Download APK](https://github.com/dayatt16/school_portal_flutter_php/blob/main/apk_school_portal/school.apk)

## Kontribusi

Kontribusi sangat diterima! Silakan fork repository ini dan buat pull request untuk perubahan yang ingin Anda usulkan.

## Lisensi

Proyek ini dilisensikan di bawah [MIT License](LICENSE).

## Kontak

Untuk pertanyaan lebih lanjut, silakan hubungi [email@example.com](mailto:email@example.com).
