<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$userid = $_POST['userid'];
$product_name = $_POST['prname'];
$product_desc = $_POST['prdesc'];
$product_price = $_POST['prprice'];
$product_qty = $_POST['prqty'];
$product_type = $_POST['type'];
$latitude = $_POST['latitude'];
$longitude = $_POST['longitude'];
$state = $_POST['state'];
$locality = $_POST['locality'];
$image1 = $_POST['image1'];
$image2 = $_POST['image2'];
$image3 = $_POST['image3'];
$option = $_POST['option'];
$status = $_POST['status'];

$sqlinsert = "INSERT INTO `tbl_products`(`user_id`,`product_name`, `product_desc`, `product_type`, `product_price`, `product_qty`, `product_lat`, `product_long`, `product_state`, `product_locality`, `Product_Image1`,`Product_Image2`, `Product_Image3`, `product_option`, `product_status`) VALUES ('$userid','$product_name','$product_desc','$product_type','$product_price','$product_qty','$latitude','$longitude','$state','$locality', '$image1', '$image2', '$image3', '$option', '$status')";

if ($conn->query($sqlinsert) === TRUE) {
    $insertid = mysqli_insert_id($conn);
    $filename1 = $insertid . ".1";
    $filename2 = $insertid . ".2";
    $filename3 = $insertid . ".3";
    file_put_contents("../assets/images/" . $filename1 . ".png", base64_decode($image1));
    file_put_contents("../assets/images/" . $filename2 . ".png", base64_decode($image2));
    file_put_contents("../assets/images/" . $filename3 . ".png", base64_decode($image3));
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