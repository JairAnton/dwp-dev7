global with sharing class Integration_GrantingTickets_Peru implements iaso.GBL_Integration_Authentication {
	global static iaso__GBL_Application_Log__c resetToken(iaso__GBL_Authentication_Service__mdt authenticationConfig) {
		Datetime initTime = Datetime.now();
		Http http = new Http();
		HttpRequest validationRequest = new HttpRequest();
		//validationRequest.setEndpoint(WebServiceUtils.getUrlFromCustomSettings(authenticationConfig.iaso__Custom_Setting__c));
		validationRequest.setEndpoint('callout:Auth_Peru');
		validationRequest.setMethod('POST');
		//validationRequest.setHeader(authenticationConfig.iaso__Header_Token__c, getAuth(authenticationConfig));
		validationRequest.setHeader('Content-Type', 'application/json');
		//validationRequest.setHeader('Accept', 'application/json');
        String validationRequestBody = '{"authentication": {"userID": "ZM13024","consumerID": "13000024","authenticationType": "04","authenticationData": [{"idAuthenticationData": "password","authenticationData": ["NGQyMDFkMWVlYzEz"]}]}}';
		validationRequest.setBody(validationRequestBody);
		HttpResponse response = http.send(validationRequest);
		// Parse the JSON response
		if(response.getStatusCode() != 200 && response.getStatusCode() != 202) {
			System.debug('The status code returned was not expected: ' +
			             response.getStatusCode() + ' ' + response.getStatus());
		} else {
			String jsonResponse = response.getBody();
			String tsec = response.getHeader(authenticationConfig.iaso__Cache_Key__c);
			Map < String, Object > m = (Map < String, Object > ) JSON.deserializeUntyped(jsonResponse);
			Map < String, Object > user = (Map < String, Object > ) m.get('user');
			//Map<String, Object> person = (Map<String, Object>) user.get('person');
			//String clientId = (String) person.get('id');
			Map < String, String > credentials = new Map < String, String >();
			// Add cache value to the partition
			credentials.put(authenticationConfig.iaso__Cache_Key__c, tsec);
			//credentials.put('clientId', clientId);
			Cache.Partition partition;
			if(!authenticationConfig.iaso__isOrgCache__c) {
				Cache.SessionPartition sessionPart = Cache.Session.getPartition(authenticationConfig.iaso__Cache_Partition__c);
				partition = sessionPart;
			} else {
				Cache.OrgPartition orgPart = Cache.Org.getPartition(authenticationConfig.iaso__Cache_Partition__c);
				partition = orgPart;
			}
			partition.put(authenticationConfig.iaso__Cache_Key__c, credentials);
		}

		return new iaso__GBL_Application_Log__c(iaso__Start_Time__c = initTime,
		                                        iaso__End_Time__c = Datetime.now(),
		                                        iaso__Message_LTA__c = 'REQUEST: ' + validationRequest.getEndpoint() + '\n' + validationRequest.getHeader('Authorization') + '\n' + validationRequest.getHeader('Content-Type') + '\n' + validationRequest.getBody() + '\n--\n--\n\nRESPONSE:\n' + response.getBody(),
		                                        Name = 'GrantingTicketsPeru',
		                                        iaso__Type__c = 'Integration',
		                                        iaso__User__c = UserInfo.getUserId());
	}

	global static HttpRequest applySecurity(HttpRequest request, iaso__GBL_Authentication_Service__mdt authenticationConfig) {
		// Check if the session is stored in the cache
		Cache.Partition partition;
		if(!authenticationConfig.iaso__isOrgCache__c) {
			Cache.SessionPartition sessionPart = Cache.Session.getPartition(authenticationConfig.iaso__Cache_Partition__c);
			partition = sessionPart;
		} else {
			Cache.OrgPartition orgPart = Cache.Org.getPartition(authenticationConfig.iaso__Cache_Partition__c);
			partition = orgPart;
		}
		// Retrieve cache value from the partition
		Map < String, String > credentials = (Map < String, String > ) partition.get(authenticationConfig.iaso__Cache_Key__c);
		// if credentials are not set in the cache, reset
		if(credentials != null && credentials.get(authenticationConfig.iaso__Cache_Key__c) != null) {
			//resetToken(authenticationConfig);
			//credentials = (Map <String, String>) sessionPart.get(authenticationConfig.Cache_Key__c);
			request.setHeader(authenticationConfig.iaso__Header_Token__c, credentials.get(authenticationConfig.iaso__Cache_Key__c));
		}
		return request;
	}

	global static Boolean isAuthenticated(iaso__GBL_Authentication_Service__mdt authenticationConfig) {
		// Check if the session is stored in the cache
		Cache.Partition partition;
		if(!authenticationConfig.iaso__isOrgCache__c) {
			Cache.SessionPartition sessionPart = Cache.Session.getPartition(authenticationConfig.iaso__Cache_Partition__c);
			partition = sessionPart;
		} else {
			Cache.OrgPartition orgPart = Cache.Org.getPartition(authenticationConfig.iaso__Cache_Partition__c);
			partition = orgPart;
		}
		// Retrieve cache value from the partition
		Map < String, String > credentials = (Map < String, String > ) partition.get(authenticationConfig.iaso__Cache_Key__c);
		// if credentials are not set in the cache, reset
		if(credentials != null && credentials.get(authenticationConfig.iaso__Cache_Key__c) != null) {
			return true;
		}
		return false;
	}

	private static String getAuth(iaso__GBL_Authentication_Service__mdt authenticationConfig) {
		Blob cryptoKey = EncodingUtil.base64Decode(authenticationConfig.iaso__CryptoKey__c);
		Blob encryptedPassword = EncodingUtil.base64Decode(authenticationConfig.iaso__Password__c);

		Blob decryptedData = Crypto.decryptWithManagedIV('AES256', cryptoKey, encryptedPassword);

		Blob headerValue = Blob.valueOf('ZM13024' + ':' + decryptedData.toString());
		String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
		return authorizationHeader;
	}
}
