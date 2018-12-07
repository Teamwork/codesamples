var company = "YOUR_TEAMWORK_SITE_NAME";
var key = "YOUR_API_KEY";
var action = "projects.json";

$.ajax({
	url: 'https://' + company + '.teamwork.com/' + action,
	headers: {"Authorization": "BASIC " + window.btoa(key + ":xxx")}
});