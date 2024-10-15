<?php
require_once __DIR__ . '/../config/db.php';



function getAllAgenda()
{
    $conn = getConnection();
    $stmt = $conn->prepare("SELECT * FROM agenda ORDER BY tgl_post_agenda DESC");
    $stmt->execute();
    $result = $stmt->get_result();
    $data = $result->fetch_all(MYSQLI_ASSOC);
    $stmt->close();
    $conn->close();
    return $data;
}



function getAgendaById($kd_agenda)
{
    $conn = getConnection();
    $stmt = $conn->prepare("SELECT * FROM agenda WHERE kd_agenda = ?");
    $stmt->bind_param("i", $kd_agenda);
    $stmt->execute();
    $result = $stmt->get_result();
    $agenda = $result->fetch_assoc();
    $stmt->close();
    $conn->close();
    return $agenda;
}

function createAgenda($judul_agenda, $isi_agenda, $tgl_agenda, $tgl_posting, $status, $kd_petugas)
{
    $conn = getConnection();
    $stmt = $conn->prepare("INSERT INTO agenda (judul_agenda, isi_agenda,tgl_agenda, tgl_post_agenda, status_agenda, kd_petugas) VALUES (?, ?, ?, ?, ?, ?)");
    $stmt->bind_param("ssssii", $judul_agenda, $isi_agenda, $tgl_agenda, $tgl_posting, $status, $kd_petugas);
    $stmt->execute();
    $id = $stmt->insert_id;
    $stmt->close();
    $conn->close();
    if ($id) {
        $data = [
            "kd_agenda" => $id,
            "judul_agenda" => $judul_agenda,
            "isi_agenda" => $isi_agenda,
            "tgl_agenda" => $tgl_agenda,
            "tgl_post_agenda" => $tgl_posting,
            "status_agenda" => $status,
            "kd_petugas" => $kd_petugas
        ];
        return $data;
    }
    return null;
}

function updateAgenda($kd_agenda, $judul_agenda, $isi_agenda, $tgl_agenda, $tgl_posting, $status, $kd_petugas)
{
 $conn = getConnection();
    $stmt = $conn->prepare("UPDATE agenda SET judul_agenda = ?, isi_agenda = ?, tgl_agenda = ?, tgl_post_agenda = ?, status_agenda = ?, kd_petugas = ? WHERE kd_agenda = ?");
    $stmt->bind_param("ssssiii", $judul_agenda, $isi_agenda, $tgl_agenda, $tgl_posting, $status, $kd_petugas, $kd_agenda);
    $stmt->execute();
    $affected_rows = $stmt->affected_rows;
    $stmt->close();
    $conn->close();
    if ($affected_rows > 0) {
        $data = [
            'kd_agenda' => $kd_agenda,
            'judul_agenda' => $judul_agenda,
            'isi_agenda' => $isi_agenda,
            'tgl_agenda' => $tgl_agenda,
            'tgl_posting' => $tgl_posting,
            'status' => $status,
            'kd_petugas' => $kd_petugas
        ];
        return $data;
    }
    return null;
}

function deleteAgenda($kd_agenda)
{
    $conn = getConnection();
    $stmt = $conn->prepare("DELETE FROM agenda WHERE kd_agenda = ?");
    $stmt->bind_param("i", $kd_agenda);
    $stmt->execute();
    $affected_rows = $stmt->affected_rows;
    $stmt->close();
    $conn->close();
    return $affected_rows > 0;
}
