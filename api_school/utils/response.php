<?php
function sendResponse($status, $message, $data = null)
{
    header('Content-Type: application/json');
    http_response_code($status);
    echo json_encode([
        'status_code' => $status,
        'message' => $message,
        'data' => $data
    ]);
    exit;
}

function sendErrorResponse($status, $error, $message, $details = null)
{
    header('Content-Type: application/json');
    http_response_code($status);
    echo json_encode([
        'status_code' => $status,
        'error' => $error,
        'message' => $message,
        'details' => $details
    ]);
    exit;
}

function badRequestResponse($message = "Permintaan tidak valid", $details = null) {
    sendErrorResponse(400, "Bad Request", $message, $details);
}

function unauthorizedResponse($message = "Akses tidak diizinkan", $details = null) {
    sendErrorResponse(401, "Unauthorized", $message, $details);
}

function forbiddenResponse($message = "Akses dilarang", $details = null) {
    sendErrorResponse(403, "Forbidden", $message, $details);
}

function notFoundResponse($message = "Sumber daya tidak ditemukan", $details = null) {
    sendErrorResponse(404, "Not Found", $message, $details);
}

function methodNotAllowedResponse($message = "Metode HTTP tidak diizinkan", $details = null) {
    sendErrorResponse(405, "Method Not Allowed", $message, $details);
}

function internalServerErrorResponse($message = "Terjadi kesalahan internal server", $details = null) {
    sendErrorResponse(500, "Internal Server Error", $message, $details);
}
