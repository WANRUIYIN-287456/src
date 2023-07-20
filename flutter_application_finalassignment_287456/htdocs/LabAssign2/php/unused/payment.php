<?php
error_reporting(0);

$email = $_POST['email'];
$phone = $_POST['phone'];
$name = $_POST['name'];
$userid = $_POST['userid'];
$barteruserid = $_POST['barteruserid'];
$amount = $_POST['amount'];

$api_key = '3ef7370f-5f82-4a9d-90a7-26e9cd88e6d3';
$collection_id = 'l0kedsro';
$host = 'https://www.billplz-sandbox.com/api/v4/bills';

$data = array(
    'collection_id' => $collection_id,
    'email' => $email,
    'mobile' => $phone, // 'mobile'=> $mobile
    'name' => $name,
    'amount' => ($amount + 1) * 100,
    'description' => 'Payment for order by' .$name, 
    'callback_url' => "https://nwarz.com/labassign2/return_url",
    'redirect_url' => "https://nwarz.com/labassign2/php/payment_update.php?userid=$userid&email=$email&phone=$phone&amount=$amount&name=$name"
);

$process = curl_init($host);
curl_setopt($process, CURLOPT_HEADER, 0);
curl_setopt($process, CURLOPT_USERPWD, $api_key.":");
curl_setopt($process, CURLOPT_TIMEOUT, 30);
curl_setopt($process, CURLOPT_RETURNTRANSFER, 1);
curl_setopt($process, CURLOPT_SSL_VERIFYHOST, 0);
curl_setopt($process, CURLOPT_SSL_VERIFY_PEER, 0);
curl_setopt($process, CURLOPT_POSTFIELDS, http_build_query($data));

$return = curl_exec($process);
curl_close($process);

$bill = json_decode($return, true);
header("Location: {$bill['url']}");

?>