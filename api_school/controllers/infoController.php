<?php

require_once __DIR__ . '/../models/infoModel.php';
require_once __DIR__ . '/../utils/response.php';
require_once __DIR__ . '/../utils/validation.php';

function handleGetInfoRequest($kd_info = null)
{
    if ($kd_info) {
        $info = getInfoById($kd_info);

        if ($info) {
            sendResponse(200, 'Information found', $info);
        } else {
            notFoundResponse("Information not found");
        }
    } else {
        $info_items = getAllInfo();
        sendResponse(200, 'List of Information', $info_items);
    }
}

function handleCreateInfoRequest()
{
    $input = json_decode(file_get_contents('php://input'), true);
    $requiredFields = ['judul_info', 'isi_info', 'tgl_post_info', 'status_info', 'kd_petugas'];
    $missingFields = validateRequiredFields($input, $requiredFields);
    if (!empty($missingFields)) {
        badRequestResponse("Missing required fields", $missingFields);
    }
    if (!in_array($input['status_info'], ['0', '1', 0, 1], true)) {
        badRequestResponse("Status info harus 0 atau 1");
    }

    $newInfo = createInfo($input['judul_info'], $input['isi_info'], $input['tgl_post_info'], $input['status_info'], $input['kd_petugas']);

    if($newInfo){
        sendResponse(201, 'Information created successfully', $newInfo);
    }else{
        internalServerErrorResponse("Failed to create information");
    }

}

function handleUpdateInfoRequest($kd_info)
{
    if (!$kd_info) {
        badRequestResponse("Information ID is required");
    }

    $existingInfo = getInfoById($kd_info);
    if (!$existingInfo) {
        notFoundResponse("Information not found");
    }

    $input = json_decode(file_get_contents('php://input'), true);
    $requiredFields = ['judul_info', 'isi_info', 'tgl_post_info', 'status_info', 'kd_petugas'];
    $missingFields = validateRequiredFields($input, $requiredFields);
    if (!empty($missingFields)) {
        badRequestResponse("Missing required fields", $missingFields);
    }
    
    // Validasi khusus untuk status_info
    if (!in_array($input['status_info'], ['0', '1', 0, 1], true)) {
        badRequestResponse("Status info harus 0 atau 1");
    }

    // Periksa apakah ada perubahan data
    $isDataChanged = false;
    foreach ($requiredFields as $field) {
        if ($existingInfo[$field] != $input[$field]) {
            $isDataChanged = true;
            break;
        }
    }

    if (!$isDataChanged) {
        // Jika tidak ada perubahan, kirim respons sukses tanpa melakukan update
        sendResponse(200, "Tidak ada perubahan pada informasi", $existingInfo);
        return;
    }

    $updatedInfo = updateInfo($kd_info, $input['judul_info'], $input['isi_info'], $input['tgl_post_info'], $input['status_info'], $input['kd_petugas']);
    if ($updatedInfo) {
        sendResponse(200, "Informasi berhasil diperbarui", $updatedInfo);
    } else {
        internalServerErrorResponse("Gagal memperbarui informasi");
    }
}
function handleDeleteInfoRequest($kode_info) {
    if (!$kode_info) {
        badRequestResponse("Information id is required");
    }
    
    $deletedInfo = deleteInfo($kode_info);
    if ($deletedInfo) {
        sendResponse(200, "Resource successfully deleted.",['kd_info' => $kode_info]);
    } else {
        notFoundResponse("Information not found");
    }
}