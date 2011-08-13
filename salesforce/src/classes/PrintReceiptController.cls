public class PrintReceiptController {
	
	public String img {get;set;}
	
    //added an instance varaible for the standard controller
    private ApexPages.StandardController controller {get; set;}
      
    // initialize the controller
    public PrintReceiptController(ApexPages.StandardController controller) {
 
        //initialize the stanrdard controller
        this.controller = controller;
       
    }   
	
	public PageReference init() {
		
		img = 'https://na5.salesforce.com/servlet/servlet.FileDownload?file=00P70000004bDpy';
		System.debug('================== img: '+img);
		return null;
	}

}