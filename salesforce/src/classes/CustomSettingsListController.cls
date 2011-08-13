public with sharing class CustomSettingsListController {
	
	public String selectedIso {get;set;}
	
	public List<SelectOption> isoCodes {
		get {
			List<SelectOption> options = new List<SelectOption>();
			
			for (ISO_Country__c iso : ISO_Country__c.getAll().values())
				options.add(new SelectOption(iso.ISO_Code__c,iso.Name+' - '+iso.ISO_Code__c));
			return options; 
                         
		}
		set;
	}   

}