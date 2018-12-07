$company = "YOUR_TEAMWORK_SITE_NAME";
$key = "YOUR_API_KEY";
$taskListId = TASK_LIST_ID;
$taskName = "This is an example task.";
$taskDate = time();
  
 
$arr = array('todo-item' => 
                array(  'content' => $taskName, 
                        'due-date' => date( 'Ymd', $taskDate ) ));
 
$json = json_encode($arr);
 
 
$channel = curl_init();
 
curl_setopt( $channel, CURLOPT_URL, 
    "https://{$company}.teamwork.com/todo_lists/{$taskListId}/todo_items.json"
);
curl_setopt( $channel, CURLOPT_RETURNTRANSFER, 1 );
curl_setopt( $channel, CURLOPT_POST, 1 );
curl_setopt( $channel, CURLOPT_POSTFIELDS, $json );
curl_setopt( $channel, CURLOPT_HTTPHEADER, array( 
    "Authorization: BASIC ". base64_encode( $key .":xxx" ),
    "Content-type: application/json"
));
 
curl_exec ( $channel );
  
curl_close ( $channel );
 