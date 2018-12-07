import urllib2, base64
from datetime import datetime
import json.etree.cElementTree as ET
 
company = "YOUR_TEAMWORK_SITE_NAME"
key = "YOU_API_KEY"
tasklist_id = "YOUR_TASK_LIST_ID"
task_name = "This is an example task."
due_date = datetime.now().strftime("%Y%m%d")
 
root = ET.Element("request")
todo_el = ET.SubElement(root, "todo-item")
content_el = ET.SubElement(todo_el, "content")
due_date_el = ET.SubElement(todo_el, "due-date")
 
content_el.text = task_name
due_date_el.text = due_date
 
json_string = ET.tostring(root, encoding="utf-8", method="json")
 
request = urllib2.Request(
    "https://{0}.teamwork.com/todo_lists/{1}/todo_items.json".format(company, tasklist_id),
    json_string)
request.add_header("Authorization", "BASIC " +  base64.b64encode(key + ":xxx"))
request.add_header("Content-type", "application/json")
 
response = urllib2.urlopen(request)
data = response.read()
print data