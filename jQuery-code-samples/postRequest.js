var date = new Date();
var month = date.getMonth() + 1;
var day = date.getDate();

var company = "YOUR_TEAMWORK_SITE_NAME";
var key = "YOUR_API_KEY";
var tasklist_id = "TASK_LIST_ID";
var task_name = "This is an example task created with AJAX using JSON.";
var due_date = date.getFullYear() + (month < 10 ? '0' : '')
  + month + (day < 10 ? '0' : '') + day;

var json = {"todo-item": { "content": task_name, "due-date": due_date }};

$.ajax({
 type: "POST",
 url: "https://" + company + ".teamwork.com/todo_lists/"
  + tasklist_id + "/todo_items.json",
 headers: {"Authorization": "BASIC " + window.btoa(key + ":xxx")},
 data: JSON.stringify(json),
 processData: false,
 contentType: "application/json; charset=UTF-8"
});