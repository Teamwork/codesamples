$url = "https://YOUR_COMPANY_NAME.teamwork.com";
 
$key = "YOUR_API_KEY";
 
$filename = 'samplefile.txt';
 
$file_name_with_full_path = realpath($filename);
 
$args['file'] = new CurlFile($file_name_with_full_path, 'text/plain', $filename);
 
$channel = curl_init();
 
curl_setopt($channel, CURLOPT_URL, "$url/pendingfiles.json");
 
curl_setopt($channel, CURLOPT_RETURNTRANSFER, 1);
 
curl_setopt($channel, CURLOPT_FOLLOWLOCATION, true);
 
curl_setopt($channel, CURLOPT_POST, true);
 
curl_setopt($channel, CURLOPT_SSL_VERIFYPEER, false);
 
curl_setopt($channel, CURLOPT_POSTFIELDS, $args);
 
curl_setopt($channel, CURLOPT_HTTPHEADER,
 
    array("Authorization: BASIC " . base64_encode($key . ":xxx")));
 
$result = curl_exec($channel);
 
curl_close($channel);
 
print_r($result);