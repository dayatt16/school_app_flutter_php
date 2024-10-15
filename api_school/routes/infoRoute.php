<?php

require_once __DIR__ . '/../controllers/infoController.php';
function handleInfoRoutes($method, $kd_info)
{
    switch ($method) {
        case 'GET':
            handleGetInfoRequest($kd_info);
            break;
        case 'POST':
            handleCreateInfoRequest();
            break;
        case 'PUT':
            handleUpdateInfoRequest($kd_info);
            break;
        case 'DELETE':
            handleDeleteInfoRequest($kd_info);
            break;
        default:
            methodNotAllowedResponse();
            break;
    }
}
