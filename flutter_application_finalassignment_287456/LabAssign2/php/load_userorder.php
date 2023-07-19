<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

if (isset($_POST['userid'])){
	$userid = $_POST['userid'];	
	$sqlorder = "SELECT *
    FROM tbl_order
    INNER JOIN tbl_orderbarter ON tbl_order.order_id = tbl_orderbarter.order_id
    INNER JOIN tbl_orderpay ON tbl_order.order_id = tbl_orderpay.order_id
    INNER JOIN tbl_products ON tbl_order.product_id = tbl_products.product_id
    WHERE tbl_order.user_id = '$userid'";
}
//`order_id`, `order_bill`, `order_paid`, `buyer_id`, `seller_id`, `order_date`, `order_status`

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
        $orderlist['barterorder_id'] = $row['barterorder_id'];
        $orderlist['barterproduct_id'] = $row['barteptoduct_id'];
        $orderlist['barterorder_status'] = $row['barterorder_status'];
        $orderlist['paymentorder_id'] = $row['paymentorder_id'];
        $orderlist['payment_amount'] = $row['payment_amount'];
        $orderlist['paymentorder_status'] = $row['paymentorder_status'];
        $oederlist['product_name'] = $row['product_name'];
        $oederlist['product_type'] = $row['product_type'];
        $oederlist['product_desc'] = $row['product_desc'];
        $oederlist['product_price'] = $row['product_price'];
        $oederlist['product_qty'] = $row['product_qty'];
        $oederlist['product_state'] = $row['product_state'];
        $oederlist['product_locality'] = $row['product_locality'];
		$oederlist['product_date'] = $row['product_date'];
        $oederlist['product_option'] = $row['product_option'];
        $oederlist['product_status'] = $row['product_status'];
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