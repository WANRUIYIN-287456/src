<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$paymentorderid = $_POST['paymentorderid'];
$status = $_POST['status'];
$submitstatus = $_POST['submitstatus'];
$sqlupdate1 = "UPDATE `tbl_orderpay` SET `paymentorder_status`='$status' WHERE paymentorder_id = '$paymentorderid'";
$sqlupdate2 = "UPDATE `tbl_order` SET `owner_status`='$submitstatus' WHERE paymentorder_id = '$paymentorderid'";

if ($conn->query($sqlupdate1) === TRUE && $conn->query($sqlupdate2) === TRUE) {
	$response = array('status' => 'success', 'data' => null);
    sendJsonResponse($response);
}else{
	$response = array('status' => 'failed', 'data' => null);
	sendJsonResponse($response);
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

?>