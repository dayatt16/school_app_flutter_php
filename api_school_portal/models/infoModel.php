<?php
require_once __DIR__ . '/../config/db.php';

function getAllInfo()
{
    $conn = getConnection();
    $stmt = $conn->prepare("SELECT * FROM info ORDER BY tgl_post_info DESC");
    $stmt->execute();
    $result = $stmt->get_result();
    $data = $result->fetch_all(MYSQLI_ASSOC);
    $stmt->close();
    $conn->close();
    return $data;
}


 
function getInfoById($kd_info)
{
    $conn = getConnection();
    $stmt = $conn->prepare("SELECT * FROM info WHERE kd_info = ?");
    $stmt->bind_param("i", $kd_info);
    $stmt->execute();
    $result = $stmt->get_result();
    $agenda = $result->fetch_assoc();
    $stmt->close();
    $conn->close();
    return $agenda;
}

function createInfo($judul_info, $isi_info, $tgl_posting, $status, $kd_petugas)
{
    $conn = getConnection();
    $stmt = $conn->prepare("INSERT INTO info (judul_info, isi_info, tgl_post_info, status_info, kd_petugas) VALUES (?, ?, ?, ?, ?)");
    $stmt->bind_param("sssii", $judul_info, $isi_info, $tgl_posting, $status, $kd_petugas);
    $stmt->execute();
    $id = $stmt->insert_id;
    $stmt->close();
    $conn->close();
    if ($id) {
        $data = [
            "kd_info" => $id,
            "judul_info" => $judul_info,
            "isi_info" => $isi_info,
            "tgl_post_info" => $tgl_posting,
            "status_info" => $status,
            "kd_petugas" => $kd_petugas
        ];
        return $data;
    }
    return null;
}

function updateInfo($kd_info, $judul_info, $isi_info, $tgl_posting, $status, $kd_petugas)
{
    $conn = getConnection();
    $stmt = $conn->prepare("UPDATE info SET judul_info = ?, isi_info = ?, tgl_post_info = ?, status_info = ?, kd_petugas = ? WHERE kd_info = ?");
    $stmt->bind_param("sssiii", $judul_info, $isi_info, $tgl_posting, $status, $kd_petugas, $kd_info);
    $stmt->execute();
    $affected_rows = $stmt->affected_rows;
    $stmt->close();
    $conn->close();
    if ($affected_rows > 0) {
        $data =[
            'kd_info' => $kd_info,
            'judul_info' => $judul_info,
            'isi_info' => $isi_info,
            'tgl_posting' => $tgl_posting,
            'status' => $status,
            'kd_petugas' => $kd_petugas
        ];
        return $data;

    }
    return null;
}

function deleteInfo($kd_info)
{
    $conn = getConnection();
    $stmt = $conn->prepare("DELETE FROM info WHERE kd_info = ?");
    $stmt->bind_param("i", $kd_info);
    $stmt->execute();
    $affected_rows = $stmt->affected_rows;
    $stmt->close();
    $conn->close();
    return $affected_rows > 0;
}
