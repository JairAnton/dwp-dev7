/**
 * DynamicRedirectPage_ctr
 * <p /><p />
 * Modification log:<p />
 * -------------------------------------------------------------------
 * Developer                    Date                Description<p />
 * -------------------------------------------------------------------
 * Diego Carbajal    		04/06/2020          Original version.<p />
 *
 * @author Diego Carbajal
 */
public without sharing class DynamicRedirectPage_ctr {
    
    /**
	   @Description test Be_DynamicTablePresentationSettings_cls.getDefaultValue(),correct scenary
	 */
	Final static List<String> PROFILE_NAMES = new List<String> {'Migracion', System.Label.profAdministrator, 'System Administrator'};
    /**
	   @Description DynamicRedirectPage_ctr
	 */
    private DynamicRedirectPage_ctr() {}
	
	/**
	   @Description test Be_DynamicTablePresentationSettings_cls.getDefaultValue(),correct scenary
	 */
	private static Boolean isSuccess = true;

	/**
	   @Description test Be_DynamicTablePresentationSettings_cls.getDefaultValue(),correct scenary
	 */
	@AuraEnabled
	public static Map<String, Object> getRecordToRedirect(String allowedView, String jsonSObj) {
		Final Map<String, Object> mapResponse = new Map<String, Object> {'redirectTo' => ''};
		Final Boolean stayPage = getPermission(allowedView);
        Final Map<String, Object> mapJsonSObj = (Map<String, Object>)JSON.deserializeUntyped(jsonSObj);
        Final String recordId = (String)mapJsonSObj.get('recordId');
		mapResponse.put('stayPage', stayPage);
		mapResponse.put('isSuccess', isSuccess);
		if(!stayPage && String.isNotBlank((String)mapJsonSObj.get('fieldName'))) {
			try {
				Final String query = 'SELECT Id, ' + String.escapeSingleQuotes((String)mapJsonSObj.get('fieldName')) + ' FROM ' + 
                    String.escapeSingleQuotes((String)mapJsonSObj.get('sObjectType')) + ' WHERE Id=:recordId LIMIT 1';
				Final List<SObject> lstCurrentObj = Database.query(query);
				Final Integer lstCurrentObjSize = lstCurrentObj.size();
				if(lstCurrentObjSize > 0) {
					Final SObject obj = lstCurrentObj[0];
					mapResponse.put('redirectTo', obj.get((String)mapJsonSObj.get('fieldName')));
				} else {
					mapResponse.put('isSuccess', false);
				}
			} catch(Exception e) {
				System.debug('Exception in getRecordToRedirect => ' + e.getMessage());
				mapResponse.put('isSuccess', false);
			}
		}
		return mapResponse;
	}

	/**
	   @Description test Be_DynamicTablePresentationSettings_cls.getDefaultValue(),correct scenary
	 */
	private static Boolean getPermission(String allowedView) {
		Boolean stayPage = false;
		try {
			Final List<User> currentUser = [SELECT Id, Profile.Name, user_id__c FROM User WHERE Id =:UserInfo.getUserId() LIMIT 1];
			Final Map<String, Object> mapAllowed = (Map<String, Object>)JSON.deserializeUntyped(allowedView);
			//Si existen usuarios permitidos en la configuración
			if(mapAllowed.containsKey('users')) {
				Final String strAllowedUsers = (String) mapAllowed.get('users');
				Final List<String> lstAllowedUsers = strAllowedUsers.split(',');
				stayPage = lstAllowedUsers.contains(currentUser[0].user_id__c);
			}
			//Si existen perfiles permitidos en la configuración
			if(mapAllowed.containsKey('profiles')) {
				Final String strAllowedP = (String)mapAllowed.get('profiles');
				Final List<String> lstAllowedP = strAllowedP.split(',');
				stayPage = stayPage || lstAllowedP.contains(currentUser[0].Profile.Name);
			}
			//Validate Permission Administrator
			stayPage = stayPage || PROFILE_NAMES.contains(currentUser[0].Profile.Name);
		} catch(Exception e) {
			System.debug('Exception in getPermission => ' + e.getMessage());
			isSuccess = false;
		}
		return stayPage;
	}
}