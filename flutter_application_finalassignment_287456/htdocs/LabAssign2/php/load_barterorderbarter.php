<?php
include_once("dbconnect.php");
$barteruserid = $_POST['barteruserid'];

if (isset($_POST['barter'])) {
    $sqlorder = "SELECT o.*, p.*,                        
                        '' AS paymentorder_id,
                        '' AS payment_amount,
                        '' AS paymentorder_status,
                        ob.barterorder_id, 
                        ob.barterproduct_id,
                        ob.barterproduct_name,
                        ob.barterorder_status
                 FROM tbl_order AS o
                 LEFT JOIN tbl_orderbarter AS ob ON o.barterorder_id = ob.barterorder_id
                 INNER JOIN tbl_products AS p ON o.product_id = p.product_id
                 WHERE o.barteruser_id = '$barteruserid' AND o.barterorder_id = ob.barterorder_id";
} else if (isset($_POST['pay'])) {
    $sqlorder = "SELECT o.*, p.*, 
                        '' AS barterorder_id,
                        '' AS barterproduct_id,
                        '' AS barterorder_status,
                        '' AS barterproduct_name,
                        op.paymentorder_id,
                        op.payment_amount,
                        op.paymentorder_status
                 FROM tbl_order AS o
                 LEFT JOIN tbl_orderpay AS op ON o.paymentorder_id = op.paymentorder_id
                 INNER JOIN tbl_products AS p ON o.product_id = p.product_id
                 WHERE o.barteruser_id = '$barteruserid' AND o.paymentorder_id = op.paymentorder_id ";
} else {
    $sqlorder = "SELECT o.*, p.*, 
                        ob.barterorder_id,
                        ob.barterproduct_id,
                        ob.barterorder_status,
                        ob.barterproduct_name,
                        op.paymentorder_id,
                        op.payment_amount,
                        op.paymentorder_status
                 FROM tbl_order AS o
                 INNER JOIN tbl_products AS p ON o.product_id = p.product_id
                 LEFT JOIN tbl_orderbarter AS ob ON o.barterorder_id = ob.barterorder_id
                 LEFT JOIN tbl_orderpay AS op ON o.paymentorder_id = op.paymentorder_id
                 WHERE o.barteruser_id = '$barteruserid'";
}

$result = $conn->query($sqlorder);
if ($result->num_rows > 0) {
    $order["order"] = array();
    while ($row = $result->fetch_assoc()) {
        $orderlist = array();
        $orderlist['order_id'] = $row['order_id'];
        $orderlist['product_id'] = $row['product_id'];
        $orderlist['barteruser_id'] = $row['barteruser_id'];
        $orderlist['user_id'] = $row['user_id'];
        $orderlist['order_qty'] = $row['order_qty'];
        $orderlist['order_date'] = $row['order_date'];
        $orderlist['order_status'] = $row['order_status'];
        $orderlist['owner_status'] = $row['owner_status'];
        $orderlist['buyer_status'] = $row['buyer_status'];
        $orderlist['barterorder_id'] = $row['barterorder_id'];
        $orderlist['barterproduct_id'] = $row['barterproduct_id'];
        $orderlist['barterproduct_name'] = $row['barterproduct_name'];
        $orderlist['barterorder_status'] = $row['barterorder_status'];
        $orderlist['paymentorder_id'] = $row['paymentorder_id'];
        $orderlist['payment_amount'] = $row['payment_amount'];
        $orderlist['paymentorder_status'] = $row['paymentorder_status'];
        $orderlist['product_name'] = $row['product_name'];
        $orderlist['product_type'] = $row['product_type'];
        $orderlist['product_desc'] = $row['product_desc'];
        $orderlist['product_price'] = $row['product_price'];
        $orderlist['product_qty'] = $row['product_qty'];
        $orderlist['product_state'] = $row['product_state'];
        $orderlist['product_locality'] = $row['product_locality'];
        $orderlist['product_date'] = $row['product_date'];
        $orderlist['product_option'] = $row['product_option'];
        $orderlist['product_status'] = $row['product_status'];
        array_push($order["order"], $orderlist);
    }
    $response = array('status' => 'success', 'data' => $order);
    sendJsonResponse($response);
} else {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}


// include_once("dbconnect.php");
// $barteruserid = $_POST['barteruserid'];

// if (isset($_POST['barter'])) {
//     $sqlorder = "SELECT o.*, p.*, 
//                         ob.order_id AS barterorder_id, 
//                         NULL as paymentorder_id
//                  FROM tbl_order AS o
//                  LEFT JOIN tbl_orderbarter AS ob ON o.order_id = ob.order_id
//                  INNER JOIN tbl_products AS p ON o.product_id = p.product_id
//                  WHERE o.barteruser_id = '$barteruserid'";
// } else if (isset($_POST['pay'])) {
//     $sqlorder = "SELECT o.*, p.*, 
//                         NULL as barterorder_id,
//                         op.paymentorder_id
//                  FROM tbl_order AS o
//                  LEFT JOIN tbl_orderpay AS op ON o.order_id = op.order_id
//                  INNER JOIN tbl_products AS p ON o.product_id = p.product_id
//                  WHERE o.barteruser_id = '$barteruserid'";
// } else {
//     $sqlorder = "SELECT o.*, p.*, 
//                         ob.order_id AS barterorder_id, 
//                         op.paymentorder_id
//                  FROM tbl_order AS o
//                  LEFT JOIN tbl_orderbarter AS ob ON o.order_id = ob.order_id
//                  LEFT JOIN tbl_orderpay AS op ON o.order_id = op.order_id
//                  INNER JOIN tbl_products AS p ON o.product_id = p.product_id
//                  WHERE o.barteruser_id = '$barteruserid'";
// }
// $result = $conn->query($sqlorder);
// if ($result->num_rows > 0) {
//     $order["order"] = array();
//     while ($row = $result->fetch_assoc()) {
//         $orderlist = array();
//         $orderlist['order_id'] = $row['order_id'];
//         $orderlist['product_id'] = $row['product_id'];
//         $orderlist['barterorder_id'] = $row['barterorder_id'];
//         $orderlist['paymentorder_id'] = $row['paymentorder_id'];
//         array_push($order["order"], $orderlist);
//     }
//     $response = array('status' => 'success', 'data' => $order);
//     sendJsonResponse($response);
// } else {
//     $response = array('status' => 'failed', 'data' => null);
//     sendJsonResponse($response);
// }
// function sendJsonResponse($sentArray)
// {
//     header('Content-Type: application/json');
//     echo json_encode($sentArray);
// }

?>


