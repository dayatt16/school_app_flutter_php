<?php
// get all information
// https://praktikum-cpanel-unbin.com/kelompok_ojan/api_school_app_fauzan/information
// get information by id
// https://praktikum-cpanel-unbin.com/kelompok_ojan/api_school_app_fauzan/information/1

// get all agendas
// https://praktikum-cpanel-unbin.com/kelompok_ojan/api_school_app_fauzan/agendas
// get agendas by id
// https://praktikum-cpanel-unbin.com/kelompok_ojan/api_school_app_fauzan/agendas/1

// get all galleries
// https://praktikum-cpanel-unbin.com/kelompok_ojan/api_school_app_fauzan/galleries
// get galleries by id
// https://praktikum-cpanel-unbin.com/kelompok_ojan/api_school_app_fauzan/galleries/1

require_once __DIR__ . '/utils/response.php';
require_once __DIR__ . '/routes/infoRoute.php';
require_once __DIR__ . '/routes/agendaRoute.php';
require_once __DIR__ . '/routes/galleryRoute.php';





header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE");
header("Access-Control-Allow-Headers: Content-Type");

// Ambil method HTTP
$method = $_SERVER['REQUEST_METHOD'];

// Parse URL
$request_uri = $_SERVER['REQUEST_URI'];
$base_path = '/kelompok_ojan/api_school_app_fauzan/';
$path = str_replace($base_path, '', $request_uri);
$path = trim($path, '/');

$parts = explode('/', $path);
$resource = $parts[0] ?? '';
$id = $parts[1] ?? null;

// Debug: Cetak informasi untuk membantu debugging
error_log("Request URI: " . $request_uri);
error_log("Path: " . $path);
error_log("Resource: " . $resource);
error_log("ID: " . $id);

switch($resource){
    case 'information':
        handleInfoRoutes($method, $id);
        break;
    case 'agendas':
        handleAgendaRoutes($method, $id);
        break;
    case 'galleries':
        handleGaleryRoutes($method, $id);
        break;
    default:
        notFoundResponse("Endpoint not found");
}

?>