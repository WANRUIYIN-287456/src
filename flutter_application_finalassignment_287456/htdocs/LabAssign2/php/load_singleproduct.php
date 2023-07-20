<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

if (isset($_POST['barteruserid'])){
	$userid = $_POST['barteruserid'];	
	$sqlloadproducts = "SELECT * FROM `tbl_products` WHERE barteruser_id = '$userid'";
}

$result = $conn->query($sqlloadproducts);

if ($result->num_rows > 0) {
    $product["product"] = array();
	while ($row = $result->fetch_assoc()) {
        $productList = array();
        $productList['product_id'] = $row['product_id'];
        $productList['barteruser_id'] = $row['barteruser_id'];
        $productList['product_name'] = $row['product_name'];
        $productList['product_type'] = $row['product_type'];
        $productList['product_desc'] = $row['product_desc'];
        $productList['product_price'] = $row['product_price'];
        $productList['product_qty'] = $row['product_qty'];
        $productList['product_lat'] = $row['product_lat'];
        $productList['product_long'] = $row['product_long'];
        $productList['product_state'] = $row['product_state'];
        $productList['product_locality'] = $row['product_locality'];
		$productList['product_date'] = $row['product_date'];
        $productList['product_option'] = $row['product_option'];
        $productList['product_status'] = $row['product_status'];
        array_push($product["product"],$productList);
    }
    $response = array('status' => 'success', 'data' => $product);
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