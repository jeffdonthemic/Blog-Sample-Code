public class JsonTestController {
	
	public String val {get;set;}

	public JsonTestController() {
		
		JSONObject jsonObject;
		HttpRequest req = new HttpRequest();
		Http http = new Http();
		
		req.setMethod('GET');
		
		String url = 'http://maps.google.com/maps/geo?q=1600+Amphitheatre+Parkway,+Mountain+View,+CA&output=json&oe=utf8&sensor=false&key=ABQIAAAAlI0DHB0p0WGX35GrKEAzQhTwZth5GdZI-P7ekoe_gyhfzl1yZhRAYdM-hb7aEWu30fGchcvGuwuUqg';
		//String url = 'http://search.yahooapis.com/ImageSearchService/V1/imageSearch?appid=YahooDemo&query=jeffdouglas&output=json';

		req.setEndpoint(url);
		HTTPResponse resp = http.send(req);
		
		System.debug('===================== body: '+resp.getBody());
		
		
		//JSONObject j = new JSONObject( resp.getBody() );
		//System.debug('============================== keys: '+j.keys());
		
		//val = j.getString('ResultSet');
		
		val = 'Hello World!';
		
		/**
		List<String> keys = new List<String>();
		keys.addAll(j.keys());
		
		for (integer i=0;i<keys.size();i++) {
			val = keys.get(i) + ' - ';
		}
		**/
		
		
	}

}