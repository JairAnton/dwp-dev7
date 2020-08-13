/* -------------------------------------------------------------------
 * Jose Rodriguez               07/08/2019          Original version.<p />
 *
 * @author Jose Rodriguez
 */
public virtual class Minuta_ctrl extends MinutaWrap {//NOSONAR
	public String idVisitaActual {get; set;}
	public dwp_kitv__Visit__c datosVisita {get; set;}
	public dwp_kitv__Visit__c visit {get; set;}
	public boolean redireccion {get; set;}
	public Final String currentDate { get { return formatCurrentDate(Date.today()); }}
	public String visitDate {get; set;}
	public String infoStatusVisit {get; set;}
	public boolean correoEnviado {get; set;}
	public string sMyCS {get; set;}
	/*
	 *   @Variable: FORMAT_DATE
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

	public Minuta_ctrl(ApexPages.StandardController controller) {
		idVisitaActual = ApexPages.currentPage().getParameters().get('Id');
		datosVisita = new dwp_kitv__Visit__c();
		visit = new dwp_kitv__Visit__c();
		redireccion = false;
		infoStatusVisit = '';
		datosVisita = [select id, Name, dwp_kitv__visit_start_date__c, account_name__c, dwp_kitv__visit_status_type__c,
		               (select id, dwp_kitv__contact_id__r.Name, dwp_kitv__contact_email_desc__c from dwp_kitv__Visit_Contacts__r),
		               (SELECT id, dwp_kitv__user_id__r.Name, dwp_kitv__contact_email_desc__c FROM dwp_kitv__Visit_Management_Teams__r)
		               from dwp_kitv__Visit__c where Id =:idVisitaActual limit 1];
		visit.id = datosVisita.Id;
		visit.dwp_kitv__visit_status_type__c = datosVisita.dwp_kitv__visit_status_type__c;
		visit.dwp_kitv__visit_start_date__c = datosVisita.dwp_kitv__visit_start_date__c;
		if(visit.dwp_kitv__visit_status_type__c != '02') {
			infoStatusVisit = 'AVISO: No se enviará la minuta, debe estar agendada la visita.';
		}
		correoEnviado = false;
		setValues(controller.getId());
		visitDate = getTimeZoneValue(visit.dwp_kitv__visit_start_date__c);
		System.debug('--sMyCS-->' + ApexPages.currentPage().getParameters().get('myCS'));
		sMyCS = ApexPages.currentPage().getParameters().get('myCS');
	}

	public void sendMail() {
		System.debug('--sMyCS-->' + sMyCS);
		if(sMyCS != null && sMyCS != '') {
			sMyCS = sMyCS.replaceAll('@@',':');
			dwp_kitv__Template_for_type_of_visit_cs__c myCS = (dwp_kitv__Template_for_type_of_visit_cs__c)System.JSON.deserialize(sMyCS, dwp_kitv__Template_for_type_of_visit_cs__c.class);//NOSONAR
			String sDocumentos = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('documents'));//NOSONAR
			System.debug('--sDocumentos-->' + sDocumentos);
			Final List<ContentVersion> lstDocument = (List<ContentVersion>)System.JSON.deserialize(sDocumentos, List<ContentVersion>.class);
			System.debug('--lstDocument-->' + lstDocument);

			if(myCS != null) {
				if(visit.dwp_kitv__visit_status_type__c == '02') {
					System.debug('--si tiene sMyCS-->' + sMyCS);
					enviarMinutaVF(visit, myCS, lstDocument);
				} else {
					redireccion = true;
				}
			}
		}
	}

	/**
	 * enviarMinutaVF
	 */
	public void enviarMinutaVF(dwp_kitv__Visit__c visitObj, dwp_kitv__Template_for_type_of_visit_cs__c myCS, List<ContentVersion> documents) {
		//keep the status of the visit
		Final String statusOldVisit = visitObj.dwp_kitv__visit_status_type__c;
		String templateConverted = 'BODY NULL';
		try {
			dwp_kitv.Minute_Generator_Ctrl.updateStatusVisit(visitObj, '05');
			Final dwp_kitv__Visit__c visitObjNew = dwp_kitv.Minute_Generator_Ctrl.getVisitObj(visitObj.Id);
			System.debug('--si tiene visitObjNew-->' + visitObjNew);
			Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
			PageReference templateVF = Page.Minuta;
			System.debug('-- PageReference templateVF->' + templateVF);
			templateVF.getParameters().put('id', visitObjNew.Id);
			templateVF.setRedirect(true);
			//templateConverted = templateVF.getContent().tostring();
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
			Final String inputDate = visitObj.dwp_kitv__visit_start_date__c.format(FORMAT_DATE);
			Final String sendDate = System.now().format(FORMAT_DATE);
			email.setSubject(myCS.dwp_kitv__Subject__c + ' del ' + inputDate + ' - enviado: ' + sendDate);
			Final List<String> typeAddress = dwp_kitv.Minute_Generator_Ctrl.getTypeAddress();
			email = dwp_kitv.Minute_Generator_Ctrl.setAddressToEmail(email, typeAddress, visitObjNew);
			Final boolean attachFile = dwp_kitv.Minute_Generator_Ctrl.getExistField(myCS, 'dwp_kitv__Attach_file__c');
			Final List<Id> ltsIdDoc = dwp_kitv.Minute_Generator_Ctrl.getIdsDocuments(documents);
			email = dwp_kitv.Minute_Generator_Ctrl.setFiles(email, ltsIdDoc, attachFile);
			email.setSaveAsActivity(false);
			System.debug('--attachFile->' + attachFile);
			System.debug('--ltsIdDoc->' + ltsIdDoc);
			Final Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {email};
			Final Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
			System.debug('---results-EMAIL->' + results);
			if(results[0].isSuccess()) {
				createEmailAttachment(visitObjNew);
				dwp_kitv.Minute_Generator_Ctrl.createActivity(visitObjNew.Id, myCS);
				correoEnviado = true;
			} else {
				dwp_kitv.Minute_Generator_Ctrl.updateStatusVisit(visitObjNew, statusOldVisit);
			}
			redireccion = true;
		} catch(Exception ex) {
			System.debug('---Exception->' + ex);
			dwp_kitv.Minute_Generator_Ctrl.updateStatusVisit(visitObj, statusOldVisit);
		}
	}

	public String createEmailAttachment(dwp_kitv__Visit__c visitObjNew) {
		PageReference pdfMinuta = Page.Minuta;
		pdfMinuta.getParameters().put('id', visitObjNew.Id);
		pdfMinuta.setRedirect(true);
		Blob body;
		if(!test.isRunningTest()) {
			body = pdfMinuta.getContentAsPDF();
		} else {
			body = Blob.valueOf('Some Text');
		}
		Final Attachment attach = new Attachment(Body = body, Name = 'Minuta visita del ' + formatCurrentDate(Date.today()) + '.pdf', IsPrivate = false,
		                                         ParentId = visitObjNew.Id);
		insert attach;
		return attach.id;
	}

	public String getTimeZoneValue(DateTime stardDate) {
		Map<String, String> mappedValues = new Map<String, String>(); //map for holding locale to datetime format
		mappedValues = mapValues(); //populate the map with all the locale specific datetime formats
		Final String userLocale = UserInfo.getLocale(); //grab the locale of the user
		String datetimeFormat = FORMAT_DATE_2; //variable for the datetime format defaulted to the US format
		if(mappedValues.containsKey(userLocale)) {  //if the map contains the correct datetime format
			datetimeFormat = mappedValues.get(userLocale); //grab the datetime format for the locale
		}
		return stardDate.format(datetimeFormat); //create a string with the proper format & return the string
	}

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
}
