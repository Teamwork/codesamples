import java.io.IOException;
import java.io.InputStream;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Date;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
 
public class PostRequest {
  
     /*Note: This code example requires Base64Coder file which is 
available below in the Dependencies section.*/

  public static void main(String[] args) {
         
    String APIKey = "YOUR_API_KEY";
    String TeamworkURL = "https://YOUR_TEAMWORK_SITE_NAME.teamwork.com";
    String tasklistID = "TASK_LIST_ID";
    String taskName = "This is an example task created via a POST request in Java.";
    String action = "/todo_lists/" + tasklistID + "/todo_items.json";
         
    DateFormat dateFormat = new SimpleDateFormat("yyyyMMdd");
    Date date = new Date();
    String dueDate = dateFormat.format(date);
         
    String json = "{\"todo-item\":{\"content\":\""
                +taskName+"\",\"due-date\":\""+dueDate+"\"}}";
         
    try {
        URL url = new URL( TeamworkURL + action );
        HttpURLConnection connection = (HttpURLConnection) url.openConnection();
        connection.setRequestMethod("POST");
        connection.setDoOutput(true);
        connection.setRequestProperty("Content-Type", "application/json;charset=UTF-8");
             
        String userpassword = APIKey + ":xxx";
        String encodedAuthorization = Base64Coder.encodeString( userpassword );
             
        connection.setRequestProperty("Authorization", "BASIC "
                    + encodedAuthorization);
 
        OutputStreamWriter osw = new OutputStreamWriter(connection.getOutputStream());
        osw.write(json);
        osw.flush();
        osw.close();
 
        InputStream _is;
        if (connection.getResponseCode() != 201) {
        /* error  */
        errorStream = connection.getErrorStream();
        System.out.println( streamToString(errorStream) );
        }
 
        InputStream responseStream = connection.getInputStream();
        System.out.println( streamToString( responseStream) );
    } catch(Exception e) {
        System.out.println( "Error Received:" + e.getMessage() );
    }
  }
     
  public static String streamToString(InputStream in) throws IOException {
    StringBuilder out = new StringBuilder();
    BufferedReader br = new BufferedReader(new InputStreamReader(in));
    for(String line = br.readLine(); line != null; line = br.readLine()) 
    out.append(line);
    br.close();
    return out.toString();
  }
}