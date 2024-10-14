<?php

require_once __DIR__ . '/../models/galleryModel.php';
require_once __DIR__ . '/../utils/response.php';
require_once __DIR__ . '/../utils/validation.php';

define('IMAGE_DIR', 'uploads/');
define('PLACEHOLDER_IMAGE', 'placeholder_image.png');
define('MAX_FILE_SIZE', 2 * 1024 * 1024);
define('ALLOWED_TYPES', ['image/jpeg', 'image/jpg', 'image/png', 'image/gif']);



function handleGetGaleryRequest($kd_galery = null)
{
    if ($kd_galery) {
        $galery = getGaleryById($kd_galery);
        if ($galery) {
            sendResponse(200, 'Gallery ditemukan', $galery);
        } else {
            notFoundResponse("Gallery tidak ditemukan");
        }
    } else {
        $galery_items = getAllGalery();
        sendResponse(200, 'Daftar Gallery', $galery_items);
    }
}

function handleCreateGaleryRequest()
{
    $input = $_POST;

    $requiredFields = ['judul_galery', 'isi_galery', 'tgl_post_galery', 'status_galery', 'kd_petugas'];
    $missingFields = validateRequiredFields($input, $requiredFields);
    if (!empty($missingFields)) {
        badRequestResponse("Ada field yang belum diisi", $missingFields);
    }
    // Validasi khusus untuk status_galery
    if (!in_array($input['status_galery'], ['0', '1', 0, 1], true)) {
        badRequestResponse("Status galery harus 0 atau 1");
    }

    $fileName = PLACEHOLDER_IMAGE;

    if (isset($_FILES['foto_galery']) && $_FILES['foto_galery']['error'] !== UPLOAD_ERR_NO_FILE) {
        $file = $_FILES['foto_galery'];
        if (!validateUploadedFile($file)) {
            badRequestResponse("File tidak valid", ['file_error' => 'File harus berupa gambar (jpg, png, gif) dan kurang dari 2MB']);
        }

        $fileExtension = pathinfo($file['name'], PATHINFO_EXTENSION);
        $fileName = generateRandomFileName($fileExtension);
        $filePath = IMAGE_DIR . $fileName;
        if (!move_uploaded_file($file['tmp_name'], $filePath)) {
            internalServerErrorResponse("Gagal mengunggah gambar.");
        }
    }

    $newGalery = createGalery(
        $input['judul_galery'],
        $fileName,
        $input['isi_galery'],
        $input['tgl_post_galery'],
        $input['status_galery'],
        $input['kd_petugas']
    );
    if ($newGalery) {
        sendResponse(201, 'Gallery berhasil dibuat', $newGalery);
    } else {
        internalServerErrorResponse("Gagal membuat gallery");
    }
}

function handleUpdateGaleryRequest($kd_galery)
{
    if (!$kd_galery) {
        badRequestResponse("ID Gallery diperlukan");
    }

    $existingGalery = getGaleryById($kd_galery);
    if (!$existingGalery) {
        notFoundResponse("Gallery tidak ditemukan");
    }

    // Ambil raw input
    $input = json_decode(file_get_contents('php://input'), true);
    if (json_last_error() !== JSON_ERROR_NONE) {
        badRequestResponse("Invalid JSON data");
    }

    $requiredFields = ['judul_galery', 'isi_galery', 'tgl_post_galery', 'status_galery', 'kd_petugas'];
    $missingFields = validateRequiredFields($input, $requiredFields);
    if (!empty($missingFields)) {
        badRequestResponse("Ada field yang belum diisi", $missingFields);
    }
    
    // Validasi khusus untuk status_galery
    if (!in_array($input['status_galery'], ['0', '1', 0, 1], true)) {
        badRequestResponse("Status galery harus 0 atau 1");
    }

    // Periksa apakah ada perubahan data
    $isDataChanged = false;
    foreach ($requiredFields as $field) {
        if ($field !== 'foto_galery' && $existingGalery[$field] != $input[$field]) {
            $isDataChanged = true;
            break;
        }
    }

    // Gunakan foto yang ada jika tidak ada foto baru
    $fileName = $existingGalery['foto_galery'];

    // Jika ada data foto baru (dalam bentuk base64), proses uploadnya
    if (isset($input['foto_galery']) && !empty($input['foto_galery'])) {
        $isDataChanged = true;
        $base64Image = $input['foto_galery'];
        $imageData = base64_decode(preg_replace('#^data:image/\w+;base64,#i', '', $base64Image));
        
        $fileInfo = finfo_open();
        $mimeType = finfo_buffer($fileInfo, $imageData, FILEINFO_MIME_TYPE);
        finfo_close($fileInfo);

        if (!in_array($mimeType, ALLOWED_TYPES)) {
            badRequestResponse("File tidak valid", ['file_error' => 'File harus berupa gambar (jpg, png, gif)']);
        }

        if (strlen($imageData) > MAX_FILE_SIZE) {
            badRequestResponse("File tidak valid", ['file_error' => 'Ukuran file tidak boleh lebih dari 2MB']);
        }

        $fileExtension = explode('/', $mimeType)[1];
        $fileName = generateRandomFileName($fileExtension);
        $filePath = IMAGE_DIR . $fileName;
        
        if (!file_put_contents($filePath, $imageData)) {
            internalServerErrorResponse("Gagal mengunggah gambar.");
        }

        // Hapus file lama jika bukan placeholder
        if ($existingGalery['foto_galery'] !== PLACEHOLDER_IMAGE && file_exists(IMAGE_DIR . $existingGalery['foto_galery'])) {
            unlink(IMAGE_DIR . $existingGalery['foto_galery']);
        }
    }

    if (!$isDataChanged) {
        // Jika tidak ada perubahan, kirim respons sukses tanpa melakukan update
        sendResponse(200, "Tidak ada perubahan pada gallery", $existingGalery);
        return;
    }

    $updatedGalery = updateGalery(
        $kd_galery,
        $input['judul_galery'],
        $fileName,
        $input['isi_galery'],
        $input['tgl_post_galery'],
        (int)$input['status_galery'], // Konversi ke integer
        $input['kd_petugas']
    );

    if ($updatedGalery) {
        sendResponse(200, 'Gallery berhasil diperbarui', $updatedGalery);
    } else {
        internalServerErrorResponse("Gagal memperbarui gallery");
    }
}


function handleDeleteGaleryRequest($kd_galery)
{
    if (!$kd_galery) {
        badRequestResponse("ID Gallery diperlukan");
    }

    $existingGalery = getGaleryById($kd_galery);
    if (!$existingGalery) {
        notFoundResponse("Gallery tidak ditemukan");
    }

    // Hapus file gambar jika bukan placeholder
    if ($existingGalery['foto_galery'] !== PLACEHOLDER_IMAGE) {
        $filePath = IMAGE_DIR . $existingGalery['foto_galery'];
        if (file_exists($filePath)) {
            unlink($filePath);
        }
    }

    $deleted = deleteGalery($kd_galery);
    if ($deleted) {
        sendResponse(200, 'Gallery berhasil dihapus');
    } else {
        internalServerErrorResponse("Gagal menghapus gallery");
    }
}

function generateRandomFileName($extension)
{
    $randomString = bin2hex(random_bytes(16));
    return $randomString . '.' . $extension;
}
