<cfset REQUEST.body = "<request>#messagejson#</request>">
<cfhttp url="https://[YOUR TEAMWORK SITE HERE]/posts/#newMessageId#.json" timeout="5"
    method="PUT" result="apiCall"
    throwonerror="No"
    username="#REQUEST.APIKey#" password="xxx">
    <cfhttpparam type="header" name="Accept" value="application/json" />
    <cfhttpparam type="header" name="Content-Type" value="application/json" />
    <cfhttpparam type="body" name="post" encoded="no" value="#REQUEST.body#" />
</cfhttp>
<!--- Display any errors --->
<cfif FindNoCase( "error", apiCall.filecontent )>
    <cfcontent reset="Yes">
    <cfoutput>#apiCall.filecontent#</cfoutput>
    <cfabort>
</cfif>