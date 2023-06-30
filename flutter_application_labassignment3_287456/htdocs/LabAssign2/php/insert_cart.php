<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}
include_once("dbconnect.php");
$productid = $_POST['product_id'];
$cartqty = $_POST['cart_qty'];
$cartprice = $_POST['cart_price'];
$barteruserid = $_POST['barteruser_id'];
$userid = $_POST['userid'];
$checkproductid = "SELECT * FROM `tbl_cart` WHERE `barteruser_id` = '$barteruserid' AND  `product_id` = '$productid'";
$resultqty = $conn->query($checkproductid);
$numresult = $resultqty->num_rows;
if ($numresult > 0) {
	$sql = "UPDATE `tbl_cart` SET `cart_qty`= (cart_qty + '$cartqty'),`cart_price`= (cart_price + '$cartprice') WHERE `barteruser_id` = '$barteruserid' AND  `product_id` = '$productid'";
}else{
	$sql = "INSERT INTO `tbl_cart`(`product_id`, `cart_qty`, `cart_price`, `barteruser_id`, `user_id`) VALUES ('$productid','$cartqty','$cartprice','$barteruserid','$userid')";
}
if ($conn->query($sql) === TRUE) {
		$response = array('status' => 'success', 'data' => $sql);
		sendJsonResponse($response);
	}else{
		$response = array('status' => 'failed', 'data' => $sql);
		sendJsonResponse($response);
	}
function sendJsonResponse($sentArray)
{    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

?>