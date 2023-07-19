<?php
include_once("dbconnect.php");
$barteruserid = $_GET['barteruserid'];
$phone = $_GET['phone'];
$amount = $_GET['amount'];
$email = $_GET['email'];
$name = $_GET['name'];

$data = array(
    'id' =>  $_GET['billplz']['id'],
    'paid_at' => $_GET['billplz']['paid_at'] ,
    'paid' => $_GET['billplz']['paid'],
    'x_signature' => $_GET['billplz']['x_signature']
);

$paidstatus = $_GET['billplz']['paid'];
if ($paidstatus=="true"){
    $paidstatus = "Success";
}else{
    $paidstatus = "Failed";
}
$receiptid = $_GET['billplz']['id'];
$signing = '';
foreach ($data as $key => $value) {
    $signing.= 'billplz'.$key . $value;
    if ($key === 'paid') {
        break;
    } else {
        $signing .= '|';
    }
}
 
$signed= hash_hmac('sha256', $signing, 'S-wzNn8FTL0endIB4wgi728w');
if ($signed === $data['x_signature']) {
    if ($paidstatus == "Success"){ //payment success
         $sqlcart = "SELECT * FROM `tbl_cart` WHERE barteruser_id = '$barteruserid' ORDER BY user_id ASC";
        $result = $conn->query($sqlcart);
        $user = "";
        $singleorder = 0;
        $i =0;
        $numofrows = $result->num_rows;
        if ($result->num_rows > 0) {
            while ($row = $result->fetch_assoc()) {
                $user_id = $row['user_id'];
                $productid = $row['product_id'];
                $orderqty = $row['cart_qty'];
                $order_paid = $row['cart_price'];
                
                if ($i==0){
                    $user = $user_id;
                }
                
                if ($user == $user_id){
                    $singleorder = $singleorder + $order_paid;    
                }else{
                    $sqlorder ="INSERT INTO `tbl_orders`( `order_bill`, `order_paid`, `barteruser_id`, `user_id`, `order_status`) VALUES ('$receiptid','$singleorder','$barteruserid','$user','New')";
                    $conn->query($sqlorder);
                    $user = $user_id;
                    $singleorder = $order_paid;
                }
                
                if ($i == ($numofrows-1)){
                     $singleorder = $singleorder; 
                    $sqlorder ="INSERT INTO `tbl_orders`( `order_bill`, `order_paid`, `barteruser_id`, `user_id`, `order_status`) VALUES ('$receiptid','$singleorder','$barteruserid','$user','New')";
                    $conn->query($sqlorder);
                }
                $i++;
                
                $sqlorderdetails = "INSERT INTO `tbl_orderdetails`(`order_bill`, `product_id`, `orderdetail_qty`, `orderdetail_paid`, `barteruser_id`, `user_id`) VALUES ('$receiptid','$productid','$orderqty','$order_paid','$barteruserid','$user_id')";
                $conn->query($sqlorderdetails);
                $sqlupdatecatchqty = "UPDATE `tbl_products` SET `product_qty`= (product_qty - $orderqty) WHERE `product_id` = '$productid'";
                $conn->query($sqlupdatecatchqty);
            }
            $sqldeletecart = "DELETE FROM `tbl_cart` WHERE barteruser_id = '$barteruserid'";
            $conn->query($sqldeletecart);
        }
        
        echo "
        <html><meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">
        <link rel=\"stylesheet\" href=\"https://www.w3schools.com/w3css/4/w3.css\">
        <body>
        <center><h4>Receipt</h4></center>
        <table class='w3-table w3-striped'>
        <th>Item</th><th>Description</th>
        <tr><td>Name</td><td>$name</td></tr>
        <tr><td>Email</td><td>$email</td></tr>
        <tr><td>Phone</td><td>$phone</td></tr>
        <tr><td>Paid Amount</td><td>RM$amount</td></tr>
        <tr><td>Paid Status</td><td class='w3-text-green'>$paidstatus</td></tr>
        </table><br>
        
        </body>
        </html>";
    }
    else 
    {
         echo "
        <html><meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">
        <link rel=\"stylesheet\" href=\"https://www.w3schools.com/w3css/4/w3.css\">
        <body>
        <center><h4>Receipt</h4></center>
        <table class='w3-table w3-striped'>
        <th>Item</th><th>Description</th>
        <tr><td>Name</td><td>$name</td></tr>
        <tr><td>Email</td><td>$email</td></tr>
        <tr><td>Phone</td><td>$phone</td></tr>
        <tr><td>Paid</td><td>RM $amount</td></tr>
        <tr><td>Paid Status</td><td class='w3-text-red'>$paidstatus</td></tr>
        </table><br>
        
        </body>
        </html>";
    }
}

