<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}
include_once("dbconnect.php");

if(isset($_POST['search'])){
    $search = $_POST['search'];
    $sqlloadproduct = "SELECT * FROM tbl_products WHERE product_name LIKE '%$search%'"; 
    $result = $conn->query($sqlloadproduct);  
}

else{
    $state = $_POST['state'];
    $type = $_POST['type'];
    $value1 = $_POST['valuea'];
    $value2 = $_POST['valueb'];
    $valuea = floatval($value1);
    $valueb = floatval($value2);  

    $sql = "SELECT * FROM tbl_products WHERE 1=1";

    if ($type != 'All Types') {
        $sql .= " AND product_type = '$type'";
    }

    if ($state != 'All States') {
        $sql .= " AND product_state = '$state'";
    }

    if ($value1 != '' && $value2 != '') {
        $sql .= " AND product_price BETWEEN $valuea AND $valueb";
    }
    
    $result = mysqli_query($conn, $sql);
}
// else if(isset($_POST['type']) || isset($_POST['state']) || isset($_POST['value'])){
//     $type = $_POST['type'];
//     $state = $_POST['state']; 
//     $value1 = $_POST['valuea'];
//     $value2 = $_POST['valueb'];
//     $valuea = floatval($value1);
//     $valueb = floatval($value2);  
    
//     $sqlloadproduct = "SELECT * FROM tbl_products WHERE product_type = '$type' OR product_state = '$state' OR product_price BETWEEN '$valuea' AND '$valueb'";               
        
// }

if ($result->num_rows > 0) {
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
?>