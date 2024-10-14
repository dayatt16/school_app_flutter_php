<?php
require_once __DIR__ . '/../config/db.php';



function getAllGalery()
{
    $conn = getConnection();
    $stmt = $conn->prepare("SELECT * FROM galery ORDER BY tgl_post_galery DESC");
    $stmt->execute();
    $result = $stmt->get_result();
    $data = $result->fetch_all(MYSQLI_ASSOC);
    $stmt->close();
    $conn->close();
    return $data;
}



function getGaleryById($kd_galery)
{
    $conn = getConnection();
    $stmt = $conn->prepare("SELECT * FROM galery WHERE kd_galery = ?");
    $stmt->bind_param("i", $kd_galery);
    $stmt->execute();
    $result = $stmt->get_result();
    $agenda = $result->fetch_assoc();
    $stmt->close();
    $conn->close();
    return $agenda;
}

function createGalery($judul_galery, $foto_galery, $isi_galery, $tgl_posting, $status, $kd_petugas)
{
    $conn = getConnection();
    $stmt = $conn->prepare("INSERT INTO galery (judul_galery,foto_galery, isi_galery, tgl_post_galery, status_galery, kd_petugas) VALUES (?,?, ?, ?, ?, ?)");
    $stmt->bind_param("ssssii", $judul_galery, $foto_galery, $isi_galery, $tgl_posting, $status, $kd_petugas);
    $stmt->execute();
    $id = $stmt->insert_id;
    $stmt->close();
    $conn->close();
    if ($id) {
        $data = [
            "kd_galery" => $id,
            "judul_galery" => $judul_galery,
            "foto_galery" => $foto_galery,
            "isi_galery" => $isi_galery,
            "tgl_post_galery" => $tgl_posting,
            "status_galery" => $status,
            "kd_petugas" => $kd_petugas
        ];
        return $data;
    }
    return null;
}

function updateGalery($kd_galery, $judul_galery, $foto_galery, $isi_galery, $tgl_posting, $status, $kd_petugas)
{
    $conn = getConnection();
    $stmt = $conn->prepare("UPDATE galery SET judul_galery = ?, foto_galery = ?, isi_galery = ?, tgl_post_galery = ?, status_galery = ?, kd_petugas = ? WHERE kd_galery = ?");
    $stmt->bind_param("ssssiii", $judul_galery, $foto_galery, $isi_galery, $tgl_posting, $status, $kd_petugas, $kd_galery);
    $stmt->execute();
    $affected_rows = $stmt->affected_rows;
    $stmt->close();
    $conn->close();
    if ($affected_rows > 0) {
        $data = [
            'kd_galery' => $kd_galery,
            'judul_galery' => $judul_galery,
            "foto_galery" => $foto_galery,
            'isi_galery' => $isi_galery,
            'tgl_posting' => $tgl_posting,
            'status_galery' => $status,
            'kd_petugas' => $kd_petugas
        ];
        return $data;
    }
    return null;
}

function deleteGalery($kd_galery)
{
    $conn = getConnection();
    $stmt = $conn->prepare("DELETE FROM galery WHERE kd_galery = ?");
    $stmt->bind_param("i", $kd_galery);
    $stmt->execute();
    $affected_rows = $stmt->affected_rows;
    $stmt->close();
    $conn->close();
    return $affected_rows > 0;
}
