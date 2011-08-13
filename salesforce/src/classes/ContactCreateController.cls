public with sharing class ContactCreateController {

    // the contact record you are adding values to
    public Contact contact {
        get {
            if (contact == null)
                contact = new Contact();
            return contact;
        }
        set;
    }

    public ContactCreateController() {
        // blank constructor
    }
    
    // save button is clicked
    public PageReference save() {
    
        try {
            insert contact; // inserts the new record into the database
        } catch (DMLException e) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error creating new contact.'));
            return null;
        }
        
        // if successfully inserted new contact, then displays the thank you page.
        return Page.Contact_Create_Thankyou;
    }
    

}