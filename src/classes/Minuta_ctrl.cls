/* -------------------------------------------------------------------
* Jose Rodriguez               07/08/2019          Original version.<p />
*
* @author Jose Rodriguez
*/
public virtual class Minuta_ctrl extends MinutaWrap{
    
    public String IdVisitaActual {get; set;}
    public dwp_kitv__Visit__c DatosVisita {get; set;}
    public dwp_kitv__Visit__c visit {get; set;}
    public boolean redireccion {get; set;}
    public String currentDate { get { return formatCurrentDate(Date.today()); }}
    public String visitDate {get; set;}
    public String infoStatusVisit {get; set;}
    public boolean correoEnviado {get; set;}

    Public String formatCurrentDate(Date dateToConvert){
       
        Integer day = dateToConvert.day();
        Integer month = dateToConvert.month();
        Integer year = dateToConvert.year();
        String strMonth  = getStringMonth(month); 
        return day + ' de ' + strMonth + ' de ' + year ;  
    }
    
    Public String getStringMonth(Integer month){
       String strMonth ='';
        if(month==1){
           strMonth = 'Enero';
        }else if (month==2){
           strMonth = 'Febreo'; 
        }else if (month==3){
           strMonth = 'Marzo'; 
        }else if (month==4){
           strMonth = 'Abril'; 
        }else if (month==5){
           strMonth = 'Mayo'; 
        }else if (month==6){
           strMonth = 'Junio'; 
        }else if (month==7){
           strMonth = 'Julio'; 
        }else if (month==8){
           strMonth = 'Agosto'; 
        }else if (month==9){
           return 'Septiembre'; 
        }else if (month==10){
           strMonth = 'Octubre'; 
        }else if (month==11){
           strMonth = 'Noviembre'; 
        }else if (month==12){
           strMonth = 'Diciebre'; 
        }
        return strMonth;
    }
    
    
    public Minuta_ctrl(ApexPages.StandardController controller){
 
       IdVisitaActual = ApexPages.currentPage().getParameters().get('Id');
       DatosVisita = new dwp_kitv__Visit__c();
       visit = new dwp_kitv__Visit__c();
       redireccion = false;
       infoStatusVisit='';
       DatosVisita = [select id,Name,dwp_kitv__visit_start_date__c,account_name__c, dwp_kitv__visit_status_type__c,
                      (select id,dwp_kitv__contact_id__r.Name,dwp_kitv__contact_email_desc__c from dwp_kitv__Visit_Contacts__r ),
                      (SELECT id,dwp_kitv__user_id__r.Name,dwp_kitv__contact_email_desc__c FROM dwp_kitv__Visit_Management_Teams__r) 
                      from dwp_kitv__Visit__c where Id =:IdVisitaActual limit 1]; 
        visit.id = DatosVisita.Id;
       	visit.dwp_kitv__visit_status_type__c = DatosVisita.dwp_kitv__visit_status_type__c;
       	visit.dwp_kitv__visit_start_date__c=DatosVisita.dwp_kitv__visit_start_date__c;
        if(visit.dwp_kitv__visit_status_type__c !='02'){
        infoStatusVisit = 'AVISO: No se enviará la minuta, debe estar agendada la visita.';
       }
        correoEnviado=false;
       setValues(controller.getId());
	   visitDate=getTimeZoneValue(visit.dwp_kitv__visit_start_date__c);
    }
    
    
    public void sendMail() {
        string sMyCS = ApexPages.currentPage().getParameters().get('myCS');
        if(sMyCS != null && sMyCS != ''){
            dwp_kitv__Template_for_type_of_visit_cs__c myCS =(dwp_kitv__Template_for_type_of_visit_cs__c)System.JSON.deserialize(sMyCS, dwp_kitv__Template_for_type_of_visit_cs__c.class);
            String sDocumentos = ApexPages.currentPage().getParameters().get('documents');
            System.debug('--sDocumentos-->'+sDocumentos);
            List<ContentVersion> lstDocument = (List<ContentVersion>)System.JSON.deserialize(sDocumentos, List<ContentVersion>.class);
            System.debug('--lstDocument-->'+lstDocument);
        
            if(myCS != null){
                if(visit.dwp_kitv__visit_status_type__c=='02'){
                    System.debug('--si tiene sMyCS-->'+ sMyCS);
                    EnviarMinutaVF(visit, myCS, lstDocument);
                }else{
                    redireccion = true;
                }          
             } 
        }
    }
    
    
     public void EnviarMinutaVF(dwp_kitv__Visit__c visitObj, dwp_kitv__Template_for_type_of_visit_cs__c myCS,List<ContentVersion> documents){
        //keep the status of the visit
        String statusOldVisit = visitObj.dwp_kitv__visit_status_type__c;
        String templateConverted = 'BODY NULL';
        list<Messaging.Emailfileattachment> lstAdjuntos = new list<Messaging.Emailfileattachment>();//adicional ASD
        try{
            dwp_kitv.Minute_Generator_Ctrl.updateStatusVisit(visitObj,'05');
            dwp_kitv__Visit__c visitObjNew=dwp_kitv.Minute_Generator_Ctrl.getVisitObj(visitObj.Id);
            System.debug('--si tiene visitObjNew-->'+ visitObjNew);
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();   
            PageReference templateVF = Page.Minuta;
             System.debug('-- PageReference templateVF->'+templateVF);
            templateVF.getParameters().put('id',visitObjNew.Id);
            templateVF.setRedirect(true);
            //templateConverted = templateVF.getContent().tostring();
             if(!test.isRunningTest()){
                templateConverted = templateVF.getContent().tostring();
            }else{
                templateConverted='';
            }
 			String htmlBody = 	'<![CDATA[ <html lang="es">'+
                                '<meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />'+
                                templateConverted+
                                '</html>';
            email.setHtmlBody(htmlBody); 
            String inputDate = visitObj.dwp_kitv__visit_start_date__c.format('dd-MM-YYYY HH:mm a');
            String sendDate =  System.now().format('dd-MM-YYYY HH:mm a');
			email.setSubject(myCS.dwp_kitv__Subject__c +' del '+inputDate + ' - enviado: ' + sendDate );
  			List<String> typeAddress= dwp_kitv.Minute_Generator_Ctrl.getTypeAddress();
			email = dwp_kitv.Minute_Generator_Ctrl.setAddressToEmail(email,typeAddress,visitObjNew);
			boolean attachFile= dwp_kitv.Minute_Generator_Ctrl.getExistField(myCS, 'dwp_kitv__Attach_file__c');
  			List<Id> ltsIdDoc = dwp_kitv.Minute_Generator_Ctrl.getIdsDocuments(documents);
 			email = dwp_kitv.Minute_Generator_Ctrl.setFiles(email, ltsIdDoc, attachFile);
            email.setSaveAsActivity(false);
            System.debug('--attachFile->'+attachFile);
            System.debug('--ltsIdDoc->'+ltsIdDoc);
            Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {email};
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
            System.debug('---results-EMAIL->'+results);
            if (results[0].isSuccess()) {
                createEmailAttachment(visitObjNew);
               dwp_kitv.Minute_Generator_Ctrl.createActivity(visitObjNew.Id, myCS);
				correoEnviado=true;
            }else{
               dwp_kitv.Minute_Generator_Ctrl.updateStatusVisit(visitObjNew,statusOldVisit);
            }
            redireccion = true;
        }catch(Exception ex) {
            System.debug('---Exception->'+ex);
           dwp_kitv.Minute_Generator_Ctrl.updateStatusVisit(visitObj,statusOldVisit);
        }
    }
    
    
    public String createEmailAttachment( dwp_kitv__Visit__c visitObjNew){
        		PageReference pdfMinuta = Page.Minuta;
               	pdfMinuta.getParameters().put('id',visitObjNew.Id);
               	pdfMinuta.setRedirect(true);
        		String templateConverted2 ='';
               	//String templateConverted2 = pdfMinuta.getContent().tostring();
         		if(!test.isRunningTest()){
               	 templateConverted2 = pdfMinuta.getContent().tostring();
            	}else{
                	templateConverted2='';
            	}    	
 				String htmlBody2 = '<![CDATA[ <html lang="es">'+
                                    '<meta content="text/html; " http-equiv="Content-Type" />'+
                                    templateConverted2+
                                    '</html>';
    			Attachment attach = new Attachment();
                Blob  body  ;
             	try { 
					body = Blob.valueOf(htmlBody2);
				} catch (VisualforceException e) {
        		body = Blob.valueOf('Some Text');
    		}
			attach.Body = body;  // body;
            attach.Name = 'Minuta visita del '+formatCurrentDate(Date.today())+'.html';
            attach.IsPrivate = false;
            attach.ParentId  = visitObjNew.Id;
   			insert attach;
        return attach.id;
    }

	public String getTimeZoneValue(DateTime stardDate) {
		Map<String, String> mappedValues = new Map<String, String>(); //map for holding locale to datetime format
		mappedValues = MapValues(); //populate the map with all the locale specific datetime formats
		String user_locale = UserInfo.getLocale(); //grab the locale of the user
		String datetime_format = 'M/d/yyyy h:mm a'; //variable for the datetime format defaulted to the US format
		if (mappedValues.containsKey(user_locale)) { //if the map contains the correct datetime format
			datetime_format = mappedValues.get(user_locale); //grab the datetime format for the locale
		}
		String locale_formatted_date_time_value = stardDate.format(datetime_format); //create a string with the proper format
		return locale_formatted_date_time_value; //return the string
	}
    
    private Map<String, String> MapValues() {
		Map<String, String> locale_map = new Map<String, String>(); //holds the locale to timedate formats
		locale_map.put('ar', 'dd/MM/yyyy hh:mm a');
		locale_map.put('ar_AE', 'dd/MM/yyyy hh:mm a');
		locale_map.put('ar_BH', 'dd/MM/yyyy hh:mm a');
		locale_map.put('ar_JO', 'dd/MM/yyyy hh:mm a');
		locale_map.put('ar_KW', 'dd/MM/yyyy hh:mm a');
		locale_map.put('ar_LB', 'dd/MM/yyyy hh:mm a');
		locale_map.put('ar_SA', 'dd/MM/yyyy hh:mm a');
		locale_map.put('bg_BG', 'yyyy-M-d H:mm');
		locale_map.put('ca', 'dd/MM/yyyy HH:mm');
		locale_map.put('ca_ES', 'dd/MM/yyyy HH:mm');
		locale_map.put('ca_ES_EURO', 'dd/MM/yyyy HH:mm');
		locale_map.put('cs', 'd.M.yyyy H:mm');
		locale_map.put('cs_CZ', 'd.M.yyyy H:mm');
		locale_map.put('da', 'dd-MM-yyyy HH:mm');
		locale_map.put('da_DK', 'dd-MM-yyyy HH:mm');
		locale_map.put('de', 'dd.MM.yyyy HH:mm');
		locale_map.put('de_AT', 'dd.MM.yyyy HH:mm');
		locale_map.put('de_AT_EURO', 'dd.MM.yyyy HH:mm');
		locale_map.put('de_CH', 'dd.MM.yyyy HH:mm');
		locale_map.put('de_DE', 'dd.MM.yyyy HH:mm');
		locale_map.put('de_DE_EURO', 'dd.MM.yyyy HH:mm');
		locale_map.put('de_LU', 'dd.MM.yyyy HH:mm');
		locale_map.put('de_LU_EURO', 'dd.MM.yyyy HH:mm');
		locale_map.put('el_GR', 'd/M/yyyy h:mm a');
		locale_map.put('en_AU', 'd/MM/yyyy HH:mm');
		locale_map.put('en_B', 'M/d/yyyy h:mm a');
		locale_map.put('en_BM', 'M/d/yyyy h:mm a');
		locale_map.put('en_CA', 'dd/MM/yyyy h:mm a');
		locale_map.put('en_GB', 'dd/MM/yyyy HH:mm');
		locale_map.put('en_GH', 'M/d/yyyy h:mm a');
		locale_map.put('en_ID', 'M/d/yyyy h:mm a');
		locale_map.put('en_IE', 'dd/MM/yyyy HH:mm');
		locale_map.put('en_IE_EURO', 'dd/MM/yyyy HH:mm');
		locale_map.put('en_NZ', 'd/MM/yyyy HH:mm');
		locale_map.put('en_SG', 'M/d/yyyy h:mm a');
		locale_map.put('en_US', 'M/d/yyyy h:mm a');
		locale_map.put('en_ZA', 'yyyy/MM/dd hh:mm a');
		locale_map.put('es', 'd/MM/yyyy H:mm');
		locale_map.put('es_AR', 'dd/MM/yyyy HH:mm');
		locale_map.put('es_BO', 'dd-MM-yyyy hh:mm a');
		locale_map.put('es_CL', 'dd-MM-yyyy hh:mm a');
		locale_map.put('es_CO', 'd/MM/yyyy hh:mm a');
		locale_map.put('es_CR', 'dd/MM/yyyy hh:mm a');
		locale_map.put('es_EC', 'dd/MM/yyyy hh:mm a');
		locale_map.put('es_ES', 'd/MM/yyyy H:mm');
		locale_map.put('es_ES_EURO', 'd/MM/yyyy H:mm');
		locale_map.put('es_GT', 'd/MM/yyyy hh:mm a');
		locale_map.put('es_HN', 'MM-dd-yyyy hh:mm a');
		locale_map.put('es_MX', 'd/MM/yyyy hh:mm a');
		locale_map.put('es_PE', 'dd/MM/yyyy hh:mm a');
		locale_map.put('es_PR', 'MM-dd-yyyy hh:mm a');
		locale_map.put('es_PY', 'dd/MM/yyyy hh:mm a');
		locale_map.put('es_SV', 'MM-dd-yyyy hh:mm a');
		locale_map.put('es_UY', 'dd/MM/yyyy hh:mm a');
		locale_map.put('es_VE', 'dd/MM/yyyy hh:mm a');
		locale_map.put('et_EE', 'd.MM.yyyy H:mm');
		locale_map.put('fi', 'd.M.yyyy H:mm');
		locale_map.put('fi_FI', 'd.M.yyyy H:mm');
		locale_map.put('fi_FI_EURO', 'd.M.yyyy H:mm');
		locale_map.put('fr', 'dd/MM/yyyy HH:mm');
		locale_map.put('fr_BE', 'd/MM/yyyy H:mm');
		locale_map.put('fr_CA', 'yyyy-MM-dd HH:mm');
		locale_map.put('fr_CH', 'dd.MM.yyyy HH:mm');
		locale_map.put('fr_FR', 'dd/MM/yyyy HH:mm');
		locale_map.put('fr_FR_EURO', 'dd/MM/yyyy HH:mm');
		locale_map.put('fr_LU', 'dd/MM/yyyy HH:mm');
		locale_map.put('fr_MC', 'dd/MM/yyyy HH:mm');
		locale_map.put('hr_HR', 'yyyy.MM.dd HH:mm');
		locale_map.put('hu', 'yyyy.MM.dd. H:mm');
		locale_map.put('hy_AM', 'M/d/yyyy h:mm a');
		locale_map.put('is_IS', 'd.M.yyyy HH:mm');
		locale_map.put('it', 'dd/MM/yyyy H.mm');
		locale_map.put('it_CH', 'dd.MM.yyyy HH:mm');
		locale_map.put('it_IT', 'dd/MM/yyyy H.mm');
		locale_map.put('iw', 'HH:mm dd/MM/yyyy');
		locale_map.put('iw_IL', 'HH:mm dd/MM/yyyy');
		locale_map.put('ja', 'yyyy/MM/dd H:mm');
		locale_map.put('ja_JP', 'yyyy/MM/dd H:mm');
		locale_map.put('kk_KZ', 'M/d/yyyy h:mm a');
		locale_map.put('km_KH', 'M/d/yyyy h:mm a');
		locale_map.put('ko', 'yyyy. M. d a h:mm');
		locale_map.put('ko_KR', 'yyyy. M. d a h:mm');
		locale_map.put('lt_LT', 'yyyy.M.d HH.mm');
		locale_map.put('lv_LV', 'yyyy.d.M HH:mm');
		locale_map.put('ms_MY', 'dd/MM/yyyy h:mm a');
		locale_map.put('nl', 'd-M-yyyy H:mm');
		locale_map.put('nl_BE', 'd/MM/yyyy H:mm');
		locale_map.put('nl_NL', 'd-M-yyyy H:mm');
		locale_map.put('nl_SR', 'd-M-yyyy H:mm');
		locale_map.put('no', 'dd.MM.yyyy HH:mm');
		locale_map.put('no_NO', 'dd.MM.yyyy HH:mm');
		locale_map.put('pl', 'yyyy-MM-dd HH:mm');
		locale_map.put('pt', 'dd-MM-yyyy H:mm');
		locale_map.put('pt_AO', 'dd-MM-yyyy H:mm');
		locale_map.put('pt_BR', 'dd/MM/yyyy HH:mm');
		locale_map.put('pt_PT', 'dd-MM-yyyy H:mm');
		locale_map.put('ro_RO', 'dd.MM.yyyy HH:mm');
		locale_map.put('ru', 'dd.MM.yyyy H:mm');
		locale_map.put('sk_SK', 'd.M.yyyy H:mm');
		locale_map.put('sl_SI', 'd.M.y H:mm');
		locale_map.put('sv', 'yyyy-MM-dd HH:mm');
		locale_map.put('sv_SE', 'yyyy-MM-dd HH:mm');
		locale_map.put('th', 'M/d/yyyy h:mm a');
		locale_map.put('th_TH', 'd/M/yyyy, H:mm ?.');
		locale_map.put('tr', 'dd.MM.yyyy HH:mm');
		locale_map.put('ur_PK', 'M/d/yyyy h:mm a');
		locale_map.put('vi_VN', 'HH:mm dd/MM/yyyy');
		locale_map.put('zh', 'yyyy-M-d ah:mm');
		locale_map.put('zh_CN', 'yyyy-M-d ah:mm');
		locale_map.put('zh_HK', 'yyyy-M-d ah:mm');
		locale_map.put('zh_TW', 'yyyy/M/d a h:mm');
		return locale_map; //return the map
	}
    
}