<?php

require_once __DIR__ . '/../controllers/galleryController.php';
function handleGaleryRoutes($method, $kd_galery)
{
    switch ($method) {
        case 'GET':
            handleGetGaleryRequest($kd_galery);
            break;
        case 'POST':
            handleCreateGaleryRequest();
            break;
        case 'PUT':
            handleUpdateGaleryRequest($kd_galery);
            break;
        case 'DELETE':
            handleDeleteGaleryRequest($kd_galery);
            break;
        default:
            methodNotAllowedResponse();
            break;
    }
}
