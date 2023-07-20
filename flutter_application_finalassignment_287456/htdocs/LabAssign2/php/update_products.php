<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$productid = $_POST['productid'];
$prname = $_POST['prname'];
$product_desc = addslashes($_POST['prdesc']);
$product_price = $_POST['prprice'];
$product_qty = $_POST['prqty'];


$sqlupdate = "UPDATE `tbl_products` SET `product_name`= '$prname', `product_desc`= '$product_desc', `product_price`='$product_price',`product_qty`='$product_qty' WHERE `product_id` = '$productid';";
if ($conn->query($sqlupdate) === TRUE) {
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