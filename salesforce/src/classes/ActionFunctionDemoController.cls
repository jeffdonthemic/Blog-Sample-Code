public with sharing class ActionFunctionDemoController {
	
	public Cat3__c cat {get;set;}
	public String message {get;set;}
	
	public ActionFunctionDemoController() {
		cat = new Cat3__c(name='Some Value',Cat2__c='a0B70000002PuK2EAK');
		message = 'Try again!!'; // initial message.
	}
	
  public PageReference save() { 
    try {
    	insert cat;
    	message = 'Insert successful! -- ' + cat.id;
    } catch (Exception e) {
      ApexPages.addMessages(e);
      message = 'Whoops! An error occurred -- ' + e.getMessage();      
    }
    return null;
  }

}