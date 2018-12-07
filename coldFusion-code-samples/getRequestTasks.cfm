<cfset projectId = 111>
<cfhttp url="https://[YOUR TEAMWORK SITE HERE]/projects/#projectId#/tasks.json" timeout="5"
    method="PUT" result="apiCall"
    throwonerror="No"
    username="#REQUEST.APIKey#" password="xxx">
    <cfhttpparam type="header" name="Accept" value="application/json" />
    <cfhttpparam type="header" name="Content-Type" value="application/json" />
</cfhttp>
<cfif 1 IS 1><cfif FindNoCase( "error", apiCall.filecontent ) OR FindNoCase( "cfdump", apiCall.filecontent )><cfcontent reset="Yes"><cfoutput>#apiCall.filecontent#</cfoutput><cfabort></cfif></cfif>
<cfdump var="#apiCall#">