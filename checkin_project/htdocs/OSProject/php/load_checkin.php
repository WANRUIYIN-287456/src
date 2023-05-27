<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}//added

include_once("dbconnect.php");

$userid = $_POST['userid'];

$sqlloadcheckin = "SELECT * FROM `tbl_checkin` WHERE user_id = '$userid' ORDER BY checkin_id DESC";
$result = $conn->query($sqlloadcheckin);

if ($result->num_rows > 0) {
	$history["history"]= array();
	while ($row = $result->fetch_assoc()) {
		$checkinarray = array();
		$checkinarray['checkin_id'] = $row['checkin_id'];
		$checkinarray['user_id'] = $row['user_id'];//added
		$checkinarray['checkin_course'] = $row['checkin_course'];
		$checkinarray['checkin_group'] = $row['checkin_group'];
		$checkinarray['checkin_location'] = $row['checkin_location'];
		$checkinarray['checkin_state'] = $row['checkin_state'];
		$checkinarray['checkin_lat'] = $row['checkin_lat'];
		$checkinarray['checkin_long'] = $row['checkin_long'];
		$checkinarray['checkin_date'] = $row['checkin_date'];

		array_push($history["history"],$checkinarray);
	}
	$response = array('status' => 'success', 'data' => $history);
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