<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}
include_once("dbconnect.php");
$productid = $_POST['productid'];
$orderqty = $_POST['orderqty'];
//$orderprice = $_POST['orderprice'];
$barteruserid = $_POST['barteruserid'];
$userid = $_POST['userid'];
$orderstatus = $_POST['orderstatus'];

// $sql = "INSERT INTO `tbl_order`(`product_id`, `order_qty`, `barteruser_id`, `user_id` , `order_status`) VALUES ('$productid','$orderqty','$barteruserid','$userid' ,'$orderstatus')";

// if ($conn->query($sql) === TRUE) {
// 		$response = array('status' => 'success', 'data' => $sql);
// 		sendJsonResponse($response);
// 	}else{
// 		$response = array('status' => 'failed', 'data' => $sql);
// 		sendJsonResponse($response);
// 	}

$sql1 = "INSERT INTO tbl_order (product_id, order_qty, barteruser_id, user_id, order_status) VALUES ('$productid', '$orderqty', '$barteruserid', '$userid', '$orderstatus')";
if ($conn->query($sql1) === TRUE) {
    $last_id = $conn->insert_id;
    $sql2 = "INSERT INTO tbl_orderpay (order_id, product_id, payment_amount) VALUES ('$productid', '$last_id', '$orderprice')";
    if ($conn->query($sql2) === TRUE) {
        $response = array('status' => 'success', 'data' => $sql2);
        sendJsonResponse($response);
    } else {
        $response = array('status' => 'failed', 'data' => $sql2);
        sendJsonResponse($response);
    }
} else {
    $response = array('status' => 'failed', 'data' => $sql1);
    sendJsonResponse($response);
} 


function sendJsonResponse($sentArray)
{    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

?>

<!-- $sql1 = "INSERT INTO tbl_order (product_id, order_qty, barteruser_id, user_id, order_status) VALUES ('$productid', '$orderqty', '$barteruserid', '$userid', '$orderstatus')";
if ($conn->query($sql1) === TRUE) {
    $last_id = $conn->insert_id;
    $sql2 = "INSERT INTO tbl_orderpay (order_id, payment_amount) VALUES ('$last_id', '$orderprice')";
    if ($conn->query($sql2) === TRUE) {
        $response = array('status' => 'success', 'data' => $sql2);
        sendJsonResponse($response);
    } else {
        $response = array('status' => 'failed', 'data' => $sql2);
        sendJsonResponse($response);
    }
} else {
    $response = array('status' => 'failed', 'data' => $sql1);
    sendJsonResponse($response);
} -->
