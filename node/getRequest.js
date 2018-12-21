const request = require('request');
const company = "YOUR_TEAMWORK_SITE_NAME";
const key = "YOUR_API_KEY";

const base64 = Buffer.from(key + ":xxx").toString("base64");

const options = {
    uri: `https://${company}.teamwork.com/projects.json`,
    method: "GET",
    headers: {
        "Authorization": `BASIC ${base64}`,
        "Content-Type": "application/json"
    }
};
 
const req = request(options, (error, res, body) => {
    if (error) {
        console.log(`ERROR: ${error.message}`);
        return;
    }

    console.log(`STATUS: ${res.statusCode}`);
    console.log(`HEADERS: ${JSON.stringify(res.headers)}`);
    res.setEncoding("utf8");

    console.log(`BODY: ${body}`);
});

req.end();