import flash.events.Event;
import flash.events.MouseEvent;
import flash.net.URLLoader;
import flash.net.URLRequest;
 
import mx.utils.Base64Encoder;
 
private function onBtnGetTasksClicked(event:Event):void {
    var request:URLRequest = new URLRequest();
    var loader:URLLoader = new URLLoader();
    var url:String = "";
    var headerRequests:Array = new Array(1);
    var credentials:String = "";
    var encoder:Base64Encoder = new Base64Encoder();
    var cAction:String = "/todo_lists/" + this.txtTaskListId.text + "/todo_items.json";
     
    request.method = "get";
     
    encoder.encode( this.txtAPIToken.text + ":" + "");
    credentials = encoder.toString();
    headerRequests[0] = new URLRequestHeader("Authorization","Basic " + credentials);
     
    request.requestHeaders = headerRequests;
    request.authenticate = false;
     
    request.url = "https://" + this.txtUrl.text + ".teamwork.com" + cAction;
     
    loader.addEventListener(Event.COMPLETE,onGetTasksAPICallComplete);
     
    loader.load(request);
}
 
private function onGetTasksAPICallComplete(event:Event):void {
    var data:String = event.target.data;
    this.txtResult.text = data;
}
