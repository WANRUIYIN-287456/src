<?php

if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");


$userid = $_POST['userid'];


if (isset($_POST['oldpass'])) {
    $oldpass = sha1($_POST['oldpass']);
    $newpass = sha1($_POST['newpass']);
    $userid = $_POST['userid'];
    include_once("dbconnect.php");
    $sqllogin = "SELECT * FROM tbl_users WHERE user_id = '$userid' AND user_password = '$oldpass'";
    $result = $conn->query($sqllogin);
    if ($result->num_rows > 0) {
        $sqlupdate = "UPDATE tbl_users SET user_password ='$newpass' WHERE user_id = '$userid'";
        // if ($conn->query($sqlupdate) === TRUE) {
        //     $response = array('status' => 'success', 'data' => null);
        //     sendJsonResponse($response);
        // } else {
        //     $response = array('status' => 'failed', 'data' => null);
        //     sendJsonResponse($response);
        // }
    // } else {
    //     $response = array('status' => 'failed', 'data' => null);
    //     sendJsonResponse($response);
    }
}

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
