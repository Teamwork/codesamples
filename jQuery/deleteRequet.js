var company = "YOUR_TEAMWORK_SITE_NAME";
var key = "YOUR_API_KEY";
var task_id = "TASK_ID";
var action = "todo_items/" + task_id + ".json";

$.ajax({
	type: "DELETE",
	url: 'https://' + company + '.teamwork.com/' + action,
    headers: {"Authorization": "BASIC " + window.btoa(key + ":xxx")}
});