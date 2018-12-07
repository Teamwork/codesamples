var http = require('request');
var company = "YOUR_TEAMWORK_SITE_NAME";
var key = "YOUR_API_KEY";
 
var base64 = new Buffer(key + ":xxx").toString("base64");
 
var options = {
    hostname: company + ".teamwork.com",
    path: "/projects.json",
    method: "GET",
    headers: {
        "Authorization": "BASIC " + base64,
        "Content-Type": "application/json"
    }
};
 
var req = request(options, function(res) {
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
 
req.end();