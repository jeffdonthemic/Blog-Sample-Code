public class MultiSelectController {
 
    // reference for the standard controller
    private ApexPages.StandardController controller {get; set;}
 
    // the record that is being edited
    private Opportunity opp;
 
    // the values of the selected items
    public string selectedLevel1 {get; set;}
    public string selectedLevel2 {get; set;}
    public string selectedLevel3 {get; set;}
 
    public List<selectOption> level1Items {
        get {
            List<selectOption> options = new List<selectOption>();
 
                options.add(new SelectOption('','-- Choose a Category --'));
                for (Cat1__c cat : [select Id, Name from Cat1__c Order By Name])
                    options.add(new SelectOption(cat.Id,cat.Name));
 
            return options;           
        }
        set; 
    }
 
    public List<selectOption> level2Items {
        get {
            List<selectOption> options = new List<selectOption>();
 
            if (selectedLevel1 != NULL) {
                options.add(new SelectOption('','-- Choose a Category --'));
                for (Cat2__c cat : [select Id, Name from Cat2__c Where Cat1__c = :selectedLevel1 Order By Name])
                    options.add(new SelectOption(cat.Id,cat.Name));
            }
 
            return options;           
        }
        set;
    }   
 
    public List<selectOption> level3Items {
        get {
            List<selectOption> options = new List<selectOption>();
 
            if (selectedLevel2 != NULL) {
                options.add(new SelectOption('','-- Choose a Category --'));
                for (Cat3__c cat : [select Id, Name from Cat3__c Where Cat2__c = :selectedLevel2 Order By Name])
                    options.add(new SelectOption(cat.Id,cat.Name));
            }
 
            return options;           
        }
        set;
    }       
 
    public MultiSelectController(ApexPages.StandardController controller) {
 
        //initialize the stanrdard controller
        this.controller = controller;
        // load the record
        this.opp = (Opportunity)controller.getRecord();
 
        // preselect the current values for the record
        selectedLevel1 = opp.Cat1__c; 
        selectedLevel2 = opp.Cat2__c;
        selectedLevel3 = opp.Cat3__c; 
 
    }          
 
    public PageReference save() {
 
        // set the selected values to the record before saving
        opp.Cat1__c = selectedLevel1;
        opp.Cat2__c = selectedLevel2;
        opp.Cat3__c = selectedLevel3;
 
        try {
            upsert(opp);
        } catch(System.DMLException e) {
            ApexPages.addMessages(e);
            return null;
        }
        return (new ApexPages.StandardController(opp)).view();
    }        
 
}