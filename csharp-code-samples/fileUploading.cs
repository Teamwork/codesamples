/*Once this is done and you get back a ref ID you can pass it into
many endpoints */

var info = new FileInfo(filepath);
FileStream fs = info.Open(FileMode.Open, FileAccess.Read, FileShare.ReadWrite);

var streamContent = new StreamContent(fs);
streamContent.Headers.Add("Content-Type", "application/octet-stream");
streamContent.Headers.Add("Content-Disposition",
"form-data; name=\"file\"; filename=\"" + Path.GetFileName(filepath) + "\"");
content.Add(streamContent, "file", Path.GetFileName(filepath));

HttpResponseMessage message = await HttpClient.PostAsync("pendingfiles.json", content);

if (message.StatusCode != HttpStatusCode.OK)
{
    using (Stream responseStream = await message.Content.ReadAsStreamAsync())
   {
    string jsonMessage = new StreamReader(responseStream).ReadToEnd();
    // JsonMessage contains ->   {"pendingFile":{"ref":"tf_xxxxx"}}
   }
}