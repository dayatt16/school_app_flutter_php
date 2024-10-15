<?php

function validateRequiredFields($input, $requiredFields)
{
    $missingFields = [];
    foreach ($requiredFields as $field) {
        if (!isset($input[$field]) || (is_string($input[$field]) && trim($input[$field]) === '') || $input[$field] === null) {
            $missingFields[] = [
                'field' => $field,
                'issue' => ucfirst(str_replace('_', ' ', $field)) . ' tidak boleh kosong',
            ];
        }
    }
    return $missingFields;
}
function validateUploadedFile($file)
{
    if ($file['error'] === UPLOAD_ERR_NO_FILE) {
        return false;
    }
    if ($file['error'] !== UPLOAD_ERR_OK) {
        return false;
    }
    if ($file['size'] > MAX_FILE_SIZE) {
        return false;
    }
    $mimeType = mime_content_type($file['tmp_name']);
    if (!in_array($mimeType, ALLOWED_TYPES)) {
        return false;
    }
    return true;
}
