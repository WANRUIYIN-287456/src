<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$barterorderid = $_POST['barterorderid'];
$status = $_POST['status'];
$submitstatus = $_POST['submitstatus'];
$sqlupdate1 = "UPDATE `tbl_orderbarter` SET `barterorder_status`='$status' WHERE barterorder_id = '$barterorderid'";
$sqlupdate2 = "UPDATE `tbl_order` SET `owner_status`='$submitstatus' WHERE barterorder_id = '$barterorderid'";

if ($conn->query($sqlupdate1) === TRUE && $conn->query($sqlupdate2) === TRUE) {
    $response = array('status' => 'success', 'data' => null);
    sendJsonResponse($response);
} else {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>
