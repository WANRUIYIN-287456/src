<?php

if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$userid = $_POST['userid'];
$username = $_POST['username'];
$useremail = $_POST['useremail'];
$userphone = $_POST['userphone'];
$userdatereg = $_POST['userdatereg'];
$image1 = $_POST['image1'];

$checkuserid = "SELECT * FROM `tbl_profile` WHERE `user_id` = '$userid'";
$resultqty = $conn->query($checkuserid);
$numresult = $resultqty->num_rows;

if ($numresult == 0) {
        $sqlprofile = "INSERT INTO `tbl_profile`(`user_id`,`user_name`, `user_phone`, `user_email`,`user_image`, `user_datereg`) VALUES ('$userid','$username','$userphone', '$useremail',  '$image1', '$userdatereg')"; 
}else{
	    $sqlprofile= "UPDATE tbl_profile SET user_image = '$image1' WHERE user_id = '$userid';";
}



if ($conn->query($sqlprofile) === TRUE) {
        $filename1 = $userid;
        file_put_contents("../assets/images/profile/" . $filename1 . ".png", base64_decode($image1));
    	$response = array('status' => 'success', 'data' => null);
        sendJsonResponse($response);
       }
else{
    	$response = array('status' => 'failed', 'data' => null);
    	sendJsonResponse($response);
    }

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

?>