public with sharing class DocumentEmailController {

  public ID documentId {get;set;}
  public String email {get;set;}
  
	public List<SelectOption> documents {
		get {
			if (documents == null) {
				documents = new List<SelectOption>();
				documents.add(new SelectOption('01570000001NZDn','Cup of Coffee? - DOC'));
				documents.add(new SelectOption('01570000001NZDi','Workflow Cheatsheet -  PDF'));
			}
			return documents;
		}
		set;
	}
  
  public PageReference sendDoc() {

		Document doc = [select id, name, body, contenttype, developername, type 
			from Document where id = :documentId];
            
    Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
    attach.setContentType(doc.contentType);
    attach.setFileName(doc.developerName+'.'+doc.type);
    attach.setInline(false);
    attach.Body = doc.Body;

		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		mail.setUseSignature(false);
		mail.setToAddresses(new String[] { email });
		mail.setSubject('Document Email Demo');
		mail.setHtmlBody('Here is the email you requested: '+doc.name);
		mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attach }); 
		
		// Send the email
		Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
		
		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Email with Document sent to '+email));

		return null;

  }

}