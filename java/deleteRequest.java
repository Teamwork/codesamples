import java.io.IOException;
import java.io.InputStream;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
 
public class DeleteRequest {

/*Note: This code example requires Base64Coder file which is 
available below in the Dependencies section.*/

  public static void main(String[] args) {
         
    HttpURLConnection connection = null;
         
    String APIKey = "YOUR_API_KEY";
    String TeamworkURL = "https://YOUR_TEAMWORK_SITE_NAME.teamwork.com";
             
    String taskId = "TASK_ID";
         
    try {
        URL url = new URL( TeamworkURL + "/todo_items/" + taskId + ".json" );
        connection = (HttpURLConnection) url.openConnection();
        connection.setRequestMethod("DELETE");
             
        String userpassword = APIKey + ":" + "";
        String encodedAuthorization = Base64Coder.encodeString( userpassword );
        connection.setRequestProperty("Authorization", "Basic "+ encodedAuthorization);
             
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
