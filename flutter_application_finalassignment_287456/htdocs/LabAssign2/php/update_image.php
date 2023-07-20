<?php


    if (empty($_POST)) {
        $response = array('status' => 'failed', 'data' => null);
        sendJsonResponse($response);
        die();
    }
    
    if (isset($_POST['image']) && isset($_POST['userid'])) {
        $image = $_POST['image'];
        $userid = $_POST['userid'];
        $decoded_string = base64_decode($image);
        $pathdir = '../assets/images/profile/';
        $path = $pathdir . $userid . '.png';
    
        if (!is_dir($pathdir)) {
            mkdir($pathdir, 0777, true);
        }
    
        if (is_dir($pathdir) && is_writable($pathdir)) {
            if (file_put_contents($path, $decoded_string) !== false) {
                $response = array('status' => 'success', 'data' => 'OK', 'image_url' => $path);
                sendJsonResponse($response);
            } else {
                $response = array('status' => 'failed', 'data' => 'Failed to write file');
                sendJsonResponse($response);
            }
        } else {
            $response = array('status' => 'failed', 'data' => 'Directory is not writable');
            sendJsonResponse($response);
        }
    } else {
        $response = array('status' => 'failed', 'data' => 'Missing parameters');
        sendJsonResponse($response);
    }
    
    function sendJsonResponse($sentArray)
    {
        header('Content-Type: application/json');
        echo json_encode($sentArray);
    }

    
  
// if (!isset($_POST)) {
//     $response = array('status' => 'failed', 'data' => null);
//     sendJsonResponse($response);
//     die();
// }

// include_once("dbconnect.php");

// $username = $_POST['username'];
// $userphone = $_POST['userphone'];
// $useremail = $_POST['useremail'];
// $userid = $_POST['userid'];

// $sqlupdate = "UPDATE `tbl_users` SET `user_name`= ?, `user_phone`= ?, `user_email`= ? WHERE `user_id` = ?";

// if (isset($_POST['oldpass'])) {
//     $oldpass = sha1($_POST['oldpass']);
//     $newpass = sha1($_POST['newpass']);
//     $userid = $_POST['userid'];
//     include_once("dbconnect.php");
//     $sqllogin = "SELECT * FROM tbl_users WHERE user_id = ? AND user_password = ?";
//     $stmt = $conn->prepare($sqllogin);
//     $stmt->bind_param("ss", $userid, $oldpass);
//     $stmt->execute();
//     $result = $stmt->get_result();

//     if ($result->num_rows > 0) {
//         $sqlupdate = "UPDATE tbl_users SET user_password = ? WHERE user_id = ?";
//         $stmt = $conn->prepare($sqlupdate);
//         $stmt->bind_param("ss", $newpass, $userid);

//         if ($stmt->execute()) {
//             $response = array('status' => 'success', 'data' => null);
//             sendJsonResponse($response);
//         } else {
//             $response = array('status' => 'failed', 'data' => null);
//             sendJsonResponse($response);
//         }
//     } else {
//         $response = array('status' => 'failed', 'data' => null);
//         sendJsonResponse($response);
//     }
// } else {
//     $stmt = $conn->prepare($sqlupdate);
//     $stmt->bind_param("ssss", $username, $userphone, $useremail, $userid);

//     if ($stmt->execute()) {
//         $response = array('status' => 'success', 'data' => null);
//         sendJsonResponse($response);
//     } else {
//         $response = array('status' => 'failed', 'data' => null);
//         sendJsonResponse($response);
//     }
// }

// function sendJsonResponse($sentArray)
// {
//     header('Content-Type: application/json');
//     echo json_encode($sentArray);
// }

?>




