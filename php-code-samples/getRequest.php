$company = "YOUR TEAMWORK SITENAME";
$key = "YOUR_API_KEY";
$action = "projects.json";
 
$channel = curl_init();
 
curl_setopt( $channel, CURLOPT_URL, "https://". $company .".teamwork.com/". $action );
curl_setopt( $channel, CURLOPT_RETURNTRANSFER, 1 ); 
curl_setopt( $channel, CURLOPT_HTTPHEADER, 
    array( "Authorization: BASIC ". base64_encode( $key .":xxx" ))
);
 
echo curl_exec ( $channel );
 
curl_close ( $channel );