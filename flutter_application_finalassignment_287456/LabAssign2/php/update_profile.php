<?php

if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$username = $_POST['username'];
$userphone = $_POST['userphone'];
$useremail = $_POST['useremail'];
$userid = $_POST['userid'];

$sqlupdate = "UPDATE `tbl_users` SET `user_name`= '$username', `user_phone`= '$userphone', `user_email`= '$useremail' WHERE `user_id` = '$userid';";

if ($conn->query($sqlupdate) === TRUE) {
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
