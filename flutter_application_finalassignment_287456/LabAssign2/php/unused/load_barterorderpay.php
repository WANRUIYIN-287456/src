<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");
$barteruserid = $_POST['barteruserid'];	

	$sqlorder = "SELECT *
    FROM tbl_order
    INNER JOIN tbl_orderpay ON tbl_order.order_id = tbl_orderpay.order_id
    INNER JOIN tbl_products ON tbl_order.product_id = tbl_products.product_id
    WHERE tbl_order.barteruser_id = '$barteruserid'
    ";

$result = $conn->query($sqlorder);
if ($result->num_rows > 0) {
    $orderpay["orderpay"] = array();
	while ($row = $result->fetch_assoc()) {
        $orderpaylist = array();
        $orderpaylist['order_id'] = $row['order_id'];
        $orderpaylist['product_id'] = $row['product_id'];
        $orderpaylist['order_date'] = $row['order_date'];
        $orderpaylist['order_qty'] = $row['order_qty'];
        $orderpaylist['barteruser_id'] = $row['barteruser_id'];
        $orderpaylist['user_id'] = $row['user_id'];
        $orderpaylist['order_status'] = $row['order_status'];
        $orderpaylist['paymentorder_id'] = $row['paymentorder_id'];
        $orderpaylist['payment_amount'] = $row['payment_amount'];
        $orderpaylist['paymentorder_status'] = $row['paymentorder_status'];
        $orderpaylist['product_name'] = $row['product_name'];
        $orderpaylist['product_type'] = $row['product_type'];
        $orderpaylist['product_desc'] = $row['product_desc'];
        $orderpaylist['product_price'] = $row['product_price'];
        $orderpaylist['product_qty'] = $row['product_qty'];
        $orderpaylist['product_state'] = $row['product_state'];
        $orderpaylist['product_locality'] = $row['product_locality'];
		$orderpaylist['product_date'] = $row['product_date'];
        $orderpaylist['product_option'] = $row['product_option'];
        $orderpaylist['product_status'] = $row['product_status'];
        array_push($orderpay["orderpay"] ,$orderpaylist);
    }
    $response = array('status' => 'success', 'data' => $orderpay);
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
