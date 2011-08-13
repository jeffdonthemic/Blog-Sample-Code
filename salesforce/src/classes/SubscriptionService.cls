/**************************************************
* Created by Jeff Douglas - Blue Method, Inc.
* jeff@bluemethod.com / 941-227-4843
**************************************************/

global class SubscriptionService {
	
	// subscriber object that is returned
	global class Subscriber {
		
		webservice String id;
		webservice String firstName;
		webservice String lastName;
		webservice String company;
		webservice String country;
		webservice String email;
		webservice String phone;
		webservice Boolean newsletter;
		webservice Boolean slides;
		webservice Boolean whitepapers;
		webservice Boolean events;
		webservice Boolean specialOffers;
		webservice Boolean weeklyDigest; 
		webservice Date subsChanged;
		webservice String sObjectType;
		webservice Boolean error;
		webservice String errorMessage; 
		
	}
	
	// 'private' method that returns a casted Contact to a Subscriber
	webService static Subscriber contactToSubscriber(Contact contact) {
		
		Subscriber s = new Subscriber();
		s.id = contact.Id;
		s.firstName = contact.FirstName;
		s.lastName = contact.LastName;
		s.company = contact.Account.Name;
		s.country = contact.MailingCountry;
		s.email = contact.Email;
		s.phone = contact.Phone;
		s.subsChanged = contact.Subscriptions_changed__c;
		
		// flip newsletter
		if (contact.Newsletter_Opt_out__c) {
			s.newsletter = false;
		} else {
			s.newsletter = true;
		}
		// flip whitepapers
		if (contact.Articles_Whitepapers_Opt_out__c) {
			s.whitepapers = false;
		} else {
			s.whitepapers = true;
		}
		// flip special offers
		if (contact.Offers_opt_out__c) {
			s.specialOffers = false;
		} else {
			s.specialOffers = true;
		}
		s.events = contact.Upcoming_event_alert__c;
		s.slides = contact.SlidesPresents__c;
		s.weeklyDigest = contact.Weekly_digest_alert__c;
						
		s.sObjectType = 'Contact'; 
		s.error = false;
		s.errorMessage = ''; 
		
		return s;
		
	}
	
	// 'private' method that returns a casted Lead to a Subscriber
	webService static Subscriber leadToSubscriber(Lead lead) {

		Subscriber s = new Subscriber();
		s.id = lead.Id;
		s.firstName = lead.FirstName;
		s.lastName = lead.LastName;
		s.company = lead.Company;
		s.country = lead.Country;
		s.email = lead.Email;
		s.phone = lead.Phone;
		s.subsChanged = lead.Subscriptions_changed__c;

		// flip newsletter
		if (lead.Newsletter_Opt_out__c) {
			s.newsletter = false;
		} else {
			s.newsletter = true;
		}
		// flip whitepapers
		if (lead.Articles_Whitepapers_Opt_out__c) {
			s.whitepapers = false;
		} else {
			s.whitepapers = true;
		}
		// flip special offers
		if (lead.Offers_opt_out__c) {
			s.specialOffers = false;
		} else {
			s.specialOffers = true;
		}
		s.events = lead.Upcoming_event_alert__c;
		s.slides = lead.SlidesPresents__c;
		s.weeklyDigest = lead.Weekly_digest_alert__c;
	
		s.sObjectType = 'Lead';
		s.error = false;
		s.errorMessage = '';
		
		return s;
	}

	// returns a Subscriber (Lead or Contact) for a specified Id
	webService static Subscriber fetchById(String Id) {
		
		// init a new subscriber to return with initial error that no subscriber was found
		Subscriber s = new Subscriber();
		s.id = Id;
		s.error = true;
		s.errorMessage = 'Subscriber Not Found by Id';	
		
		try {
		
			// query for the contact
			List<Contact> contacts = [Select Id, FirstName, LastName, Account.Name, MailingCountry, Email, Phone, Subscriptions_changed__c, Newsletter_Opt_out__c, SlidesPresents__c, Articles_Whitepapers_Opt_out__c, Upcoming_event_alert__c, Offers_opt_out__c, Weekly_digest_alert__c from Contact Where Id = :Id];
						
			// if we found a Contact, return it
			if (contacts.size() > 0) {
				s = contactToSubscriber(contacts[0]);
			
			// try finding it in the leads
			} else { 
				
				List<Lead> leads = [Select Id, FirstName, LastName, Company, Country, Email, Phone, Subscriptions_changed__c, Newsletter_Opt_out__c, SlidesPresents__c, Articles_Whitepapers_Opt_out__c, Upcoming_event_alert__c, Offers_opt_out__c, Weekly_digest_alert__c from Lead Where Id = :Id];
				
				if (leads.size() > 0)
					s = leadToSubscriber(leads[0]);
				
			}
		
		// if an exception was thrown, we did not find the record
		} catch (Exception e) {
			s.error = true;
			s.errorMessage = e.getMessage();
		}
		
		return s;
		
	}
	
	// returns a list of subscribers (Contacts or Leads) based upon an email address
	webService static List<Subscriber> fetchByEmail(String email) {
		
		// init a new subscriber to return with initial error that no subscriber was found
		Subscriber s = new Subscriber();
		s.Email = email;
		s.error = true;
		s.errorMessage = 'Subscriber Not Found by Email';	
		// add an empty subscriber to return
		List<Subscriber> subscribers = new List<Subscriber>();
		subscribers.add(s);
		
		try {
		
			// query for the contact
			List<Contact> contacts = [Select Id, FirstName, LastName, Account.Name, MailingCountry, Email, Phone, Subscriptions_changed__c, Newsletter_Opt_out__c, SlidesPresents__c, Articles_Whitepapers_Opt_out__c, Upcoming_event_alert__c, Offers_opt_out__c, Weekly_digest_alert__c from Contact Where Email = :email];
						
			// if we found a Contact, return it
			if (contacts.size() > 0) {
				subscribers.clear();
				for (Integer i = 0;i<contacts.size();i++)
					subscribers.add(contactToSubscriber(contacts[i]));
			
			// try finding it in the leads
			} else { 
				
				List<Lead> leads = [Select Id, FirstName, LastName, Company, Country, Email, Phone, Subscriptions_changed__c, Newsletter_Opt_out__c, SlidesPresents__c, Articles_Whitepapers_Opt_out__c, Upcoming_event_alert__c, Offers_opt_out__c, Weekly_digest_alert__c from Lead Where IsConverted = false And Email = :email];
				
				if (leads.size() > 0) {
					subscribers.clear();
					for (Integer i = 0;i<leads.size();i++)
						subscribers.add(leadToSubscriber(leads[i]));
				}
				
			}
		
		// if an exception was thrown, we did not find the record
		} catch (Exception e) {
			subscribers[0].error = true;
			subscribers[0].errorMessage = e.getMessage();
		}
		
		return subscribers;
	}
	
	// matches a contact
	public static testMethod void testFetchContactById() {
		
		Account a = new Account(
			Name = 'Test Account 1',
			BillingCountry = 'United Kingdom',
			Phone = '+32 (0) 2 679 12 11'
		);
		insert a;
		
		Contact c = new Contact();
		c.FirstName = 'Test';
		c.LastName = 'Contact 1';
		c.AccountId = a.Id;
		c.MailingCountry = 'United Kingdom';
		c.Email = 'no@email1.com';
		c.Phone = '+32 (0) 2 679 12 11';
		c.Subscriptions_changed__c = Date.valueof('2009-02-02');
		c.Newsletter_Opt_out__c  = true; 
		c.SlidesPresents__c = true;
		c.Articles_Whitepapers_Opt_out__c = true;
		c.Upcoming_event_alert__c = true;
		c.Offers_opt_out__c = true;
		c.Weekly_digest_alert__c = true;
		insert c; 
		
		Subscriber s = fetchById(c.id);
		
		System.assertEquals(s.id,c.id);
		System.assertEquals(s.firstName,c.FirstName);
		System.assertEquals(s.lastName,c.LastName);
		System.assertEquals(s.company,a.Name);
		System.assertEquals(s.country,c.MailingCountry);
		System.assertEquals(s.email,c.Email);
		System.assertEquals(s.phone,c.Phone);
		System.assertEquals(s.subsChanged, c.Subscriptions_changed__c);
		System.assertEquals(s.newsletter,false);
		System.assertEquals(s.slides,true);
		System.assertEquals(s.whitepapers,false);
		System.assertEquals(s.events,true);
		System.assertEquals(s.specialOffers,false);
		System.assertEquals(s.weeklyDigest,true);
		System.assertEquals(s.sObjectType,'Contact');
		System.assertEquals(s.error,false);
		System.assertEquals(s.errorMessage,'');
		
		System.debug('a: '+a.id);
		System.debug('c: '+c.id);
		System.debug('Subscriber: '+s);
		
	}
	
	// matches a lead
	public static testMethod void testFetchLeadById() {
		
		Lead lead = new Lead();
		lead.FirstName = 'Test';
		lead.LastName = 'Contact 1';
		lead.Company = 'Test Lead Company';
		lead.Country = 'United Kingdom';
		lead.Email = 'no@email1.com';
		lead.Phone = '+32 (0) 2 679 12 11';
		lead.Subscriptions_changed__c = Date.valueof('2009-02-02');
		lead.Newsletter_Opt_out__c  = true; 
		lead.SlidesPresents__c = true;
		lead.Articles_Whitepapers_Opt_out__c = true;
		lead.Upcoming_event_alert__c = true;
		lead.Offers_opt_out__c = true;
		lead.Weekly_digest_alert__c = true;
		insert lead; 
		
		Subscriber s = fetchById(lead.id);
		
		System.assertEquals(s.id,lead.id);
		System.assertEquals(s.firstName,lead.FirstName);
		System.assertEquals(s.lastName,lead.LastName);
		System.assertEquals(s.company,lead.Company);
		System.assertEquals(s.country,lead.Country);
		System.assertEquals(s.email,lead.Email);
		System.assertEquals(s.phone,lead.Phone);
		System.assertEquals(s.subsChanged, lead.Subscriptions_changed__c);
		System.assertEquals(s.newsletter,false);
		System.assertEquals(s.slides,true);
		System.assertEquals(s.whitepapers,false);
		System.assertEquals(s.events,true);
		System.assertEquals(s.specialOffers,false);
		System.assertEquals(s.weeklyDigest,true);
		System.assertEquals(s.sObjectType,'Lead');
		System.assertEquals(s.error,false);
		System.assertEquals(s.errorMessage,'');
		
		System.debug('Subscriber: '+s);
		
	}
	
	// does not match a contact or lead
	public static testMethod void testFetchByIdNoMatch() {
			
		Subscriber s = fetchById('0037000000TXX1X');
		
		System.assertEquals(s.id,'0037000000TXX1X');
		System.assertEquals(s.error,true);
		System.assertEquals(s.errorMessage,'Subscriber Not Found by Id');
			
		System.debug('Subscriber: '+s);
		
	}
	
	// matches a contact
	public static testMethod void testFetchContactByEmail() {
		
		Account a = new Account(
			Name = 'Test Account 1',
			BillingCountry = 'United Kingdom',
			Phone = '+32 (0) 2 679 12 11'
		);
		insert a;
		
		Contact c = new Contact();
		c.FirstName = 'Test';
		c.LastName = 'Contact 1';
		c.AccountId = a.Id;
		c.MailingCountry = 'United Kingdom';
		c.Email = 'no@email11111.com';
		c.Phone = '+32 (0) 2 679 12 11';
		c.Subscriptions_changed__c = Date.valueof('2009-02-02');
		c.Newsletter_Opt_out__c  = true; 
		c.SlidesPresents__c = true;
		c.Articles_Whitepapers_Opt_out__c = true;
		c.Upcoming_event_alert__c = true;
		c.Offers_opt_out__c = true;
		c.Weekly_digest_alert__c = true;
		insert c; 
		
		Contact c1 = new Contact();
		c1.FirstName = 'Test';
		c1.LastName = 'Contact 1';
		c1.AccountId = a.Id;
		c1.MailingCountry = 'United Kingdom';
		c1.Email = 'no@email11111.com';
		c1.Phone = '+32 (0) 2 679 12 11';
		c1.Subscriptions_changed__c = Date.valueof('2009-02-02');
		c1.Newsletter_Opt_out__c  = true; 
		c1.SlidesPresents__c = true;
		c1.Articles_Whitepapers_Opt_out__c = true;
		c1.Upcoming_event_alert__c = true;
		c1.Offers_opt_out__c = true;
		c1.Weekly_digest_alert__c = true;
		insert c1; 
		
		List<Subscriber> subscribers = fetchByEmail('no@email11111.com');
		
		System.assertEquals(subscribers[0].id,c.id);
		System.assertEquals(subscribers[0].firstName,c.FirstName);
		System.assertEquals(subscribers[0].lastName,c.LastName);
		System.assertEquals(subscribers[0].company,a.Name);
		System.assertEquals(subscribers[0].country,c.MailingCountry);
		System.assertEquals(subscribers[0].email,c.Email);
		System.assertEquals(subscribers[0].phone,c.Phone);
		System.assertEquals(subscribers[0].subsChanged,c.Subscriptions_changed__c);
		System.assertEquals(subscribers[0].newsletter,false);
		System.assertEquals(subscribers[0].slides,true);
		System.assertEquals(subscribers[0].whitepapers,false);
		System.assertEquals(subscribers[0].events,true);
		System.assertEquals(subscribers[0].specialOffers,false);
		System.assertEquals(subscribers[0].weeklyDigest,true);
		System.assertEquals(subscribers[0].sObjectType,'Contact');
		System.assertEquals(subscribers[0].error,false);
		System.assertEquals(subscribers[0].errorMessage,'');
		
		System.assertEquals(subscribers[1].id,c1.id);
		System.assertEquals(subscribers[1].firstName,c1.FirstName);
		System.assertEquals(subscribers[1].lastName,c1.LastName);
		System.assertEquals(subscribers[1].company,a.Name);
		System.assertEquals(subscribers[1].country,c1.MailingCountry);
		System.assertEquals(subscribers[1].email,c1.Email);
		System.assertEquals(subscribers[1].phone,c1.Phone);
		System.assertEquals(subscribers[1].subsChanged,c1.Subscriptions_changed__c);		
		System.assertEquals(subscribers[1].newsletter,false);
		System.assertEquals(subscribers[1].slides,true);
		System.assertEquals(subscribers[1].whitepapers,false);
		System.assertEquals(subscribers[1].events,true);
		System.assertEquals(subscribers[1].specialOffers,false);
		System.assertEquals(subscribers[1].weeklyDigest,true);
		System.assertEquals(subscribers[1].sObjectType,'Contact');
		System.assertEquals(subscribers[1].error,false);
		System.assertEquals(subscribers[1].errorMessage,'');
		
		//System.debug('Subscribers: '+subscribers);
		
	}
	
	// matches a lead
	public static testMethod void testFetchLeadByEmail() {
		
		Lead lead = new Lead();
		lead.FirstName = 'Test';
		lead.LastName = 'Contact 1';
		lead.Company = 'Test Lead Company';
		lead.Country = 'United Kingdom';
		lead.Email = 'no@email111111.com';
		lead.Phone = '+32 (0) 2 679 12 11';
		lead.Subscriptions_changed__c = Date.valueof('2009-02-02');
		lead.Newsletter_Opt_out__c  = true; 
		lead.SlidesPresents__c = true;
		lead.Articles_Whitepapers_Opt_out__c = true;
		lead.Upcoming_event_alert__c = true;
		lead.Offers_opt_out__c = true;
		lead.Weekly_digest_alert__c = true;
		insert lead; 
		
		Lead lead1 = new Lead();
		lead1.FirstName = 'Test';
		lead1.LastName = 'Contact 1';
		lead1.Company = 'Test Lead Company';
		lead1.Country = 'United Kingdom';
		lead1.Email = 'no@email111111.com';
		lead1.Phone = '+32 (0) 2 679 12 11';
		lead1.Subscriptions_changed__c = Date.valueof('2009-02-02');
		lead1.Newsletter_Opt_out__c  = true; 
		lead1.SlidesPresents__c = true;
		lead1.Articles_Whitepapers_Opt_out__c = true;
		lead1.Upcoming_event_alert__c = true;
		lead1.Offers_opt_out__c = true;
		lead1.Weekly_digest_alert__c = true;
		insert lead1; 
		
		List<Subscriber> subscribers = fetchByEmail('no@email111111.com');
		
		System.assertEquals(subscribers[0].id,lead.id);
		System.assertEquals(subscribers[0].firstName,lead.FirstName);
		System.assertEquals(subscribers[0].lastName,lead.LastName);
		System.assertEquals(subscribers[0].company,lead.Company);
		System.assertEquals(subscribers[0].country,lead.Country);
		System.assertEquals(subscribers[0].email,lead.Email);
		System.assertEquals(subscribers[0].phone,lead.Phone);
		System.assertEquals(subscribers[0].subsChanged,lead.Subscriptions_changed__c);
		System.assertEquals(subscribers[0].newsletter,false);
		System.assertEquals(subscribers[0].slides,true);
		System.assertEquals(subscribers[0].whitepapers,false);
		System.assertEquals(subscribers[0].events,true);
		System.assertEquals(subscribers[0].specialOffers,false);
		System.assertEquals(subscribers[0].weeklyDigest,true);
		System.assertEquals(subscribers[0].sObjectType,'Lead');
		System.assertEquals(subscribers[0].error,false);
		System.assertEquals(subscribers[0].errorMessage,'');
		
		System.assertEquals(subscribers[1].id,lead1.id);
		System.assertEquals(subscribers[1].firstName,lead1.FirstName);
		System.assertEquals(subscribers[1].lastName,lead1.LastName);
		System.assertEquals(subscribers[1].company,lead1.Company);
		System.assertEquals(subscribers[1].country,lead1.Country);
		System.assertEquals(subscribers[1].email,lead1.Email);
		System.assertEquals(subscribers[1].phone,lead1.Phone);
		System.assertEquals(subscribers[1].subsChanged,lead1.Subscriptions_changed__c);
		System.assertEquals(subscribers[1].newsletter,false);
		System.assertEquals(subscribers[1].slides,true);
		System.assertEquals(subscribers[1].whitepapers,false);
		System.assertEquals(subscribers[1].events,true);
		System.assertEquals(subscribers[1].specialOffers,false);
		System.assertEquals(subscribers[1].weeklyDigest,true);
		System.assertEquals(subscribers[1].sObjectType,'Lead');
		System.assertEquals(subscribers[1].error,false);
		System.assertEquals(subscribers[1].errorMessage,'');
		
		System.debug('Subscriber: '+subscribers);
		
	}	

}