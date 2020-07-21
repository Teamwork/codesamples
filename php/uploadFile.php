<?php
$company = "YOUR_TEAMWORK_SITENAME";
$key = "YOUR_API_KEY";
$file = 'samplefile.txt';
$fileNameWithFullPath = realpath($file);
$mimeType = mime_content_type($file);
$pathParts = pathinfo($file);
$args['file'] = new CurlFile($fileNameWithFullPath, $mimeType, $file);

$ch = curl_init();

$options = array(
    CURLOPT_URL => "https://{$company}.teamwork.com/pendingfiles.json",
    CURLOPT_RETURNTRANSFER => true,
    CURLOPT_FOLLOWLOCATION => true,
    CURLOPT_POST => true,
    CURLOPT_POSTFIELDS => $args,
    CURLOPT_SSLVERSION => 6,
    CURLOPT_HTTPHEADER => array("Authorization: BASIC " . base64_encode($key . ":xxx"))
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
        $pendingFileRef = $obj->pendingFile->ref;
        $projectID = 1;
        $action = "projects";

        // Example - Add a File to a Task
        // https://developer.teamwork.com/projects/files/add-a-file-to-a-project
        $arr = array(
            "file" => array(
                "name" => $pathParts['basename'],
                "description" => "Some description",
                "private" => "0",
                "category-id" => "0",
                "category-name" => "My new category",
                "pendingFileRef" => $pendingFileRef,
                "tags" => "tag1,tag2,tag3"
            )
        );

        $json = json_encode($arr);

        $options = array(
            CURLOPT_URL => "https://{$company}.teamwork.com/{$action}/{$projectID}/files.json",
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_FOLLOWLOCATION => true,
            CURLOPT_POST => true,
            CURLOPT_POSTFIELDS => $json,
            CURLOPT_SSLVERSION => 6,
            CURLOPT_HTTPHEADER => array(
                "Authorization: BASIC " . base64_encode($key . ":xxx"),
                "Content-Type: application/json"
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
    }
}

curl_close($ch);
