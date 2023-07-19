<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

    $userid = $_POST['userid'];
    $sqlcart = "SELECT * FROM `tbl_cart` INNER JOIN `tbl_products` ON tbl_cart.product_id = tbl_products.product_id WHERE tbl_cart.barteruser_id = '$userid'";

// else{
//     $sqlcart = "SELECT * FROM `tbl_cart` INNER JOIN `tbl_products` ON tbl_cart.product_id = tbl_products.product_id";
// }

$result = $conn->query($sqlcart);
if ($result->num_rows > 0) {
   $cart["cart"] = array();
	
while ($row = $result->fetch_assoc()) {
       $cartList = array();
       $cartList['cart_id'] = $row['cart_id'];
       $cartList['product_id'] = $row['product_id'];
       $cartList['product_name'] = $row['product_name'];
       //product_status
       $cartList['product_type'] = $row['product_type'];
       $cartList['product_desc'] = $row['product_desc'];
       $cartList['product_price'] = $row['product_price'];
       $cartList['product_qty'] = $row['product_qty'];
       $cartList['product_date'] = $row['product_date'];
       $cartList['product_locality'] = $row['product_locality'];
       $cartList['product_state'] = $row['product_state'];
       $cartList['product_option'] = $row['product_option'];
       $cartList['product_status'] = $row['product_status'];
       $cartList['cart_price'] = $row['cart_price'];
       $cartList['cart_qty'] = $row['cart_qty'];
       $cartList['user_id'] = $row['user_id'];
       $cartList['barteruser_id'] = $row['barteruser_id'];
		$cartList['cart_date'] = $row['cart_date'];
        array_push($cart["cart"],$cartList);
    }
    $response = array('status' => 'success', 'data' => $cart);
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