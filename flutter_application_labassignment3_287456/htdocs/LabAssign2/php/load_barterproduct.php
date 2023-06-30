<?php
if(!isset($_POST)){
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$results_per_page = 6;
if(isset($_POST['pageno'])){
   $pageno = (int)$_POST['pageno'];
}else{
    $pageno = 1;
}

$page_first_result = ($pageno - 1) * $results_per_page;

if (isset($_POST['cartuserid'])){
	$cartuserid = $_POST['cartuserid'];
}else{
	$cartuserid = '0';
}

if(isset($_POST['userid'])){
    $userid = $_POST['userid'];
    // $sqlloadproduct = "SELECT * FROM `tbl_products` WHERE user_id = '$userid'";
    // $sqlcart = "SELECT * FROM `tbl_cart` WHERE barteruser_id = '$cartuserid'";
    if(isset($_POST['search'])){
        $search = $_POST['search'];
        $sqlloadproduct = "SELECT * FROM `tbl_products` WHERE product_name LIKE '%$search%'";
        $sqlcart = "SELECT * FROM `tbl_cart` WHERE barteruser_id = '$userid'";
    }
    if(isset($_POST['type'])){
        $state = $_POST['state'];
        $type = $_POST['type'];
        $value1 = $_POST['valuea'];
        $value2 = $_POST['valueb'];
        $valuea = floatval($value1);
        $valueb = floatval($value2);
    
        $sqlloadproduct = "SELECT * FROM tbl_products WHERE 1=1";
    
        if ($type != 'All Types') {
            $sqlloadproduct .= " AND product_type = '$type'";
        }
    
        if ($state != 'All States') {
            $sqlloadproduct .= " AND product_state = '$state'";
        }
    
        if ($value1 != '' && $value2 != '') {
            $sqlloadproduct .= " AND product_price BETWEEN $valuea AND $valueb";
        }   
        $sqlcart = "SELECT * FROM `tbl_cart` WHERE barteruser_id = '$userid'";
    }
}

else{
    $sqlloadproduct = "SELECT * FROM `tbl_products` ";
    $sqlcart = "SELECT * FROM `tbl_cart` ";
}


if(isset($sqlcart)){
    $resultcart = $conn->query($sqlcart);
    $number_of_result_cart = $resultcart->num_rows;
    if($number_of_result_cart > 0){
        $totalcart = 0;
        while($rowcart = $resultcart->fetch_assoc()){
            $totalcart += (int) $rowcart['cart_qty'];
        }
    }else{
        $totalcart = 0;
    }
}else{
    $totalcart = 0;
}

$result = $conn->query($sqlloadproduct);
$number_of_result = $result->num_rows;
$number_of_page = ceil($number_of_result / $results_per_page);
$sqlloadproduct = $sqlloadproduct . " LIMIT $page_first_result , $results_per_page";
$result = $conn->query($sqlloadproduct);

if($result->num_rows > 0){
    $product["product"] = array();

    while ($row = $result->fetch_assoc()) {
        $productList = array();
        $productList['product_id'] = $row['product_id'];
        $productList['user_id'] = $row['user_id'];
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
        array_push($product["product"], $productList);
    }
    $response = array('status' => 'success', 'data' => $product, 'numofpage'=> "$number_of_page", 'numberofresult'=> "$number_of_result", 'cartqty'=> "$totalcart");
    sendJsonResponse($response);
}else{
    $response = array('status' => 'failed', 'data' =>null);
    sendJsonResponse($response); 
}

function sendJsonResponse($sentArray){
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

?>