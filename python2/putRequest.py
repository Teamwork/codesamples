import urllib2, urllib, base64
 
company = "YOUR_TEAMWORK_SITE_NAME"
key = "YOUR_API_KEY"
task_id = TASK_ID
action = "todo_items/{0}/complete.json".format(task_id)
 
request = urllib2.Request("https://{0}.teamwork.com/{1}".format(company, action))
request.add_header("Authorization", "BASIC " +  base64.b64encode(key + ":xxx"))
request.add_header("Content-Type", "application/json")
request.get_method = lambda: "PUT"
 
response = urllib2.urlopen(request)
data = response.read()
print data