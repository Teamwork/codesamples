<cfset REQUEST.body = "<request><todo-item><notify type=""boolean"">true</notify><responsible-party-id>2</responsible-party-id><content>Pat Topper on the back because he is awesome with date</content><due-at type=""datetime"" nil=""true"">20100313</due-at></todo-item></request>">
<cfhttp url="https://[YOUR TEAMWORK SITE HERE]/todo_lists/5100/todo_items.json" timeout="5"
    method="POST" result="apiCall"
    throwonerror="No"
    username="#REQUEST.APIKey#" password="xxx">
    <cfhttpparam type="header" name="Accept" value="application/json" />
    <cfhttpparam type="header" name="Content-Type" value="application/json" />
    <cfhttpparam type="body" name="post" encoded="no" value="#REQUEST.body#" />
</cfhttp>
<cfif 1 IS 1><cfif FindNoCase( "error", apiCall.filecontent ) OR FindNoCase( "cfdump", apiCall.filecontent )><cfcontent reset="Yes"><cfoutput>#apiCall.filecontent#</cfoutput><cfabort></cfif></cfif>
<cfdump var="#apiCall#">