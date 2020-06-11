/**
 * @author bbva.com developers
 * @date 2018
 *
 * @group global_hub
 *
 * @description structure of message
 **/
public class DynamicNotificationMessageStructure {
	public static Map<Id, String> getMessageStructure(List<String> lstrecord, String sObjectName, String message) {
		Map <Id, String> mpMessage = new Map<Id, String>();
		String userInfo = UserInfo.getName();
		Datetime myDT = Datetime.now();
		String dates = myDT.format('dd-MM-yyyy HH:mm');
		String query = '';

		if(message.contains('#UserInfo#')) {message = message.replace('#UserInfo#', userInfo);}
		if(message.contains('#CurrentDateTime#')) {message = message.replace('#CurrentDateTime#', dates);}
		if(message.contains('#SalesforceBaseUrl#')) {message = message.replace('#SalesforceBaseUrl#', URL.getSalesforceBaseUrl().toExternalForm());}

		Pattern p = Pattern.compile('(#)(.)*?\\1');
		Matcher m = p.matcher(message);
		if(m.find()) {
			do{
				//This String contains the field or the object if it's a relationship with his field (ex: Account.Name)
				String objOrField = m.group().substring(1, m.group().length() - 1);
				if(!query.contains(objOrField)) {
					query += objOrField + ',';
				}
			} while(m.find());
		}
		query = query.removeEnd(',');
		List <sObject> lstsobj = Database.query('SELECT ' + query + ' FROM ' + sObjectName + ' Where Id =: lstrecord');
		if(!lstsobj.isEmpty()) {
			for(sObject sobj:lstsobj) {
				Pattern p1 = Pattern.compile('(#)(.)*?\\1');
				Matcher m1 = p1.matcher(message);
				if(m1.find()) {
					do{
						//This String contains the field or the object if it's a relationship with his field (ex: Account.Name)
						String objOrField1 = m1.group().substring(1, m1.group().length() - 1);
						if(objOrField1.contains('.')) {
							List<String> relations = objOrField1.split('\\.');
							if(sobj.getSobject(relations[0]) != null) {
								message = message.replace(m1.group(), (String)sobj.getSobject(relations[0]).get(relations[1]));
							}
						} else {
							sobj.get(objOrField1);
							message = message.replace(m1.group(), (String)sobj.get(objOrField1));
						}
					} while(m1.find());
				}

				mpMessage.put(sobj.Id, message);
			}
		}
		return mpMessage;
	}
}
