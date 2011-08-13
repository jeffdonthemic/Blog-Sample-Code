public with sharing class RecordCallController {

     // add the instance for the variables being passed by id on the url
    private Contact contact {get;set;}
    public String recordingUrl {get;set;}
    public String caller {get;set;}
    public String callerName {get;set;}
   
     // initialize the controller
    public RecordCallController() {
    	
			recordingUrl = ApexPages.currentPage().getParameters().get('RecordingUrl');
			caller = ApexPages.currentPage().getParameters().get('Caller');
			  
			List<Contact> callers = [select name from contact where phone = '(941) 809-3455'];
			  
			System.debug('============== callers: '+callers);
			  
			if (callers.size() > 0) {
				callerName = callers.get(0).Name;
			} else {
				callerName = 'NOT_FOUND';
			}
		  
			//saveMessage();

    }  

}