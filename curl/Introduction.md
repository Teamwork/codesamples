*The following code sample was provided by Dan Lewis, a third party developer who uses our api! Do you have a code sample you would like to share? please email api@teamwork.com and we will be happy to post it! Thanks Dan for putting this together and allowing us to share it :)*

The following solution requires easily accessible macOs/Linux utilities (or Linux subsystem/cygwin for Windows) to programmatically retrieve data and format it for import into MS Excel. You can use this basic example as a pattern for similar one-off extracts, or as a building block the extract other types of data from Teamwork. You can also quickly prototype similar reports this way.

Use case:
Design principles are shared with the team through a series of notebooks stored in Teamwork, and input is gathered through comments to each of these notebooks. You need to collect and organize all comments by project, notebook name, and author, in the following format:

"Notebook Name", "Link to Comment", "Author Name", "Comment Body"

Required environment and utilities:

bash, curl, jq

One-liner to produce this as a csv formatted report (replace "apikey" with yours).