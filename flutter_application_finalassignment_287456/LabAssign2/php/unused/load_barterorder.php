<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

if (isset($_POST['barteruserid'])){
	$barteruserid = $_POST['barteruserid'];	
	$sqlorder = "SELECT *
    FROM tbl_order
    INNER JOIN tbl_products ON tbl_order.product_id = tbl_products.product_id
    WHERE tbl_order.barteruser_id = '$barteruserid'
   ";
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
        $orderlist['product_name'] = $row['product_name'];
        $orderlist['product_type'] = $row['product_type'];
        $orderlist['product_desc'] = $row['product_desc'];
        $orderlist['product_price'] = $row['product_price'];
        $orderlist['product_qty'] = $row['product_qty'];
        $orderlist['product_state'] = $row['product_state'];
        $orderlist['product_locality'] = $row['product_locality'];
		$orderbarterlist['product_date'] = $row['product_date'];
        $orderlist['product_option'] = $row['product_option'];
        $orderlist['product_status'] = $row['product_status'];
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
