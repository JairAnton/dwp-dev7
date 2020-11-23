/**
   -------------------------------------------------------------------------------------------------
   @Name BE_SM_Minute_Ctr
   @Author Martin Alejandro Mori Chavez (martin.mori.contractor@bbva.com)
   @Date 2020-11-11
   @Description
   @Changes
   Date        Author   Email                  				Type
   2020-11-11  MAMCH    martin.mori.contractor@bbva.com    	Creation
   -------------------------------------------------------------------------------------------------
 */
public without sharing virtual class BE_SM_Minute_Ctr {
	/** @Description meeting*/
    public slmt__Sales_Meeting__c meeting { get; set; }
	/** @Description currentDate*/
    public Final String currentDate { get { return formatCurrentDate(Date.today()); } }
	/** @Description meetingDate*/
    public String meetingDate { get; set; }
	/** @Description mapTopic*/
    public Map<String, String> mapTopic { get; set; }
	/** @Description mapVisit*/
    public Map<String, String> mapVisit { get; set; }
	/** @Description mapPipeline*/
    public Map<String, String> mapPipeline { get; set; }
	/** @Description mapPC*/
    public Map<String, String> mapPC { get; set; }
    /*   @Variable: FORMAT_DATE
	 */
	public static Final String FORMAT_DATE = 'dd-MM-YYYY HH:mm a';
	/*
	 *   @Variable: FORMAT_DATE_2
	 */
	public static Final String FORMAT_DATE_2 = 'M/d/yyyy h:mm a';
	/*
	 *   @Variable: FORMAT_DATE_3
	 */
	public static Final String FORMAT_DATE_3 = 'dd/MM/yyyy hh:mm a';
	/*
	 *   @Variable: FORMAT_DATE_4
	 */
	public static Final String FORMAT_DATE_4 = 'dd/MM/yyyy HH:mm';
	/*
	 *   @Variable: FORMAT_DATE_7
	 */
	public static Final String FORMAT_DATE_7 = 'd/MM/yyyy H:mm';
    /** @Description slmtTopics*/
    public static List<Task> slmtTopics {get; set;}
	/** @Description urlLogo*/
    public static String urlLogo {get; set;}
	/** @Description urlLogoWhite*/
    public static String urlLogoWhite {get; set;}
	/** @Description urlLogoFacebook*/
    public static String urlLogoFacebook {get; set;}
	/** @Description urlLogoTwiter*/
    public static String urlLogoTwiter {get; set;}
    
	/*
	 * @Description method BE_SM_Minute_Ctr
	 */
    public BE_SM_Minute_Ctr(ApexPages.StandardController controller) {
		meeting = [SELECT Id, Name, slmt__management_plan_meeting_date__c, slmt__mngmt_plan_meet_dur_number__c, 
		slmt__mngmt_plan_meeting_start_desc__c, slmt__mngmt_plan_meeting_status_name__c, slmt__mngmt_plan_meeting_user_id__c, 
		slmt__mngmt_plan_meeting_user_id__r.Email, Type_of_meeting__c, Collaborator__c, Collaborator__r.Email, 
		DateTime__c, Url__c FROM slmt__Sales_Meeting__c WHERE Id =:controller.getId() LIMIT 1];
        setValues(controller.getId());
		meetingDate = getTimeZoneValue(meeting.DateTime__c);
        mapTopic = getMapValues(new BE_SM_TopicQVC_Cls().getCardDetails(meeting, 'Item1'));
        mapVisit = getMapValues(new BE_SM_VisitQVC_Cls().getCardDetails(meeting, 'Item2'));
        mapPipeline = getMapValues(new BE_SM_PipelineLPQVC_Cls().getCardDetails(meeting, 'Item3'));
        mapPC = getMapValues(new BE_SM_CommPlanQVC_Cls().getCardDetails(meeting, 'Item4'));
	}
    
    /**
	 * formatCurrentDate
	 */
	public String formatCurrentDate(Date dateToConvert) {
		Final Integer day = dateToConvert.day();
		Final Integer month = dateToConvert.month();
		Final Integer year = dateToConvert.year();
		Final String strMonth  = getStringMonth(month);
		return day + ' de ' + strMonth + ' de ' + year;
	}

	/**
	 * getStringMonth
	 */
	public String getStringMonth(Integer month) {
		Final Map<Integer, String> mapMonths = new Map<Integer, String> { 1 => 'Enero', 2 => 'Febrero', 3 => 'Marzo', 4 => 'Abril', 5 => 'Mayo', 6 => 'Junio',
			                                                              7 => 'Julio', 8 => 'Agosto', 9 => 'Septiembre', 10 => 'Octubre', 11 => 'Noviembre', 12 => 'Diciembre' };
		return mapMonths.get(month);
	}

	/*
	 * @Description method sendMail
	 */
    public void sendMail() {
		String templateConverted = 'BODY NULL';
		try {
			Final Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
			Final PageReference templateVF = Page.BE_SM_Minute_vf;
			templateVF.getParameters().put('id', meeting.Id);
			templateVF.setRedirect(true);
			if(test.isRunningTest()) {
				templateConverted = '';
			} else {
				templateConverted = templateVF.getContent().tostring();
			}
			Final String htmlBody = '<![CDATA[ <html lang="es">' +
			                        '<meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />' +
			                        templateConverted +
			                        '</html>';
			email.setHtmlBody(htmlBody);
			Final String inputDate = meeting.DateTime__c.format(FORMAT_DATE);
			Final String sendDate = System.now().format(FORMAT_DATE);
			email.setSubject('Minuta de reunión individual del ' + inputDate + ' - enviado: ' + sendDate);
            email.toAddresses = new String[] {meeting.slmt__mngmt_plan_meeting_user_id__r.Email, meeting.Collaborator__r.Email};
			email.setSaveAsActivity(false);
			Final Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {email};
			Final Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
			if(results[0].isSuccess()) {
				createPdf(meeting);
			}
		} catch(Exception ex) {
			System.debug('---Exception->' + ex);
		}
	}

	/*
	 * @Description method createPdf
	 */
    public String createPdf(slmt__Sales_Meeting__c slmtObjNew) {
		Final PageReference pdfMinuta = Page.BE_SM_Minute_vf;
		pdfMinuta.getParameters().put('id', slmtObjNew.Id);
		pdfMinuta.setRedirect(true);
		Blob body;
		if(test.isRunningTest()) {
			body = Blob.valueOf('Some Text');
		} else {
			body = pdfMinuta.getContentAsPDF();
		}
		Final ContentVersion conVer = new ContentVersion();
        conVer.ContentLocation = 'S';
        conVer.versionData = body;
        conVer.title = 'Minuta de reunión de ' + slmtObjNew.Type_of_meeting__c + ' del ' + formatCurrentDate(Date.today());
        conVer.pathOnClient = conVer.title + '.pdf';
        insert conVer;
        Final Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id].ContentDocumentId;
        Final ContentDocumentLink conDocLink = New ContentDocumentLink();
        conDocLink.LinkedEntityId = slmtObjNew.Id;
        conDocLink.ContentDocumentId = conDoc;
        conDocLink.shareType = 'V';
        insert conDocLink;
		return conDocLink.Id;
	}

	/*
	 * @Description method getTimeZoneValue
	 */
    public String getTimeZoneValue(DateTime stardDate) {
		Map<String, String> mappedValues = new Map<String, String>();
		mappedValues = mapValues();
		Final String userLocale = UserInfo.getLocale();
		String datetimeFormat = FORMAT_DATE_2;
		if(mappedValues.containsKey(userLocale)) {
			datetimeFormat = mappedValues.get(userLocale);
		}
		return stardDate.format(datetimeFormat);
	}

	/*
	 * @Description method mapValues
	 */
    private Map<String, String> mapValues() {
		Final Map<String, String> localeMap = new Map<String, String>(); //holds the locale to timedate formats
		localeMap.put('en_AU', 'd/MM/yyyy HH:mm');
		localeMap.put('en_B', FORMAT_DATE_2);
		localeMap.put('en_BM', FORMAT_DATE_2);
		localeMap.put('en_CA', 'dd/MM/yyyy h:mm a');
		localeMap.put('en_GB', FORMAT_DATE_4);
		localeMap.put('en_GH', FORMAT_DATE_2);
		localeMap.put('en_ID', FORMAT_DATE_2);
		localeMap.put('en_IE', FORMAT_DATE_4);
		localeMap.put('en_IE_EURO', FORMAT_DATE_4);
		localeMap.put('en_NZ', 'd/MM/yyyy HH:mm');
		localeMap.put('en_SG', FORMAT_DATE_2);
		localeMap.put('en_US', FORMAT_DATE_2);
		localeMap.put('en_ZA', 'yyyy/MM/dd hh:mm a');
		localeMap.put('es', FORMAT_DATE_7);
		localeMap.put('es_AR', FORMAT_DATE_4);
		localeMap.put('es_BO', FORMAT_DATE);
		localeMap.put('es_CL', FORMAT_DATE);
		localeMap.put('es_CO', 'd/MM/yyyy hh:mm a');
		localeMap.put('es_CR', FORMAT_DATE_3);
		localeMap.put('es_EC', FORMAT_DATE_3);
		localeMap.put('es_ES', FORMAT_DATE_7);
		localeMap.put('es_ES_EURO', FORMAT_DATE_7);
		localeMap.put('es_GT', 'd/MM/yyyy hh:mm a');
		localeMap.put('es_HN', 'MM-dd-yyyy hh:mm a');
		localeMap.put('es_MX', 'd/MM/yyyy hh:mm a');
		localeMap.put('es_PE', FORMAT_DATE_3);
		localeMap.put('es_PR', 'MM-dd-yyyy hh:mm a');
		localeMap.put('es_PY', FORMAT_DATE_3);
		localeMap.put('es_SV', 'MM-dd-yyyy hh:mm a');
		localeMap.put('es_UY', FORMAT_DATE_3);
		localeMap.put('es_VE', FORMAT_DATE_3);
		localeMap.put('et_EE', 'd.MM.yyyy H:mm');
		return localeMap;
	}

	/*
	 * @Description method getMapValues
	 */
    private Map<String, String> getMapValues(List<Map<String,String>> lstMapQVC) {
		Final Map<String, String> mapVPF = new Map<String, String>();
		for(Integer i = 1; i < lstMapQVC.size(); i++) {
			mapVPF.put('label_'+i, lstMapQVC[i].get('label'));
			mapVPF.put('value_'+i, lstMapQVC[i].get('value'));
		}
		return mapVPF;
	}
    
    /*
	 * @Description method setValues
	 */
    public static void setValues(String slmtId) {
        try {
			slmtTopics = [SELECT Id, ActivityDate, Subject, Status, Owner.Name, What.Name FROM Task 
                          WHERE RecordType.DeveloperName = 'Sales_Meeting' AND slmt__management_plan_meeting_id__c = :slmtId
                          ORDER BY Status ASC, ActivityDate DESC];
			Final String lstMembrete = [SELECT Id FROM Document WHERE DeveloperName = 'Logo_BBVA' LIMIT 1].isEmpty() ? '' : [SELECT Id FROM Document WHERE DeveloperName = 'Logo_BBVA' LIMIT 1].Id;
			Final String lstMembreteWhite = [SELECT Id FROM Document WHERE DeveloperName = 'Logo_BBVA_white' LIMIT 1].isEmpty() ? '' : [SELECT Id FROM Document WHERE DeveloperName = 'Logo_BBVA_white' LIMIT 1].Id;
			Final String lstLogoFace = [SELECT Id FROM Document WHERE DeveloperName = 'facebook_logo' LIMIT 1].isEmpty() ? '' : [SELECT Id FROM Document WHERE DeveloperName = 'facebook_logo' LIMIT 1].Id;
			Final String lstLogoTwiter = [SELECT Id FROM Document WHERE DeveloperName = 'twitter_logo' LIMIT 1].isEmpty() ? '' : [SELECT Id FROM Document WHERE DeveloperName = 'twitter_logo' LIMIT 1].Id;
			Final String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm() + '/servlet/servlet.ImageServer?id=';
			Final String param = '&oid=';
            urlLogo = sfdcBaseURL + lstMembrete + param + UserInfo.getOrganizationId();
			urlLogoFacebook = sfdcBaseURL + lstLogoFace + param + UserInfo.getOrganizationId();
			urlLogoTwiter = sfdcBaseURL + lstLogoTwiter + param + UserInfo.getOrganizationId();
			urlLogoWhite = sfdcBaseURL + lstMembreteWhite + param + UserInfo.getOrganizationId();
			
		} catch(System.Exception e) {
			system.debug('Exception : ' + e.getMessage());
		}
	}
}