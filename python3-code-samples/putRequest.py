import urllib3

http = urllib3.PoolManager()

company = "YOUR_TEAMWORK_SITE_NAME"
key = "YOUR_API_KEY"
task_id = "TASK_ID"
action = "tasks/{0}/complete.json".format(task_id)

url = "https://{0}.teamwork.com/{1}".format(company, action)
headers = urllib3.util.make_headers(basic_auth=key + ":xxx")
request = http.request('PUT', url, headers=headers)

response = request.status
data = request.data

print(data)