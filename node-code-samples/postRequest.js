var request = require('request');
var company = "YOUR_TEAMWORK_SITE_NAME";
var key = "YOUR_API_KEY";
var tasklist_id = "TASK_LIST_ID";
var task_name = "This is an example task created using Node.js in JSON format.";
 
var date = new Date();
var month = date.getMonth() + 1;
var day = date.getDate();
var due_date = date.getFullYear() + (month < 10 ? '0' : '')
  + month + (day < 10 ? '0' : '') + day;
 
var base64 = new Buffer(key + ":xxx").toString("base64");
 
var json = {"todo-item": { "content": task_name, "due-date": due_date }};
 
var options = {
 hostname: company + ".teamworkpm.net",
 path: "/todo_lists/" + tasklist_id + "/todo_items.json",
 method: "POST",
 encoding: "utf8",
 followRedirect: true,
 headers: {
  "Authorization": "BASIC " + base64,
  "Content-Type": "application/json"
 },
 json: json
};
 
request(options, function (error, response, body) {
 console.log("STATUS: " + res.statusCode);
 console.log("HEADERS: " + JSON.stringify(res.headers));
 res.setEncoding("utf8");
 res.on("data", function (chunk) {
  console.log("BODY: " + chunk);
 });
});