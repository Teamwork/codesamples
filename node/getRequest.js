const http = require('http');
const company = "YOUR_TEAMWORK_SITE_NAME";
const key = "YOUR_API_KEY";

const base64 = Buffer.from(`${key}:xxx`).toString("base64");

const options = {
    hostname: `${company}.teamwork.com`,
    path: "/projects.json",
    method: "GET",
    headers: {
        "Authorization": `BASIC ${base64}`,
        "Content-Type": "application/json"
    }
};

const req = http.request(options, function(res) {
    console.log(`STATUS: ${res.statusCode}`);
    console.log(`HEADERS: ${JSON.stringify(res.headers)}`);
    res.setEncoding("utf8");
    res.on("data", function (chunk) {
        console.log(`BODY: ${chunk}`);
    });
});

req.on("error", function(e) {
    console.log(`ERROR: ${error.message}`);
});

req.end();