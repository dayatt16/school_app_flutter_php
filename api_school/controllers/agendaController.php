<?php

require_once __DIR__ . '/../models/agendaModel.php';
require_once __DIR__ . '/../utils/response.php';
require_once __DIR__ . '/../utils/validation.php';

function handleGetAgendaRequest($kd_agenda = null)
{
    if ($kd_agenda) {
        $agenda = getAgendaById($kd_agenda);

        if ($agenda) {
            sendResponse(200, 'Agenda found', $agenda);
        } else {
            notFoundResponse("Agenda not found");
        }
    } else {
        $agenda_items = getAllAgenda();
        sendResponse(200, 'List of Agenda', $agenda_items);
    }
}

function handleCreateAgendaRequest()
{
    $input = json_decode(file_get_contents('php://input'), true);
    $requiredFields = ['judul_agenda', 'isi_agenda', 'tgl_agenda', 'tgl_post_agenda', 'status_agenda', 'kd_petugas'];
    $missingFields = validateRequiredFields($input, $requiredFields);
    if (!empty($missingFields)) {
        badRequestResponse("Missing required fields", $missingFields);
    }
    if (!in_array($input['status_agenda'], ['0', '1', 0, 1], true)) {
        badRequestResponse("Status agenda harus 0 atau 1");
    }

    $newAgenda = createAgenda($input['judul_agenda'], $input['isi_agenda'], $input['tgl_agenda'], $input['tgl_post_agenda'], $input['status_agenda'], $input['kd_petugas']);

    if ($newAgenda) {
        sendResponse(201, 'Agendarmation created successfully', $newAgenda);
    } else {
        internalServerErrorResponse("Failed to create agendarmation");
    }
}

function handleUpdateAgendaRequest($kd_agenda)
{
    if (!$kd_agenda) {
        badRequestResponse("Agenda ID diperlukan");
    }

    $existingAgenda = getAgendaById($kd_agenda);
    if (!$existingAgenda) {
        notFoundResponse("Agenda tidak ditemukan");
    }

    $input = json_decode(file_get_contents('php://input'), true);
    $requiredFields = ['judul_agenda', 'isi_agenda', 'tgl_agenda', 'tgl_post_agenda', 'status_agenda', 'kd_petugas'];
    $missingFields = validateRequiredFields($input, $requiredFields);
    if (!empty($missingFields)) {
        badRequestResponse("Ada field yang belum diisi", $missingFields);
    }
    
    // Validasi khusus untuk status_agenda
    if (!in_array($input['status_agenda'], ['0', '1', 0, 1], true)) {
        badRequestResponse("Status agenda harus 0 atau 1");
    }

    // Periksa apakah ada perubahan data
    $isDataChanged = false;
    foreach ($requiredFields as $field) {
        if ($existingAgenda[$field] != $input[$field]) {
            $isDataChanged = true;
            break;
        }
    }

    if (!$isDataChanged) {
        // Jika tidak ada perubahan, kirim respons sukses tanpa melakukan update
        sendResponse(200, "Tidak ada perubahan pada agenda", $existingAgenda);
        return;
    }

    $updatedAgenda = updateAgenda($kd_agenda, $input['judul_agenda'], $input['isi_agenda'], $input['tgl_agenda'], $input['tgl_post_agenda'], $input['status_agenda'], $input['kd_petugas']);
    if ($updatedAgenda) {
        sendResponse(200, "Agenda berhasil diperbarui", $updatedAgenda);
    } else {
        internalServerErrorResponse("Gagal memperbarui agenda");
    }
}

function handleDeleteAgendaRequest($kode_agenda)
{
    if (!$kode_agenda) {
        badRequestResponse("Agenda id is required");
    }

    $deletedAgenda = deleteAgenda($kode_agenda);
    if ($deletedAgenda) {
        sendResponse(200, "Resource successfully deleted.", ['kd_agenda' => $kode_agenda]);
    } else {
        notFoundResponse("Agenda not found");
    }
}