// include_once("dbconnect.php");
// $barteruserid = $_GET['barteruserid'];
// $phone = $_GET['phone'];
// $amount = $_GET['amount'];
// $email = $_GET['email'];
// $name = $_GET['name'];
// //$userid = $_GET['userid'];
// $data = array(
//     'id' =>  $_GET['billplz']['id'],
//     'paid_at' => $_GET['billplz']['paid_at'] ,
//     'paid' => $_GET['billplz']['paid'],
//     'x_signature' => $_GET['billplz']['x_signature']
// );

// $paidstatus = $_GET['billplz']['paid'];
// if ($paidstatus=="true"){
//     $paidstatus = "Success";
// }else{
//     $paidstatus = "Failed";
// }
// $receiptid = $_GET['billplz']['id'];
// $signing = '';
// foreach ($data as $key => $value) {
//     $signing.= 'billplz'.$key . $value;
//     if ($key === 'paid') {
//         break;
//     } else {
//         $signing .= '|';
//     }
// }
 
 
// $signed= hash_hmac('sha256', $signing, 'S-wzNn8FTL0endIB4wgi728w');
// if ($signed === $data['x_signature']) {
//     if ($paidstatus == "Success"){ //payment success
//         $sqlcart = "SELECT * FROM `tbl_cart` WHERE barteruser_id = '$barteruserid' ORDER BY 'user_id'";
//         $result = $conn->query($sqlcart);
//         $user = '';
//         $singleorder =0;
//         $i = 0;
//         $numofrows = $result->num_rows;
//         if ($result->num_rows > 0) {
//             while ($row = $result->fetch_assoc()) {
//                 $productid = $row['product_id'];
//                 $orderqty = $row['cart_qty'];
//                 $order_paid = $row['cart_price'];
//                 $user_id = $row['user_id'];
//                  if($i==0){
//                      $user = $user_id;
//                  }
//                 $sqlorderdetails = "INSERT INTO `tbl_orderdetails`(`order_bill`, `product_id`, `orderdetail_qty`, `orderdetail_paid`, `barteruser_id`, `user_id`) VALUES ('$receiptid','$productid','$orderqty','$order_paid','$barteruserid','$userid')";
//                 $conn->query($sqlorderdetails);
//                 $sqlorder = "INSERT INTO `tbl_order`(`order_bill`, `order_paid`, `barteruser_id`, `user_id`) VALUES ('$receiptid','$amount','$orderqty','$barteruserid','$userid')";
//                 $conn->query($sqlorderdetails);
                
//                 $sqlupdateproductqty = "UPDATE `tbl_products` SET `product_qty`= (product_qty - $orderqty) WHERE `product_id` = '$productid'";
//                 $conn->query($sqlupdateproductqty);
//             }
//             $sqldeletecart = "DELETE FROM `tbl_cart` WHERE barteruser_id = '$userid'";
//             $conn->query($sqldeletecart);
//         }
        
//         echo "
//         <html><meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">
//         <link rel=\"stylesheet\" href=\"https://www.w3schools.com/w3css/4/w3.css\">
//         <body>
//         <center><h4>Receipt</h4></center>
//         <table class='w3-table w3-striped'>
//         <th>Item</th><th>Description</th>
//         <tr><td>Name</td><td>$name</td></tr>
//         <tr><td>Email</td><td>$email</td></tr>
//         <tr><td>Phone</td><td>$phone</td></tr>
//         <tr><td>Paid Amount</td><td>RM$amount</td></tr>
//         <tr><td>Paid Status</td><td class='w3-text-green'>$paidstatus</td></tr>
//         </table><br>
        
//         </body>
//         </html>";
//     }
//     else 
//     {
//          echo "
//         <html><meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">
//         <link rel=\"stylesheet\" href=\"https://www.w3schools.com/w3css/4/w3.css\">
//         <body>
//         <center><h4>Receipt</h4></center>
//         <table class='w3-table w3-striped'>
//         <th>Item</th><th>Description</th>
//         <tr><td>Name</td><td>$name</td></tr>
//         <tr><td>Email</td><td>$email</td></tr>
//         <tr><td>Phone</td><td>$phone</td></tr>
//         <tr><td>Paid</td><td>RM$amount</td></tr>
//         <tr><td>Paid Status</td><td class='w3-text-red'>$paidstatus</td></tr>
//         </table><br>
        
//         </body>
//         </html>";
//     }
// }

?>