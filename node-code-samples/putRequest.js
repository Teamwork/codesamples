var http = require('http');
var company = "YOUR_TEAMWORK_SITE_NAME";
var key = "YOUR_API_KEY";
var task_id = "TASK_ID";
var new_name = "This task was edited using a PUT request sent via Node.js in JSON format.";
 
var base64 = new Buffer(key + ":xxx").toString("base64");
 
var json = {"todo-item": { "content": new_name } };
 
var options = {
    hostname: company + ".teamwork.com",
    path: "/todo_items/" + task_id + ".json",
    method: "PUT",
    headers: {
        "Authorization": "BASIC " + base64
    }
};
 
var req = http.request(options, function(res) {
    console.log("STATUS: " + res.statusCode);
    console.log("HEADERS: " + JSON.stringify(res.headers));
    res.setEncoding("utf8");
    res.on("data", function (chunk) {
        console.log("BODY: " + chunk);
    });
});
 
req.on("error", function(e) {
    console.log("ERROR: " + e.message);
});
 
req.write(JSON.stringify(json));
req.end();