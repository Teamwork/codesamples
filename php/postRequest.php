<?php
$company = "YOUR_TEAMWORK_SITENAME";
$key = "YOUR_API_KEY";
$taskListId = 1;
$taskName = "This is an example task.";
$taskDate = time();
  
 
$arr = array(
    'todo-item' =>  array(
        'content'   =>  $taskName,
        'due-date'  =>  date('Ymd', $taskDate)
    )
);
 
$json = json_encode($arr);
 
$ch = curl_init();

$options = array(
    CURLOPT_URL => "https://{$company}.teamwork.com/todo_lists/{$taskListId}/todo_items.json",
    CURLOPT_RETURNTRANSFER => true,
    CURLOPT_POST => true,
    CURLOPT_POSTFIELDS => $json,
    CURLOPT_SSLVERSION => 6,
    CURLOPT_HTTPHEADER => array(
        "Authorization: BASIC ". base64_encode($key .":xxx"),
        "Content-type: application/json"
    )
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

    if ($response == 201) {
        // TODO - Handle cURL response
        $obj = json_decode($result);
        var_dump($obj);
    }
}

curl_close($ch);
