<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

if (isset($_POST['barteruserid'])){
	$barteruserid = $_POST['barteruserid'];	
	$sqlorder = "SELECT * FROM `tbl_order` WHERE barteruser_id = '$barteruserid'";
}
//`order_id`, `product_id`, `order_paid`, `buyer_id`, `seller_id`, `order_date`, `order_status`

$result = $conn->query($sqlorder);
if ($result->num_rows > 0) {
    $oderitems["orders"] = array();
	while ($row = $result->fetch_assoc()) {
        $orderlist = array();
        $orderlist['order_id'] = $row['order_id'];
        $orderlist['product_id'] = $row['product_id'];
        $orderlist['order_date'] = $row['order_date'];
        $orderlist['order_qty'] = $row['order_qty'];
        $orderlist['barteruser_id'] = $row['barteruser_id'];
        $orderlist['user_id'] = $row['user_id'];
        $orderlist['order_status'] = $row['order_status'];
        array_push($oderitems["orders"] ,$orderlist);
    }
    $response = array('status' => 'success', 'data' => $oderitems);
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
