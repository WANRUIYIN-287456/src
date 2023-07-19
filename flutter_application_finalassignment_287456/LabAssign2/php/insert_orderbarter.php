<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}
include_once("dbconnect.php");
$productid = $_POST['productid'];
$barterproductid = $_POST['barterproductid'];
$barterproductname = $_POST['barterproductname'];
$orderqty = $_POST['orderqty'];
$orderprice = $_POST['orderprice'];
$barteruserid = $_POST['barteruserid'];
$userid = $_POST['userid'];
$orderstatus = $_POST['orderstatus'];
$barterstatus = $_POST['barterstatus'];
$cartid = $_POST['cartid'];
$owner = $_POST['owner'];
$buyer = isset($_POST['buyer']) ? $_POST['buyer'] : ''; // Set a default value if $_POST['buyer'] is not set

$sql1 = "INSERT INTO tbl_orderbarter (product_id, barterproduct_id, barterproduct_name, barterorder_status) VALUES ('$productid', '$barterproductid', '$barterproductname', '$barterstatus')";
if ($conn->query($sql1) === TRUE) {
    $last_id = $conn->insert_id;
    $sql2 = "INSERT INTO tbl_order (barterorder_id, product_id, order_qty, barteruser_id, user_id, order_status, owner_status, buyer_status) VALUES ('$last_id', '$productid', '$orderqty', '$barteruserid', '$userid', '$orderstatus', '$owner', '$buyer')";
    if ($conn->query($sql2) === TRUE) {
        $cartid = $_POST['cartid'];
        $sql3 = "DELETE FROM tbl_cart WHERE cart_id = '$cartid'";
        
        $sqlcart = "SELECT * FROM `tbl_cart` ";
        if (isset($sqlcart)) {
            $resultcart = $conn->query($sqlcart);
            $number_of_result_cart = $resultcart->num_rows;
            if ($number_of_result_cart > 0) {
                $totalcart = 0;
                while ($rowcart = $resultcart->fetch_assoc()) {
                    $totalcart += (int) $rowcart['cart_qty'];
                }
            } else {
                $totalcart = 0;
            }
        } else {
            $totalcart = 0;
        }
        if ($conn->query($sql3) === TRUE) {
            $response = array('status' => 'success', 'data' => $sql3);
            sendJsonResponse($response);
        } else {
            $response = array('status' => 'failed', 'data' => $sql3);
            sendJsonResponse($response);
        }
    } else {
        $response = array('status' => 'failed', 'data' => $sql2);
        sendJsonResponse($response);
    }
} else {
    $response = array('status' => 'failed', 'data' => $sql1);
    sendJsonResponse($response);
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>
