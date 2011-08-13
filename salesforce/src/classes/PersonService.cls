global class PersonService {
	
	global class Person {
		
		webservice String id;
		webservice String firstName;
		webservice String lastName;
		webservice String company;
		webservice String email;
		webservice String phone;
		webservice String sObjectType;
		
	}

	webService static List<Person> searchByEmail(String email) {
		
		// list of Person objects to return
		List<Person> people = new List<Person>();
	
		// issue the sosl search
		List<List<SObject>> searchResults = [FIND :email IN EMAIL FIELDS RETURNING 
			Contact (Id, Account.Name, Email, Phone, FirstName, LastName), 
			Lead (Id, Company, FirstName, LastName, Email, Phone)];
		
		// cast the results by sObjec type
		List<Contact> contacts = ((List<Contact>)searchResults[0]);
		List<Lead> leads = ((List<Lead>)searchResults[1]);
		
		// a each contact found as a Person
		for (Integer i=0;i<contacts.size();i++) {
			Person p = new Person();
			p.id = contacts[i].Id;
			p.firstName = contacts[i].FirstName;
			p.lastName = contacts[i].LastName;
			p.company = contacts[i].Account.Name;
			p.email = contacts[i].Email;
			p.phone = contacts[i].Phone;
			p.sObjectType = 'Contact';
			people.add(p);
		}
		
		// a each lead found as a Person
		for (Integer i=0;i<leads.size();i++) {
			Person p = new Person();
			p.id = leads[i].Id;
			p.firstName = leads[i].FirstName;
			p.lastName = leads[i].LastName;
			p.company = leads[i].Company;
			p.email = leads[i].Email;
			p.phone = leads[i].Phone;
			p.sObjectType = 'Lead';
			people.add(p);
		}
		
		System.debug('Returning people: '+people);
		
		return people;

	}
}