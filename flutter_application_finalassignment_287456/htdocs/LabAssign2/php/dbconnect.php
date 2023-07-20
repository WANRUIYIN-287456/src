<?php
// $servername = "localhost";
// $username = "nwarzcom_labassign2admin";
// $password = "labassign2admin";
// $dbname = "nwarzcom_labassign2";

$servername = "localhost";
$username = "root";
$password = "";
$dbname = "nwarzcom_labassign2";

$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn -> connect_error) {
die("Connection failed: " . $conn -> connect_error);
}
?>