public class OpportunitySearchController {
	
    //added an instance varaible for the standard controller
    private ApexPages.StandardController controller {get; set;}
    // the actual account
    private Account a;
	// the results from the search. do not init the results or a blank rows show up initially on page load
    public List<Opportunity> searchResults {get;set;}     
    
	// the text in the search box
    public string searchText {
    	get {
    		if (searchText == null) searchText = 'Acme'; // prefill the serach box for ease of use
    		return searchText;
    	} 
    	set;
	}      
    
    public OpportunitySearchController(ApexPages.StandardController controller) {
    
        //initialize the stanrdard controller
        this.controller = controller;
        this.a = (Account)controller.getRecord();
        
    }     
    
	// fired when the search button is clicked
	public PageReference search() {
		if (searchResults == null) {
			searchResults = new List<Opportunity>(); // init the list if it is null	
		} else {
			searchResults.clear(); // clear out the current results if they exist
		}
		// Note: you could have achieved the same results as above by just using:
		// searchResults = new List<CategoryWrapper>();
		
		// use some dynamic soql to find the related opportunities by name
		String qry = 'Select o.Id, o.Name, o.StageName, o.CloseDate, o.Amount from Opportunity o Where AccountId = \''+a.Id+'\' And o.Name LIKE \'%'+searchText+'%\' Order By o.Name'; 
		searchResults = Database.query(qry);
		return null;
	}	       	

}