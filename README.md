# School App

School App adalah aplikasi Flutter yang dirancang untuk manajemen sekolah, dengan backend RESTful API menggunakan PHP native. Aplikasi ini mendukung dua peran: murid untuk mendapatkan data dan petugas untuk melakukan CRUD pada informasi, agenda, dan galeri.

## Fitur

- **Murid**: Dapat melihat data sekolah yang relevan.
- **Petugas**: Dapat mengelola informasi sekolah, termasuk menambah, mengedit, dan menghapus data terkait informasi, agenda, dan galeri.

## Teknologi yang Digunakan

- **Flutter**: Untuk pengembangan aplikasi mobile.
- **PHP Native**: Untuk backend RESTful API.

## Library Flutter yang Digunakan

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
   git clone https://github.com/dayatt16/school_app_flutter_php.git
   ```
2. **Navigasi ke direktori proyek**:
   ```bash
   cd school_app_flutter_php
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

- **GET `/information`**: Menampilkan daftar semua informasi.
  - **Response**:
    ```json
    {
      "status_code": 200,
      "message": "List of Information",
      "data": [
        {
          "kd_info": 1,
          "judul_info": "Pengumuman Ujian Nasional",
          "isi_info": "Ujian Nasional akan dilaksanakan pada tanggal 10-15 Agustus 2024. Harap siswa mempersiapkan diri dengan baik dan mengikuti petunjuk yang diberikan.",
          "tgl_post_info": "2024-06-01",
          "status_info": 1,
          "kd_petugas": 1
        }
      ]
    }
    ```

- **GET `/information/{id}`**: Menampilkan informasi berdasarkan ID.
  - **Response**:
    ```json
    {
      "status_code": 200,
      "message": "Information found",
      "data": {
        "kd_info": 1,
        "judul_info": "Pengumuman Ujian Nasional",
        "isi_info": "Ujian Nasional akan dilaksanakan pada tanggal 10-15 Agustus 2024. Harap siswa mempersiapkan diri dengan baik dan mengikuti petunjuk yang diberikan.",
        "tgl_post_info": "2024-06-01",
        "status_info": 1,
        "kd_petugas": 1
      }
    }
    ```

- **POST `/information`**: Menambah informasi baru.
  - **Request Body**:
    ```json
    {
      "judul_info": "Judul Baru",
      "isi_info": "Isi informasi baru",
      "tgl_post_info": "2023-10-03",
      "status_info": 1,
      "kd_petugas": 125
    }
    ```
  - **Response**:
    ```json
    {
      "status_code": 201,
      "message": "Information created successfully",
      "data": {
        "kd_info": 3,
        "judul_info": "Judul Baru",
        "isi_info": "Isi informasi baru",
        "tgl_post_info": "2023-10-03",
        "status_info": 1,
        "kd_petugas": 125
      }
    }
    ```

- **PUT `/information/{id}`**: Memperbarui informasi berdasarkan ID.
  - **Request Body**:
    ```json
    {
      "judul_info": "Judul Diperbarui",
      "isi_info": "Isi informasi diperbarui",
      "tgl_post_info": "2023-10-01",
      "status_info": 1,
      "kd_petugas": 123
    }
    ```
  - **Response**:
    ```json
    {
      "status_code": 200,
      "message": "Informasi berhasil diperbarui",
      "data": {
        "kd_info": 1,
        "judul_info": "Judul Diperbarui",
        "isi_info": "Isi informasi diperbarui",
        "tgl_post_info": "2023-10-01",
        "status_info": 1,
        "kd_petugas": 123
      }
    }
    ```

- **DELETE `/information/{id}`**: Menghapus informasi berdasarkan ID.
  - **Response**:
    ```json
    {
      "status_code": 200,
      "message": "Resource successfully deleted.",
      "data": {
        "kd_info": 1
      }
    }
    ```

### Endpoint Agenda

- **GET `/agendas`**: Menampilkan daftar semua agenda.
  - **Response**:
    ```json
    {
      "status_code": 200,
      "message": "List of Agenda",
      "data": [
        {
          "kd_agenda": 1,
          "judul_agenda": "Kegiatan OSIS",
          "isi_agenda": "OSIS akan mengadakan bakti sosial di panti asuhan pada tanggal 01 Juli 2024. Semua siswa diundang untuk berpartisipasi dan memberikan kontribusi positif.",
          "tgl_agenda": "2024-07-01",
          "tgl_post_agenda": "2024-04-30",
          "status_agenda": 1,
          "kd_petugas": 1
        }
      ]
    }
    ```

- **GET `/agendas/{id}`**: Menampilkan detail agenda berdasarkan ID.
  - **Response**:
    ```json
    {
      "status_code": 200,
      "message": "Agenda found",
      "data": {
        "kd_agenda": 1,
        "judul_agenda": "Kegiatan OSIS",
        "isi_agenda": "OSIS akan mengadakan bakti sosial di panti asuhan pada tanggal 01 Juli 2024. Semua siswa diundang untuk berpartisipasi dan memberikan kontribusi positif.",
        "tgl_agenda": "2024-07-01",
        "tgl_post_agenda": "2024-04-30",
        "status_agenda": 1,
        "kd_petugas": 1
      }
    }
    ```

