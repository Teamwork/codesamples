var company = "YOUR_TEAMWORK_SITE_NAME";
var key = "YOUR_API_KEY";
var task_id = "TASK_ID";
var action = "todo_items/" + task_id + ".json";
var new_name = "This task was edited via a PUT AJAX request sent in JSON format.";

var json = {"todo-item": { "content": new_name } };

$.ajax({
	type: "PUT",
	url: 'https://' + company + '.teamwork.com/' + action,
	headers: {"Authorization": "BASIC " + window.btoa(key + ":xxx")},
	contentType: "application/json; charset=UTF-8",
	data: JSON.stringify(json)
});
