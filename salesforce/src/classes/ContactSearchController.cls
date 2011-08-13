public with sharing class ContactSearchController {
	
	// the soql without the order and limit
	private String soql {get;set;}
	// the collection of contacts to display
	public List<Contact> contacts {get;set;}
	
	// the current sort direction. defaults to asc
	public String sortDir {
  	get  { if (sortDir == null) {	sortDir = 'asc'; } return sortDir;	}
  	set;
  }
  
  // the current field to sort by. defaults to last name
	public String sortField {
  	get  { if (sortField == null) {sortField = 'lastName'; } return sortField;	}
  	set;
  }
  
  // format the soql for display on the visualforce page
	public String debugSoql {
	  get { return soql + ' order by ' + sortField + ' ' + sortDir + ' limit 20'; }
	  set;
	}

	// init the controller and display some sample data when the page loads
  public ContactSearchController() {
  	soql = 'select firstname, lastname, account.name, interested_technologies__c from contact where account.name != null';
  	runQuery();
  }
  
  // toggles the sorting of query from asc<-->desc
	public void toggleSort() {
		// simply toggle the direction
		sortDir = sortDir.equals('asc') ? 'desc' : 'asc';
		// run the query again
		runQuery();
  }
  
  // runs the actual query
	public void runQuery() {
				
		try {
			contacts = Database.query(soql + ' order by ' + sortField + ' ' + sortDir + ' limit 20');
		} catch (Exception e) {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Ooops!'));
		}

  }
	
	// runs the search with parameters passed via Javascript
	public PageReference runSearch() {
    
    String firstName = Apexpages.currentPage().getParameters().get('firstname');
    String lastName = Apexpages.currentPage().getParameters().get('lastname');
    String accountName = Apexpages.currentPage().getParameters().get('accountName');
		String technology = Apexpages.currentPage().getParameters().get('technology');
		
		soql = 'select firstname, lastname, account.name, interested_technologies__c from contact where account.name != null';
		if (!firstName.equals(''))
			soql += ' and firstname LIKE \''+String.escapeSingleQuotes(firstName)+'%\'';
		if (!lastName.equals(''))
			soql += ' and lastname LIKE \''+String.escapeSingleQuotes(lastName)+'%\'';
		if (!accountName.equals(''))
			soql += ' and account.name LIKE \''+String.escapeSingleQuotes(accountName)+'%\'';	
		if (!technology.equals(''))
			soql += ' and interested_technologies__c includes (\''+technology+'\')';

		// run the query again
		runQuery();

		return null;
	}
  
  // use apex describe to build the picklist values
	public List<String> technologies {
	  get {
	  	if (technologies == null) {
	  			  	
		  	technologies = new List<String>();
				Schema.DescribeFieldResult field = Contact.interested_technologies__c.getDescribe();
		        
				for (Schema.PicklistEntry f : field.getPicklistValues())
					technologies.add(f.getLabel());
					
	  	}
	    return technologies;          
	  }
	  set;
	}

}