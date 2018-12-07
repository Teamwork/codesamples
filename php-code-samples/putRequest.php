$company = "YOUR TEAMWORK SITENAME";
$key = "YOUR_API_KEY";
$taskId = 12345;
$action = "todo_items/".$taskId."/complete.json";
$channel = curl_init();
curl_setopt( $channel, CURLOPT_URL, "https://". $company .".teamwork.com/". $action );
curl_setopt( $channel, CURLOPT_RETURNTRANSFER, 1 );
curl_setopt($channel, CURLOPT_CUSTOMREQUEST, "PUT");
curl_setopt( $channel, CURLOPT_HTTPHEADER,
array( "Authorization: BASIC ". base64_encode( $key .":xxx" ))
);
echo curl_exec ( $channel );
curl_close ( $channel );