import urllib3
import json

http = urllib3.PoolManager()

company = "YOUR_TEAMWORK_SITE_NAME"
key = "YOUR_API_KEY"
tasklist_id = "TASKLIST_ID"
action = "tasklists/{0}/tasks.json".format(tasklist_id)

encoded_body = json.dumps({
    "todo-item":{
        "content": "Test Task",
        "description": "Test Task Sub Item"
    }
})

url = "https://{0}.teamwork.com/{1}".format(company, action)
headers = urllib3.util.make_headers(basic_auth=key + ":xxx")
request = http.request('POST', url, headers=headers, body=encoded_body)

response = request.status
data = request.data

print(data)
