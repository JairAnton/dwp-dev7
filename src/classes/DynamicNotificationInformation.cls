/**
 * @author bbva.com developers
 * @date 2018
 *
 * @group global_hub
 *
 * @description List of message, list of users and object
 **/
public class DynamicNotificationInformation {
	public static List<NotificationInformation_wrapper> getDynamicNotificationInformation(List<String> recordId, String sObjectName, String messageId) {
		String language = UserInfo.getLanguage();
		Map<Id, List<Id>> mapRecipent = new Map<Id, List<Id>>();
		List <String> lstValid = new List<String>();
		List <NotificationInformation_wrapper> lstwraper = new List <NotificationInformation_wrapper>();
		List <Notification_Message_Engine__mdt> enginemdt = [Select Id, message_structure__c, additional_validation_class_desc__c, recipient_class_desc__c from Notification_Message_Engine__mdt where
		                                                     is_active__c = true AND language_code_id__c =: language AND object_api_name__c =: sObjectName AND
		                                                                                                                                      unique_id__c =: messageId];
		if(!enginemdt.isEmpty()) {
			DynamicNotificationMessageValidation method;
			if(enginemdt[0].additional_validation_class_desc__c != null) {
				Type dynamicvalidationclass = Type.forName(enginemdt[0].additional_validation_class_desc__c);

				// Check if there is a validation class and if so retrieve the records that pass the validation
				if(dynamicvalidationclass != null) {
					method = (DynamicNotificationMessageValidation)dynamicvalidationclass.newInstance();
					lstValid = method.getValidRecords(recordId, sObjectName);
				}

				// For the valid records, get the recipients and the message structure
				DynamicNotificationMessageRecipent method2;
				Type dynamicrecipentclass = Type.forName(enginemdt[0].recipient_class_desc__c);
				if(dynamicrecipentclass != null) {
					method2 = (DynamicNotificationMessageRecipent)dynamicrecipentclass.newInstance();
					mapRecipent = method2.getRecipients(lstValid, sObjectName);
				}
				List<String> lstrecordaux1 = new List<String>();
				for(String record : lstValid) {
					if(mapRecipent.containsKey(record)) {
						lstrecordaux1.add(record);
					}
				}
				if(!lstrecordaux1.isEmpty()) {
					Map<Id, String> mpMessage = DynamicNotificationMessageStructure.getMessageStructure(lstrecordaux1, sObjectName, enginemdt[0].message_structure__c);
					for(String recordaux1 : lstrecordaux1) {
						lstwraper.add(new DynamicNotificationInformation.NotificationInformation_wrapper(recordaux1, mapRecipent.get(recordaux1), mpMessage.get(recordaux1)));
					}
				}
			} else {
				DynamicNotificationMessageRecipent method2;
				Type dynamicrecipentclass = Type.forName(enginemdt[0].recipient_class_desc__c);
				if(dynamicrecipentclass != null) {
					method2 = (DynamicNotificationMessageRecipent)dynamicrecipentclass.newInstance();
					mapRecipent = method2.getRecipients(recordId, sObjectName);
				}
				List<String> lstrecordaux2 = new List<String>();
				for(String record : recordId) {
					if(mapRecipent.containsKey(record)) {
						lstrecordaux2.add(record);
					}
				}
				if(!lstrecordaux2.isEmpty()) {
					Map<Id, String> mpMessage = DynamicNotificationMessageStructure.getMessageStructure(lstrecordaux2, sObjectName, enginemdt[0].message_structure__c);
					for(String recordaux2 : lstrecordaux2) {
						lstwraper.add(new DynamicNotificationInformation.NotificationInformation_wrapper(recordaux2, mapRecipent.get(recordaux2), mpMessage.get(recordaux2)));
					}
				}
			}
		}

		return lstwraper;
	}
    
	public class NotificationInformation_wrapper {
		public String recordId;
		public List<Id> recipientList;
		public String message;

		public NotificationInformation_wrapper (String recordId, List<Id> recipientList, String message) {
			this.recordId = recordId;
			this.recipientList = recipientList;
			this.message = message;
		}
	}
}
