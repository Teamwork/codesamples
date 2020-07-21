<?php
$company = "YOUR_TEAMWORK_SITENAME";
$key = "YOUR_API_KEY";
$taskID = 1;
$action = "todo_items/{$taskID}.json";

$ch = curl_init();

$options = array(
    CURLOPT_URL => "https://{$company}.teamwork.com/{$action}",
    CURLOPT_RETURNTRANSFER => true,
    CURLOPT_CUSTOMREQUEST => "DELETE",
    CURLOPT_SSLVERSION => 6,
    CURLOPT_HTTPHEADER => array("Authorization: BASIC ". base64_encode($key .":xxx"))
);

curl_setopt_array($ch, $options);

$result = curl_exec($ch);
if (curl_error($ch)) {
    $error_msg = curl_error($ch);
}

if (isset($error_msg)) {
    // TODO - Handle cURL error
}

if ($result !== false) {
    $response = curl_getinfo($ch, CURLINFO_HTTP_CODE);  

    if ($response == 200) {
        // TODO - Handle cURL response
        $obj = json_decode($result);
        var_dump($obj);
    }
}

curl_close($ch);
