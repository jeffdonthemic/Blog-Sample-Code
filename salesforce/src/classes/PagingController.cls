public with sharing class PagingController {
	
	List<CategoryWrapper> categories {get;set;} 
	
	// instantiate the StandardSetController from a query locator 
	public ApexPages.StandardSetController con {
		get {
			if(con == null) {
				con = new ApexPages.StandardSetController(Database.getQueryLocator([Select Id, Name FROM Cat3__c Order By Name limit 100]));
				// sets the number of records in each page set
				con.setPageSize(5);
			}
			return con;
		}
		set;
	}
	
	// returns a list of wrapper objects for the sObjects in the current page set
	public List<CategoryWrapper> getCategories() {
		categories = new List<CategoryWrapper>();
		for (Cat3__c category : (List<Cat3__c>)con.getRecords()) 
			categories.add(new CategoryWrapper(category));
		
		return categories;
	}
	
	// displays the selected items
 	public PageReference process() {
 		for (CategoryWrapper cw : categories) {
 			if (cw.checked)
 				ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,cw.cat.name));
 		}
 		return null;
 	}
	
	// indicates whether there are more records after the current page set.
	public Boolean hasNext {
		get {		
			return con.getHasNext();
		}
		set;
	}
	
	// indicates whether there are more records before the current page set.
	public Boolean hasPrevious {
		get {		
			return con.getHasPrevious();
		}
		set;
	}
	
	// returns the page number of the current page set
	public Integer pageNumber {
		get {		
			return con.getPageNumber();
		}
		set;
	}
	
	// returns the first page of records
 	public void first() {
 		con.first();
 	}
 	
 	// returns the last page of records
 	public void last() {
 		con.last();
 	}
 
 	// returns the previous page of records
 	public void previous() {
 		con.previous();
 	}
 	
 	// returns the next page of records
 	public void next() {
 		con.next();
 	}
 	
 	// returns the PageReference of the original page, if known, or the home page.
 	public void cancel() {
 		con.cancel();
 	}
 
}