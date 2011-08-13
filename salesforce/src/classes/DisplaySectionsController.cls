public with sharing class DisplaySectionsController {

  public List<Account> accounts {get;set;}	
  public String[] states {get;set;}
  
  public void load() {
  	
  	// for demo purposes limit the states  
  	accounts = [Select ID, Name, BillingState From Account 
  	  Where BillingState IN ('CA','NY','FL')];
  	
  	// dynamically create set of unique states from query
  	Set<String> stateSet = new Set<String>();
  	for (Account a : accounts)
  	  stateSet.add(a.BillingState);
  	  
  	// convert the set into a string array  
  	states = new String[stateSet.size()];
    Integer i = 0;
    for (String state : stateSet) { 
      states[i] = state;
      i++;
    }
  	
  }

}