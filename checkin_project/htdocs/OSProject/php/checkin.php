<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");
$userid= $_POST['userid'];
$checkcourse = $_POST['course'];
$checkgroup = $_POST['group'];
$checklocation = $_POST['locality'];
$checkstate = $_POST['state'];
$checklat = $_POST['latitude'];
$checklong = $_POST['longitude'];

$sqlinsert = "INSERT INTO `tbl_checkin`(`user_id`, `checkin_course`, `checkin_group`, `checkin_location`, `checkin_state`, `checkin_lat`, `checkin_long`) VALUES ('$userid ', '$checkcourse ','$checkgroup','$checklocation', '$checkstate','$checklat','$checklong')";

if ($conn->query($sqlinsert) === TRUE) {
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