- **POST `/agendas`**: Menambah agenda baru.
  - **Request Body**:
    ```json
    {
      "judul_agenda": "Judul Agenda Baru",
      "isi_agenda": "Isi agenda baru",
      "tgl_agenda": "2023-10-05",
      "tgl_post_agenda": "2023-09-01",
      "status_agenda": 1,
      "kd_petugas": 125
    }
    ```
  - **Response**:
    ```json
    {
      "status_code": 201,
      "message": "Agenda created successfully",
      "data": {
        "kd_agenda": 2,
        "judul_agenda": "Judul Agenda Baru",
        "isi_agenda": "Isi agenda baru",
        "tgl_agenda": "2023-10-05",
        "tgl_post_agenda": "2023-09-01",
        "status_agenda": 1,
        "kd_petugas": 125
      }
    }
    ```

- **PUT `/agendas/{id}`**: Memperbarui agenda berdasarkan ID.
  - **Request Body**:
    ```json
    {
      "judul_agenda": "Judul Agenda Diperbarui",
      "isi_agenda": "Isi agenda diperbarui",
      "tgl_agenda": "2023-10-05",
      "tgl_post_agenda": "2023-09-01",
      "status_agenda": 1,
      "kd_petugas": 123
    }
    ```
  - **Response**:
    ```json
    {
      "status_code": 200,
      "message": "Agenda berhasil diperbarui",
      "data": {
        "kd_agenda": 1,
        "judul_agenda": "Judul Agenda Diperbarui",
        "isi_agenda": "Isi agenda diperbarui",
        "tgl_agenda": "2023-10-05",
        "tgl_post_agenda": "2023-09-01",
        "status_agenda": 1,
        "kd_petugas": 123
      }
    }
    ```

- **DELETE `/agendas/{id}`**: Menghapus agenda berdasarkan ID.
  - **Response**:
    ```json
    {
      "status_code": 200,
      "message": "Resource successfully deleted.",
      "data": {
        "kd_agenda": 1
      }
    }
    ```

### Endpoint Galeri

- **GET `/galleries`**: Menampilkan daftar semua galeri.
  - **Response**:
    ```json
    {
      "status_code": 200,
      "message": "List of Gallery",
      "data": [
        {
          "kd_galery": 1,
          "judul_galery": "judul testing",
          "foto_galery": "fea63e538e8049d684e420010767ec21.jpeg",
          "isi_galery": "isi testing",
          "tgl_post_galery": "2024-10-14",
          "status_galery": 1,
          "kd_petugas": 1
        }
      ]
    }
    ```

- **GET `/galleries/{id}`**: Menampilkan detail galeri berdasarkan ID.
  - **Response**:
    ```json
    {
      "status_code": 200,
      "message": "Gallery found",
      "data": {
        "kd_galery": 1,
          "judul_galery": "judul testing",
          "foto_galery": "fea63e538e8049d684e420010767ec21.jpeg",
          "isi_galery": "isi testing",
          "tgl_post_galery": "2024-10-14",
          "status_galery": 1,
          "kd_petugas": 1
      }
    }
    ```

- **POST `/galleries`**: Menambah gambar ke galeri.
  - **Request Body**:
    ![Contoh Permintaan Postman](https://raw.githubusercontent.com/dayatt16/school_portal_flutter_php/main/assets/images/post-gallery.png)
  - **Response**:
    ```json
    {
      "status_code": 201,
      "message": "Gallery created successfully",
      "data": {
        "kd_galery": 69,
        "judul_galery": "judul baru",
        "foto_galery": "fea63e538e8049d684e456010767ec13.jpeg",
        "isi_galery": "isi baru",
        "tgl_post_galery": "2024-10-14",
        "status_galery": 1,
        "kd_petugas": 1
      }
    }
    ```

- **PUT `/galleries/{id}`**: Memperbarui gambar di galeri berdasarkan ID.
  - **Request Body**:
    ```json
    {
      "judul_galery": "Pameran Seni Diperbarui",
      "isi_galery": "Pameran seni tahunan sekolah yang diperbarui.",
      "tgl_post_galery": "2023-10-02",
      "status_galery": 1,
      "kd_petugas": 102,
      "foto_galery": "data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD..."
    }
    ```
  - **Response**:
    ```json
    {
      "status_code": 201,
      "message": "Gallery berhasil diperbarui",
      "data": {
        "kd_galery": 69,
        "judul_galery": "judul baru",
        "foto_galery": "fea63e538e8049d684e456010767ec13.jpeg",
        "isi_galery": "isi baru",
        "tgl_post_galery": "2024-10-14",
        "status_galery": 1,
        "kd_petugas": 1
      }
    }
    ```

- **DELETE `/galleries/{id}`**: Menghapus gambar dari galeri berdasarkan ID.
  - **Response**:
    ```json
    {
      "status_code": 200,
      "message": "Gallery berhasil dihapus",
      "data": null
    }
    ```
## Demo APK

Anda dapat mengunduh APK demo dari aplikasi ini melalui tautan berikut: [Download APK](https://github.com/dayatt16/school_app_flutter_php/raw/main/apk_school/school.apk)

### Akun Demo

- **Petugas**
  - **Username**: petugas
  - **Password**: 123

- **Murid**
  - **Username**: murid
  - **Password**: 123
