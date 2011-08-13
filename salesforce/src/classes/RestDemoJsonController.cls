public class RestDemoJsonController {
	
	public String geoAddress {get;set;}
	public String address {get;set;}
	public String city {get;set;}
	public String state {get;set;}
	public Boolean useGoogle {get;set;}
     
    // google api key 
    private String apiKey {get;set { apiKey = 'ABQIAAAAlI0DHB0p0WGX35GrKEAzQhTwZth5GdZI-P7ekoe_gyhfzl1yZhRAYdM-hb7aEWu30fGchcvGuwuUqg'; } } 
       
    // method called by the Visualforce page's submit button   
    public PageReference submit() {
    	
    	if (address.length() == 0) {
    		ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Address cannot be blank'));
    	}
    	if (city.length() == 0) {
    		ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'City cannot be blank'));
    	}
    	if (state.length() == 0) {
    		ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'State cannot be blank'));
    	}
    	
    	if (!ApexPages.hasMessages()) 
	    	geoAddress = getAddress(address,city,state);
    
    	return null; 
    }
    
    // call the geocoding service
	private String getAddress(String street, String city, String state) {
		
		String json;
		
		// hard-coded returned JSON response from Google
		if (useGoogle) {
			json = '{  "name": "1600 Amphitheatre Parkway, Mountain View, CA",  "Status": {    "code": 200,    "request": "geocode"  },  "Placemark": [ {    "id": "p1",    "address": "1600 Amphitheatre Pkwy, Mountain View, CA 94043, USA",    "AddressDetails": {   "Accuracy" : 8,   "Country" : {      "AdministrativeArea" : {         "AdministrativeAreaName" : "CA",         "SubAdministrativeArea" : {            "Locality" : {               "LocalityName" : "Mountain View",               "PostalCode" : {                  "PostalCodeNumber" : "94043"               },               "Thoroughfare" : {                  "ThoroughfareName" : "1600 Amphitheatre Pkwy"               }            },         '+
			'   "SubAdministrativeAreaName" : "Santa Clara"         }      },      "CountryName" : "USA",      "CountryNameCode" : "US"   }},    "ExtendedData": {      "LatLonBox": {        "north": 37.4251466,        "south": 37.4188514,        "east": -122.0811574,        "west": -122.0874526      }    },    "Point": {      "coordinates": [ -122.0843700, 37.4217590, 0 ]    }  } ]}	';
		
		// call the geocoding service live
		} else {
			
			HttpRequest req = new HttpRequest();
			Http http = new Http();
			// set the method
			req.setMethod('GET');
			// generate the url for the request
			String url = 'http://maps.google.com/maps/geo?q='+ EncodingUtil.urlEncode(street,'UTF-8')+',+'
				+ EncodingUtil.urlEncode(city,'UTF-8')+',+'
				+ EncodingUtil.urlEncode(state,'UTF-8')
				+'&output=json&sensor=false&key='+apiKey;
			// add the endpoint to the request
			req.setEndpoint(url);
			// create the response object
			HTTPResponse resp = http.send(req);
			// the geocoding service is returning a line feed so parse it out
			json = resp.getBody().replace('\n', '');
			
		}
		
		try {
			JSONObject j = new JSONObject( json );
			return toGeoResult(j).toDisplayString();
		} catch (JSONObject.JSONException e) {
			return 'Error parsing JSON response from Google: '+e;
		}
		
	}
	
	// utility method to convert the JSON object to the inner class
	private GeoResult toGeoResult(JSONObject resp) {

		GeoResult geo = new GeoResult();
		
		try {
		
			geo.address = resp.getValue('Placemark').values[0].obj.getValue('address').str;
			geo.keys = resp.keys();
			geo.name = resp.getString('name');
			geo.statusCode = resp.getValue('Status').obj.getValue('code').num;
			
			// set the coordinates - they may either be integers or doubles
			geo.coordinate1 = resp.getValue('Placemark').values[0].obj.getValue('Point').obj.getValue('coordinates').values[0].num != NULL ? resp.getValue('Placemark').values[0].obj.getValue('Point').obj.getValue('coordinates').values[0].num.format() : resp.getValue('Placemark').values[0].obj.getValue('Point').obj.getValue('coordinates').values[0].dnum.format();
			geo.coordinate2 = resp.getValue('Placemark').values[0].obj.getValue('Point').obj.getValue('coordinates').values[1].num != NULL ? resp.getValue('Placemark').values[0].obj.getValue('Point').obj.getValue('coordinates').values[1].num.format() : resp.getValue('Placemark').values[0].obj.getValue('Point').obj.getValue('coordinates').values[1].dnum.format();
			geo.coordinate3 = resp.getValue('Placemark').values[0].obj.getValue('Point').obj.getValue('coordinates').values[2].num != NULL ? resp.getValue('Placemark').values[0].obj.getValue('Point').obj.getValue('coordinates').values[2].num.format() : resp.getValue('Placemark').values[0].obj.getValue('Point').obj.getValue('coordinates').values[2].dnum.format();
			
		} catch (Exception e) {
			// #fail
		}
		
		return geo;		
	}
	
	// inner class
	private class GeoResult { 
		
		public Set<String> keys;
		public Integer statusCode;
		public String name;
		public String coordinate1;
		public String coordinate2;
		public String coordinate3;
		public String address;
		public String toDisplayString() {
			return address + ' ['
			+ coordinate1 + ', ' 
			+ coordinate2 + ', ' 
			+ coordinate3 + '] - Status: '
			+ statusCode;
		}
		
	}  
		
}