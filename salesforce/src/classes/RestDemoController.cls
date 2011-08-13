public class RestDemoController {
	
	public String geoAddress {get;set;}
	public String address {get;set;}
	public String city {get;set;}
	public String state {get;set;}
     
    // set the Yahoo Application Id
    private String appId {get;set { appId = 'DaqEkjjV34FCuqDUvZN92rQ9WWVQz58c0WHWo2hRGBuM310.qXefuBVwvJQaf1nnMCxSbg--'; } } 
       
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
    	
    	if (!ApexPages.hasMessages()) {
	    	List<GeoResult> results = getMap(address,city,state);
	    	geoAddress = results[0].toDisplayString();
    	}
    
    	return null;
    }
       
    // call the REST service with the address info   
	public List<GeoResult> getMap(String street, String city, String state) {
		
		HttpRequest req = new HttpRequest();
		Http http = new Http();
		List<GeoResult> results = new List<GeoResult>();
		
		// set the request method
		req.setMethod('GET');
		
		// set the yahoo maps url with address
		String url = 'http://local.yahooapis.com/MapsService/V1/geocode?appid=' + appId
			+ '&street=' + EncodingUtil.urlEncode(street,'UTF-8')
			+ '&city=' + EncodingUtil.urlEncode(city,'UTF-8')
			+ '&state=' + EncodingUtil.urlEncode(state,'UTF-8');
		
		// add the endpoint to the request
		req.setEndpoint(url);
		
		// create the response object
		HTTPResponse resp = http.send(req);
		
		// create the xml doc that will contain the results of the REST operation
		XmlDom doc = new XmlDom(resp.getBody());
		
		// process the results
		XmlDom.Element[] elements = doc.getElementsByTagName('Result');
		if (elements != null) {
			for (XmlDom.Element element : elements) 
				results.add(toGeoResult(element));
		}
		
		return results;
	}
	
	// utility method to convert the xml element to the inner class
	private GeoResult toGeoResult(XmlDom.Element element) {
		
		GeoResult geo = new GeoResult();
		geo.latitude = element.getValue('Latitude');
		geo.longitude = element.getValue('Longitude');
		geo.address = element.getValue('Address');
		geo.city = element.getValue('City');
		geo.state = element.getValue('State');
		geo.zip = element.getValue('Zip');
		return geo;		
	}
	
	// inner class
	private class GeoResult { 
		
		public String latitude;
		public String longitude;
		public String address;
		public String city;
		public String state;
		public String zip;
		public String toDisplayString() {
			return address + ', ' 
			+ city + ', ' 
			+ state + ', ' 
			+ zip + ' ['
			+ latitude + ', ' 
			+ longitude + ']';
		}
		
	}  

}