<?php

require_once __DIR__ . '/../controllers/agendaController.php';
function handleAgendaRoutes($method, $kd_agenda)
{
    switch ($method) {
        case 'GET':
            handleGetAgendaRequest($kd_agenda);
            break;
        case 'POST':
            handleCreateAgendaRequest();
            break;
        case 'PUT':
            handleUpdateAgendaRequest($kd_agenda);
            break;
        case 'DELETE':
            handleDeleteAgendaRequest($kd_agenda);
            break;
        default:
            methodNotAllowedResponse();
            break;
    }
}
