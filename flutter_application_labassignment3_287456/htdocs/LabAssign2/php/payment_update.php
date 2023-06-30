<?php
error_reporting(0);
include_once("dbconnect.php");
$email = $_POST['email'];
$phone = $_POST['phone'];
$name = $_POST['name'];
$userid = $_POST['userid'];
$amount = $_POST['amount'];

$data = array(
    'id' => $_POST['billplz']['id'],
    'paid_at' => $_POST['billplz']['paid_at'], //time
    'paid' => $_POST['billplz']['paid'], //paid value
    'x_signature' => $_POST['billplz']['x_signature'],
);

$paidstatus = $_POST['billplz']['paid'];
if($paidstatus == TRUE) {
    $paidstatus = 'Success';
}
else{
    $paidstatus = 'Failed';
}

$receiptid = $_POST['billplz']['id'];
$signing = '';
foreach ($data as $key => $value){
    $signing .= 'billplz'.$key.$value;
    if($key === 'paid'){
        break;
    }
    else{
        $signing .= '|';
    }
}

$signed = hash_hmac('sha256', $signing, '');
if($signed === $data['x_signature']){
    if($paidstatus == 'Success'){
        //echo 'Payment successful';
        echo "
        <html><meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">
        <link rel=\"stylesheet\" href=\"https://www.w3schools.com/w3css/4/w3.css\">
        <body>
        <center><h4>Receipt</h4></center>
        <table class = 'w3-table w3-striped'>
        <th>Item</th><th>Description</th>
        <tr><td>Name</td><td>$name</td></tr>
        <tr><td>Email</td><td>$email</td></tr>
        <tr><td>Phone</td><td>$phone</td></tr>
        <tr><td>Paid Amounr</td><td>RM$amount</td></tr>
        <tr><td>Paid Status</td><td class='w3-text-green'>$paidstatus</td></tr>
        </table><br>

        </body>
        </html>
        ";
    }
    else{
        //echo 'Payment failed';
        echo "
        <html><meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">
        <link rel=\"stylesheet\" href=\"https://www.w3schools.com/w3css/4/w3.css\">
        <body>
        <center><h4>Receipt</h4></center>
        <table class = 'w3-table w3-striped'>
        <th>Item</th><th>Description</th>
        <tr><td>Name</td><td>$name</td></tr>
        <tr><td>Email</td><td>$email</td></tr>
        <tr><td>Phone</td><td>$phone</td></tr>
        <tr><td>Paid Amounr</td><td>RM$amount</td></tr>
        <tr><td>Paid Status</td><td class='w3-text-red'>$paidstatus</td></tr>
        </table><br>

        </body>
        </html>
        ";
    }
}

?>