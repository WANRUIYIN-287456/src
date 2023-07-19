<?php
if ( !isset($_POST)) {
$response = array('status' => 'failed', 'data' => null);
sendJsonResponse($response);
die();
}
 include_once("dbconnect.php");
 $name = $_POST['name'];
 $email = $_POST['email'];
 $phone = $_POST['phone'];
 $password = sha1($_POST['password']);
 $otp = rand(10000,99999);
$image = $_POST['image'];
 $sqlinsert = "INSERT INTO tbl_users (user_email, user_name, user_phone,
 user_password, user_otp) VALUES('$email','$name','$phone','$password', $otp)";

if ($conn->query($sqlinsert) === TRUE) {
    $filename = mysqli_insert_id($conn);
	$response = array('status' => 'success', 'data' => null);
	$decoded_string = base64_decode($image);
	$path = '../assets/images/profile'.$filename.'.png';
	file_put_contents($path, $decoded_string);
    sendJsonResponse($response);
	// $response = array('status' => 'success', 'data' => null);
    // sendJsonResponse($response);
}else{
	$response = array('status' => 'failed', 'data' => null);
	sendJsonResponse($response);
}

 function sendJsonResponse($sentArray){
        header('Content-Type', 'application/json');
        echo json_encode($sentArray);
    }
?>