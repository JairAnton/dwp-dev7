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
public virtual class BE_SM_Minute_Ctr extends BE_SM_Minute_Wrapper {
	/** @Description meeting*/
    public slmt__Sales_Meeting__c meeting {get; set;}
	/** @Description currentDate*/
    public Final String currentDate { get { return formatCurrentDate(Date.today()); }}
	/** @Description meetingDate*/
    public String meetingDate {get; set;}
	/** @Description mapTopic*/
    public Map<String, String> mapTopic {
		get{return getMapValues(new BE_SM_TopicQVC_Cls().getCardDetails(meeting, 'cardId'));}
	}
	/** @Description mapVisit*/
    public Map<String, String> mapVisit {
		get{return getMapValues(new BE_SM_VisitQVC_Cls().getCardDetails(meeting, 'cardId'));}
	}
	/** @Description mapPipeline*/
    public Map<String, String> mapPipeline {
		get{return getMapValues(new BE_SM_PipelineLPQVC_Cls().getCardDetails(meeting, 'cardId'));}
	}
	/** @Description mapPC*/
    public Map<String, String> mapPC {
		get{return getMapValues(new BE_SM_CommPlanQVC_Cls().getCardDetails(meeting, 'cardId'));}
	}
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
	 *   @Variable: FORMAT_DATE_5
	 */
	public static Final String FORMAT_DATE_5 = 'd.M.yyyy H:mm';
	/*
	 *   @Variable: FORMAT_DATE_6
	 */
	public static Final String FORMAT_DATE_6 = 'dd.MM.yyyy HH:mm';
	/*
	 *   @Variable: FORMAT_DATE_7
	 */
	public static Final String FORMAT_DATE_7 = 'd/MM/yyyy H:mm';
	/*
	 *   @Variable: FORMAT_DATE_8
	 */
	public static Final String FORMAT_DATE_8 = 'yyyy-MM-dd HH:mm';	
	
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
		Final String statusOldMeeting = meeting.slmt__mngmt_plan_meeting_status_name__c;
		String templateConverted = 'BODY NULL';
		try {
			Final Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
			Final PageReference templateVF = Page.BE_SM_Minute_vf;
			templateVF.getParameters().put('id', meeting.Id);
			templateVF.setRedirect(true);
			if(!test.isRunningTest()) {
				templateConverted = templateVF.getContent().tostring();
			} else {
				templateConverted = '';
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
		if(!test.isRunningTest()) {
			body = pdfMinuta.getContentAsPDF();
		} else {
			body = Blob.valueOf('Some Text');
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
		localeMap.put('ar', FORMAT_DATE_3);
		localeMap.put('ar_AE', FORMAT_DATE_3);
		localeMap.put('ar_BH', FORMAT_DATE_3);
		localeMap.put('ar_JO', FORMAT_DATE_3);
		localeMap.put('ar_KW', FORMAT_DATE_3);
		localeMap.put('ar_LB', FORMAT_DATE_3);
		localeMap.put('ar_SA', FORMAT_DATE_3);
		localeMap.put('bg_BG', 'yyyy-M-d H:mm');
		localeMap.put('ca', FORMAT_DATE_4);
		localeMap.put('ca_ES', FORMAT_DATE_4);
		localeMap.put('ca_ES_EURO', FORMAT_DATE_4);
		localeMap.put('cs', FORMAT_DATE_5);
		localeMap.put('cs_CZ', FORMAT_DATE_5);
		localeMap.put('da', 'dd-MM-yyyy HH:mm');
		localeMap.put('da_DK', 'dd-MM-yyyy HH:mm');
		localeMap.put('de', FORMAT_DATE_6);
		localeMap.put('de_AT', FORMAT_DATE_6);
		localeMap.put('de_AT_EURO', FORMAT_DATE_6);
		localeMap.put('de_CH', FORMAT_DATE_6);
		localeMap.put('de_DE', FORMAT_DATE_6);
		localeMap.put('de_DE_EURO', FORMAT_DATE_6);
		localeMap.put('de_LU', FORMAT_DATE_6);
		localeMap.put('de_LU_EURO', FORMAT_DATE_6);
		localeMap.put('el_GR', 'd/M/yyyy h:mm a');
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
		localeMap.put('fi', FORMAT_DATE_5);
		localeMap.put('fi_FI', FORMAT_DATE_5);
		localeMap.put('fi_FI_EURO', FORMAT_DATE_5);
		localeMap.put('fr', FORMAT_DATE_4);
		localeMap.put('fr_BE', FORMAT_DATE_7);
		localeMap.put('fr_CA', FORMAT_DATE_8);
		localeMap.put('fr_CH', FORMAT_DATE_6);
		localeMap.put('fr_FR', FORMAT_DATE_4);
		localeMap.put('fr_FR_EURO', FORMAT_DATE_4);
		localeMap.put('fr_LU', FORMAT_DATE_4);
		localeMap.put('fr_MC', FORMAT_DATE_4);
		localeMap.put('hr_HR', 'yyyy.MM.dd HH:mm');
		localeMap.put('hu', 'yyyy.MM.dd. H:mm');
		localeMap.put('hy_AM', FORMAT_DATE_2);
		localeMap.put('is_IS', 'd.M.yyyy HH:mm');
		localeMap.put('it', 'dd/MM/yyyy H.mm');
		localeMap.put('it_CH', FORMAT_DATE_6);
		localeMap.put('it_IT', 'dd/MM/yyyy H.mm');
		localeMap.put('iw', 'HH:mm dd/MM/yyyy');
		localeMap.put('iw_IL', 'HH:mm dd/MM/yyyy');
		localeMap.put('ja', 'yyyy/MM/dd H:mm');
		localeMap.put('ja_JP', 'yyyy/MM/dd H:mm');
		localeMap.put('kk_KZ', FORMAT_DATE_2);
		localeMap.put('km_KH', FORMAT_DATE_2);
		localeMap.put('ko', 'yyyy. M. d a h:mm');
		localeMap.put('ko_KR', 'yyyy. M. d a h:mm');
		localeMap.put('lt_LT', 'yyyy.M.d HH.mm');
		localeMap.put('lv_LV', 'yyyy.d.M HH:mm');
		localeMap.put('ms_MY', 'dd/MM/yyyy h:mm a');
		localeMap.put('nl', 'd-M-yyyy H:mm');
		localeMap.put('nl_BE', FORMAT_DATE_7);
		localeMap.put('nl_NL', 'd-M-yyyy H:mm');
		localeMap.put('nl_SR', 'd-M-yyyy H:mm');
		localeMap.put('no', FORMAT_DATE_6);
		localeMap.put('no_NO', FORMAT_DATE_6);
		localeMap.put('pl', FORMAT_DATE_8);
		localeMap.put('pt', 'dd-MM-yyyy H:mm');
		localeMap.put('pt_AO', 'dd-MM-yyyy H:mm');
		localeMap.put('pt_BR', FORMAT_DATE_4);
		localeMap.put('pt_PT', 'dd-MM-yyyy H:mm');
		localeMap.put('ro_RO', FORMAT_DATE_6);
		localeMap.put('ru', 'dd.MM.yyyy H:mm');
		localeMap.put('sk_SK', FORMAT_DATE_5);
		localeMap.put('sl_SI', 'd.M.y H:mm');
		localeMap.put('sv', FORMAT_DATE_8);
		localeMap.put('sv_SE', FORMAT_DATE_8);
		localeMap.put('th', FORMAT_DATE_2);
		localeMap.put('th_TH', 'd/M/yyyy, H:mm ?.');
		localeMap.put('tr', FORMAT_DATE_6);
		localeMap.put('ur_PK', FORMAT_DATE_2);
		localeMap.put('vi_VN', 'HH:mm dd/MM/yyyy');
		localeMap.put('zh', 'yyyy-M-d ah:mm');
		localeMap.put('zh_CN', 'yyyy-M-d ah:mm');
		localeMap.put('zh_HK', 'yyyy-M-d ah:mm');
		localeMap.put('zh_TW', 'yyyy/M/d a h:mm');
		return localeMap; //return the map
	}

	/*
	 * @Description method getMapValues
	 */
    private Map<String, String> getMapValues(List<Map<String,String>> lstMapQVC) {
		Final Map<String, String> mapVPF = new Map<String, String>();
		for(Integer i = 1; i < lstMapQVC.size(); i++) {
			mapVPF.put('label_'+i, (lstMapQVC[i]).get('label'));
			mapVPF.put('value_'+i, (lstMapQVC[i]).get('value'));
		}
		return mapVPF;
	}
}