/*-------------------------------------------------------------------------
* Name: Product_cls
* Description : Class to insert a record from Account
* Created date : May 15 2018
* Developer name: Isaías Velázquez Cortés Indra(México)
--------------------------------------------------------------------------*/

public without sharing class Product_cls {
    /*Description
    Comments to describe the functionality of this method
    */
    @AuraEnabled public static List<OpportunityLineItem> getIdProductByOpportunity(String IdOpportunity){
        List<OpportunityLineItem> row= [SELECT  cancellation_fee_per__c,price_quote_id__c,Product2Id,gipr_Tipo_Garantia__c,gipr_Garantia__c,Product2.Type_of_quote__c,price_quote_date__c,Product2.Name,Opportunity.Amount,gipr_Plazo__c,toLabel(gipr_Periodicidad__c),proposed_apr_per__c,spread_per__c,proposed_fee_per__c, restructuring_fee_per__c  FROM OpportunityLineItem Where OpportunityId=: IdOpportunity LIMIT 1];
            return row.isEmpty()? new List<OpportunityLineItem>(): row;
    }
    /*Description
    Comments to describe the functionality of this method
    */
    @AuraEnabled public static Boolean verifyIfHasQuoted(String IdOpportunity){
        List<OpportunityLineItem> rowOpp=getIdProductByOpportunity(IdOpportunity);
        if(!rowOpp.isEmpty() && rowOpp[0].price_quote_date__c!=null && String.valueOf(rowOpp[0].price_quote_date__c)!='')//Yulino 28/11/2018 : Optimizando el if anidado
        {
            return true;//if(rowOpp[0].price_quote_date__c!=null && String.valueOf(rowOpp[0].price_quote_date__c)!='') return true; else return false;
        }else return false;
    }
    /*Description
    Comments to describe the functionality of this method
    */
    @AuraEnabled public static List<fprd__GBL_guarantee__c> getGuaranteeDataByProduct(String IdOpportunity,String IdProduct){   
        //List<fprd__GBL_guarantee__c> objData= [SELECT Id,guarantee_type__c,toLabel(guarantee_desc__c), toLabel(guarantee_modality_type__c), toLabel(guarantee_status_type__c),guarantee_term_number__c, toLabel(guarantee_periodicity_type__c),guarantee_id__c,guaranteed_amount__c,isMaster__c FROM fprd__GBL_guarantee__c Where fprd__GBL_Opportunity_product__c=: IdOpportunity Order by isMaster__c desc];
        return [SELECT Id,guarantee_type__c,toLabel(guarantee_desc__c), toLabel(guarantee_modality_type__c), toLabel(guarantee_status_type__c),guarantee_term_number__c, toLabel(guarantee_periodicity_type__c),guarantee_id__c,guaranteed_amount__c,isMaster__c FROM fprd__GBL_guarantee__c Where fprd__GBL_Opportunity_product__c=: IdOpportunity Order by isMaster__c desc]; //yulino 28/11/2018 : Optimizado
    }
    /*Description
    Comments to describe the functionality of this method
    */
    @AuraEnabled public static List<fprd__GBL_Guarantee__c> getGuaranteeDataByProductValues(String PGuaranteeId){   
        //yulino 28/11/2018 : Comentado, se optimizó en el return
        //List<fprd__GBL_guarantee__c> objData= [SELECT Id,guarantee_type__c,guarantee_desc__c, guarantee_modality_type__c, guarantee_status_type__c,guarantee_term_number__c, guarantee_periodicity_type__c,guarantee_id__c,guaranteed_amount__c,isMaster__c FROM fprd__GBL_guarantee__c Where Id=: PGuaranteeId];
        return [SELECT Id,guarantee_type__c,guarantee_desc__c, guarantee_modality_type__c, guarantee_status_type__c,guarantee_term_number__c, guarantee_periodicity_type__c,guarantee_id__c,guaranteed_amount__c,isMaster__c FROM fprd__GBL_guarantee__c Where Id=: PGuaranteeId];
    }
    /*Description
    Comments to describe the functionality of this method
    */
    @AuraEnabled public static List<fprd__GBL_Intervener__c> getParticipantDataByProduct(String IdOpportunity,String IdProduct){    
        //List<fprd__GBL_Intervener__c> objData= [SELECT Id,Name,toLabel(fiscal_identifier_type__c), toLabel(guarantor_marital_status_type__c), toLabel(participant_type__c),taxpayer_id__c,main_intervener__c FROM fprd__GBL_Intervener__c Where fprd__GBL_Opportunity_product__c=: IdOpportunity Order by main_intervener__c desc];
        return  [SELECT Id,Name,toLabel(fiscal_identifier_type__c), toLabel(guarantor_marital_status_type__c), toLabel(participant_type__c),taxpayer_id__c,main_intervener__c FROM fprd__GBL_Intervener__c Where fprd__GBL_Opportunity_product__c=: IdOpportunity Order by main_intervener__c desc]; //yulino 28/11/2018 : Comentado, se optimizó en el return
    }
    /*Description
    Comments to describe the functionality of this method
    */
    @AuraEnabled public static List<fprd__GBL_Intervener__c> getParticipantDataByProductValues(String PParticipantId){  
        //List<fprd__GBL_Intervener__c> objData= [SELECT Id,Name,fiscal_identifier_type__c, guarantor_marital_status_type__c, participant_type__c,taxpayer_id__c,main_intervener__c FROM fprd__GBL_Intervener__c Where  Id=: PParticipantId];
        return [SELECT Id,Name,fiscal_identifier_type__c, guarantor_marital_status_type__c, participant_type__c,taxpayer_id__c,main_intervener__c FROM fprd__GBL_Intervener__c Where  Id=: PParticipantId]; //yulino 28/11/2018 : Comentado, se optimizó en el return
    }
    @AuraEnabled public static List<OpportunityLineItem> getOpportunityLineItemDataByProduct(String IdOpportunity,String IdProduct){    
        //List<OpportunityLineItem> objData= [SELECT Product2.Name,Opportunity.Amount,gipr_Plazo__c,toLabel(gipr_Periodicidad__c),proposed_apr_per__c,spread_per__c,proposed_fee_per__c  FROM OpportunityLineItem Where OpportunityId=:IdOpportunity and Product2Id=:IdProduct];
        return [SELECT Product2.Name,Opportunity.Amount,gipr_Plazo__c,toLabel(gipr_Periodicidad__c),proposed_apr_per__c,spread_per__c,proposed_fee_per__c  FROM OpportunityLineItem Where OpportunityId=:IdOpportunity and Product2Id=:IdProduct]; //yulino 28/11/2018 : Comentado, se optimizó en el return
    }
    @AuraEnabled public static String getOportunidadSytem(String Filtro) {       
        return Object_Controller.getOportunidadSytem(Filtro);       
    }
    @AuraEnabled public static Boolean deleteGuaranteeDataByProduct(String IdProductGuarantee){
        fprd__GBL_Guarantee__c objData= [SELECT Id FROM fprd__GBL_Guarantee__c Where Id=: IdProductGuarantee];
        delete objDAta;
        return true;
    }
    @AuraEnabled public static Boolean deleteParticipantDataByProduct(String IdProductParticipant){
        fprd__GBL_Intervener__c objData= [SELECT Id FROM fprd__GBL_Intervener__c Where Id=: IdProductParticipant];
        delete objDAta;
        return true;
    }
    @AuraEnabled public static Boolean saveGuaranteeDataByProduct(String PGuaranteeId,String IdOpportunity,String IdProuduct,String GuaranteeType,String Guarantee,String Modality,Decimal Amount,String Status,Integer Term,String Periodicity,Integer nGuarantee){
        try
        {     
            List<Opportunity> isAuth = [select id from Opportunity  where OwnerId=:UserInfo.getUserId() and Id=:IdOpportunity Limit 1];
            if(!isAuth.isEmpty())
            {
                fprd__GBL_Guarantee__c row;
                if(PGuaranteeId!=null)      
                    row = [SELECT Id,guarantee_type__c,guarantee_desc__c, guarantee_modality_type__c, guarantee_status_type__c,guarantee_term_number__c, guarantee_periodicity_type__c,guarantee_id__c,guaranteed_amount__c FROM fprd__GBL_guarantee__c Where Id=: PGuaranteeId];
                else row = new fprd__GBL_guarantee__c();
                row.fprd__GBL_Opportunity_product__c=IdOpportunity;
                row.guarantee_type__c=GuaranteeType;
                row.guarantee_desc__c=Guarantee;
                row.guarantee_id__c=nGuarantee;
                row.guarantee_modality_type__c=Modality;
                if(Amount!=null) row.guaranteed_amount__c=Amount;
                if(Status!=null) row.guarantee_status_type__c=Status;
                row.guarantee_periodicity_type__c=Periodicity;
                row.guarantee_term_number__c=Term;
                if(PGuaranteeId!=null) update row; else insert row; 
                return true;
            }
            else return false;
        }
        catch(Dmlexception exp)
        {
            System.debug(exp.getMessage());
            return false;
        }
    }
    @AuraEnabled public static Boolean saveParticipantDataByProduct(String PParticipantId,String IdOpportunity,String IdProuduct,String Name,String DOI,String N_DOI,String Participation,String Marital_Status){
        List<Opportunity> isAuth = [select id from Opportunity  where OwnerId=:UserInfo.getUserId() and Id=:IdOpportunity Limit 1];
        if(!isAuth.isEmpty())
        {
            fprd__GBL_Intervener__c row;
            if(PParticipantId!=null)        
                row = [SELECT Id,Name,fiscal_identifier_type__c, guarantor_marital_status_type__c, participant_type__c,taxpayer_id__c FROM fprd__GBL_Intervener__c Where Id=:PParticipantId ];
            else row = new fprd__GBL_Intervener__c();
            row.fprd__GBL_Opportunity_product__c=IdOpportunity;
            row.Name=Name;
            row.fiscal_identifier_type__c=DOI;
            row.taxpayer_id__c=N_DOI;
            row.participant_type__c=Participation;      
            row.guarantor_marital_status_type__c=Marital_Status;        
            if(PParticipantId!=null) update row; else insert row;   
            return true;
        }
        else return false;
    }
    @AuraEnabled public static String setSanctionPrice(String OpportunityId,String sanAction,String Comments){
        try
        {
            List<Opportunity> itemOpp= [SELECT Id,opportunity_status_type__c FROM Opportunity WHERE Id=: OpportunityId];
            if(!itemOpp.isEmpty())
            {
                List<OpportunityLineItem> itemOppProduct= getIdProductByOpportunity(itemOpp[0].Id);
                if(sanAction=='btnApprove'){//08
                    itemOpp[0].StageName='04';
                    itemOpp[0].opportunity_status_type__c='08';
                }
                else if(sanAction=='btnRaise'){//09
                    itemOpp[0].StageName='04';
                    if(itemOppProduct[0].Product2.Type_of_quote__c =='COTIZA Beta'){ itemOpp[0].opportunity_status_type__c='10';}
                    else{itemOpp[0].opportunity_status_type__c='09';}    
                }
                update itemOpp[0];
                //BEGIN Traceability - 2018-06-11
                //Isaías Vellázquez Cortés
                if(sanAction=='btnApprove') new OpportunityTraceability_cls().addOpportunityTraceability(getStatusLabel(itemOpp[0].opportunity_status_type__c),TraceabilityMessage(itemOpp[0].Id,itemOpp[0].opportunity_status_type__c,Comments,''),'Opportunity',itemOpp[0].Id,'approve','TRSP00001',UserInfo.getUserId(),'embedded',1,true);              
                else if(sanAction=='btnRaise')  new OpportunityTraceability_cls().addOpportunityTraceability(getStatusLabel(itemOpp[0].opportunity_status_type__c),TraceabilityMessage(itemOpp[0].Id,itemOpp[0].opportunity_status_type__c,Comments,''),'Opportunity',itemOpp[0].Id,'elevate','TRSP00001',UserInfo.getUserId(),'embedded',1,true);          
                //END Traceability
                return 'true';
            }else{return 'Error';}
        }
        catch(Dmlexception exp) { return exp.getMessage();}
    }
    @AuraEnabled public static String setFormalization(String OpportunityId,String Action,String Body,String AttachedFiles){
        try
        {   
            List<Opportunity> itemOpp= [SELECT Id,opportunity_status_type__c,Name,OwnerId FROM Opportunity WHERE Id=: OpportunityId];
            if(!itemOpp.isEmpty())
            {
                if(Action=='btnApprove'){
                        itemOpp[0].IsProcess__c=true;
                        update itemOpp[0];   
                        itemOpp[0].StageName=label.lblFormalizarEtapa;
                        itemOpp[0].opportunity_status_type__c=label.lblFormalizarStatus;          
                        FeedItem post = new FeedItem();
                        post.ParentId = OpportunityId;
                        post.Body = body;
                        if(!string.isBlank(Body))
                            insert post;
                        else{
                            itemOpp[0].IsProcess__c=false;
                            update itemOpp[0];     
                            return label.lblNoCommentsFormalization;
                        }
                }
                update itemOpp[0];
                itemOpp[0].IsProcess__c=false;
                update itemOpp[0]; 
                //update itemOpp[0];
                //BEGIN Traceability - 2018-06-11
                //Isaías Vellázquez Cortés
                new OpportunityTraceability_cls().addOpportunityTraceability(getStatusLabel(itemOpp[0].opportunity_status_type__c),TraceabilityMessage(itemOpp[0].Id,itemOpp[0].opportunity_status_type__c,Body,AttachedFiles),'Opportunity',itemOpp[0].Id,'approve','TRFO00001',UserInfo.getUserId(),'embedded',1,true);
                //END Traceability
                return 'true';
            }
            else return 'Error';
        }
        catch(Dmlexception exp)
        {
            return exp.getMessage();
        }
    }
    @AuraEnabled public static Map<String,Object> setLastFormalization(String OpportunityId,String Action,String Body,String ContractNumber){   
        Map<String,Object> returnMap = new Map<String,Object>();
        try
        {            
            List<Opportunity> itemOpp= [SELECT Id,opportunity_status_type__c,Name,OwnerId, (SELECT Id, product2.type_of_quote__c FROM OpportunityLineItems) FROM Opportunity WHERE Id=: OpportunityId];
            if(Pattern.matches('[0-9]{4}-[0-9]{4}-[0-9]{10}', ContractNumber) || String.isEmpty(ContractNumber) )
            {
                if(Action=='btnApprove'){//08
                    itemOpp[0].StageName='06';
                    itemOpp[0].opportunity_status_type__c='23';
                    if(itemOpp[0].OpportunityLineItems[0].product2.type_of_quote__c == 'Web'){
                        returnMap = disburseQuotation(itemOpp[0].id, ContractNumber);
                    }else{
                        returnMap.put('success',true);
                    }
                }
                else if(Action=='btnRaise'){//09
                    itemOpp[0].StageName='05';
                    itemOpp[0].opportunity_status_type__c='21';
                    returnMap.put('success',true);
                }
                else if(Action=='btnBack'){//09
                    itemOpp[0].StageName='05';
                    itemOpp[0].opportunity_status_type__c='20';
                    returnMap.put('success',true);
                }
                itemOpp[0].IsProcess__c = true;
                itemOpp[0].frm_ContractNumber__c = ContractNumber;
                if((Boolean)returnMap.get('success')){
                    update itemOpp[0];
                    //BEGIN Traceability - 2018-06-11
                    //Isaías Vellázquez Cortés              
                    if(Action=='btnApprove')    new OpportunityTraceability_cls().addOpportunityTraceability(getStatusLabel(itemOpp[0].opportunity_status_type__c),'<b>Número de contrato:</b> '+ContractNumber +'<br/>'+'<b>Comentarios:</b> '+Body,'Opportunity',itemOpp[0].Id,'approve','TRFO00001',UserInfo.getUserId(),'embedded',1,true);
                    else if(Action=='btnRaise') new OpportunityTraceability_cls().addOpportunityTraceability(getStatusLabel(itemOpp[0].opportunity_status_type__c),'<b>Comentarios:</b> '+Body,'Opportunity',itemOpp[0].Id,'elevate','TRFO00001',UserInfo.getUserId(),'embedded',1,true);
                    else if(Action=='btnBack')  new OpportunityTraceability_cls().addOpportunityTraceability(getStatusLabel(itemOpp[0].opportunity_status_type__c),'<b>Comentarios:</b> '+Body,'Opportunity',itemOpp[0].Id,'sendBack','TRFO00001',UserInfo.getUserId(),'embedded',1,true);
                    //END Traceability
                }
                returnMap.put('showErrorMessage',true);
            }else{
                returnMap.put('success',false);
                returnMap.put('showErrorMessage',false);
            }
        }catch(Dmlexception exp) {
            returnMap.put('success',false);
            returnMap.put('errorMessage',exp.getMessage());
            returnMap.put('showErrorMessage',true);
        }
        return returnMap;
    }
    /********************************************************************************************
	Method to request the quotation disbursement via WS
	*********************************************************************************************/
	public static Map<String,Object> disburseQuotation(String recordId, String contractNumber){
		Map<String,Object> resultMap = new Map<String,Object>();
		try{
			List<OpportunityLineItem> oppProductsList = [SELECT Id, price_quote_id__c, price_quote_status_id__c, price_quote_owner_id__c
														FROM OpportunityLineItem WHERE OpportunityId = :recordId];
			if(!oppProductsList.isEmpty()){
				// Check if there is a quotation linked to the opportunity
				if(oppProductsList[0].price_quote_id__c != '' && oppProductsList[0].price_quote_id__c != null){
                    // Call Web Service to register the quotation loss
					ModifyQuotationRequest_helper mqHelper = new ModifyQuotationRequest_helper(recordId, 'DISBURSE', null, contractNumber, null);
					HttpResponse mqResponse = mqHelper.invoke();
					//Check the ws response status
					Integer wsResponseStatusCode = mqResponse.getStatusCode();
					// Check if the response was successful
					if(wsResponseStatusCode == 200){
						// Get the response body
						ModifyQuotationRequest_helper.ResponseModifyQuotationRequest_Wrapper responseBody = ModifyQuotationRequest_helper.responseParse(mqResponse.getBody());
						// Update the quoation status and owner
						ModifyQuotationRequest_helper.Response_data mqData = responseBody.data;
						ModifyQuotationRequest_helper.Response_status mqStatus = mqData.status;
						oppProductsList[0].price_quote_status_id__c = mqStatus.id;
						List<ModifyQuotationRequest_helper.Response_businessAgents> mqBusinessAgentsList = mqData.businessAgents;
						if(!mqBusinessAgentsList.isEmpty()){
							List<User> userList = [SELECT Id FROM User WHERE user_id__c = : mqBusinessAgentsList[0].id];
							if(!userList.isEmpty()){
								oppProductsList[0].price_quote_owner_id__c = userList[0].Id;
							}
						}
                        else{
                            oppProductsList[0].price_quote_owner_id__c = null;
                        }
						update oppProductsList[0];
						resultMap.put('success',true);
					}
					else if(wsResponseStatusCode == 409){
						resultMap.put('success',false);
						WebServiceUtils.ResponseErrorMessage_Wrapper errorDetails = WebServiceUtils.parse(mqResponse.getBody());
						// Set the error message
						String errorMessage = Label.PriceDisburseQuotationKnowError + ' ' + errorDetails.errormessage;
						resultMap.put('errorMessage',errorMessage);
					}
					else{
						resultMap.put('success',false);
						String errorMessage = Label.PriceDisburseQuotationUnknowError;
						resultMap.put('errorMessage',errorMessage);
					}
				}
				else{
					resultMap.put('success',true);
				}
			}
		}
		catch(Exception e){
			resultMap.put('success',false);
			String errorMessage = Label.PriceDisburseQuotationUnknowError;
			resultMap.put('errorMessage',errorMessage);
		}
		return resultMap;
	}
    /*Dismiss oportunity Method*/
    @AuraEnabled public static Map<String,Object> setRejectOpportunity(String OpportunityId,String RejectReason,String WinnerBank,String IsoCurrency,Decimal Amount,Decimal Rate,Integer Term,String Comments){
        Map<String,Object> resultMap = new Map<String,Object>();
        resultMap.put('success','true');
        try
        {
             List<Opportunity> itemOpp= [SELECT Id, StageName, opportunity_status_type__c, Loss_Reason__c, rejection_winner_entity_name__c,
                                        rejection_reason_id__c, rejection_amount__c, rejection_rate_per__c, rejection_period_num__c, rejection_coin__c
                                        FROM Opportunity WHERE Id=: OpportunityId];
            if(!itemOpp.isEmpty()){
                resultMap = registerQuotationLoss(OpportunityId, RejectReason, WinnerBank);
                if((String)resultMap.get('success') == 'true'){
                    // Update opportunity with the input data
                    itemOpp[0].IsProcess__c=true;
                    itemOpp[0].StageName = '07';
                    itemOpp[0].opportunity_status_type__c = '22';
                    itemOpp[0].Loss_Reason__c = RejectReason;
                    itemOpp[0].rejection_winner_entity_name__c = WinnerBank;
                    itemOpp[0].rejection_reason_id__c = Comments;
                    itemOpp[0].rejection_amount__c = Amount;
                    itemOpp[0].rejection_rate_per__c = Rate;
                    if(Term!=null) itemOpp[0].rejection_period_num__c = Term;
                    itemOpp[0].rejection_coin__c = IsoCurrency;
                    update itemOpp[0];
                }
            }
        }catch(Dmlexception exp) {
            resultMap.put('success','false');
            resultMap.put('errorMessage',exp.getMessage());
        }
        return resultMap;
    }
    // Method that invoke the ws to recover a quotationupdates the opportunity and opportunity line item with the response
    @auraenabled
    public static Map<String,Object> recoverQuotation(String recordId){
        Map<String,Object> mapReturn = new Map<String,Object>();
        mapReturn.put('success','true');
        List<OpportunityLineItem> oppProductList = [SELECT price_quote_status_id__c,
                                                        price_quote_owner_id__c,
                                                    	product_price_approval_method__c,
                                                        price_quote_id__c
                                                    FROM OpportunityLineItem
                                                    WHERE OpportunityId = :recordId];
        mapReturn.put('nextAction',true);
        if(!oppProductList.isEmpty()){
            if(oppProductList[0].price_quote_id__c != null && oppProductList[0].price_quote_id__c != '' && oppProductList[0].price_quote_owner_id__c != UserInfo.getUserId() && oppProductList[0].product_price_approval_method__c == 'Web'){
                mapReturn = Commitment_ctrl.invokeRecoverQuotation(recordId);
                mapReturn.put('nextAction',true);
                if((String) mapReturn.get('success') == 'false'){
                    mapReturn.put('nextAction',false);
                }
            }
        }
        return mapReturn;
    }
    /********************************************************************************************
    Method to register the quotation loss via WS
    *********************************************************************************************/
    public static Map<String,Object> registerQuotationLoss(String recordId, String rejectReason, String winnerEntity){    
        Map<String,Object> returnMap = new Map<String,Object>();
        returnMap.put('success','true');
        String rejectParams = rejectReason + ';' + winnerEntity;
        try{
            List<OpportunityLineItem> oppProductsList = [SELECT Id, price_quote_id__c, price_quote_status_id__c, price_quote_owner_id__c, product_price_approval_method__c
                                                        FROM OpportunityLineItem WHERE OpportunityId = :recordId];
            if(!oppProductsList.isEmpty()){
                // Check if there is a quotation linked to the opportunity
                if(oppProductsList[0].product_price_approval_method__c == 'Web' && oppProductsList[0].price_quote_id__c != '' && oppProductsList[0].price_quote_id__c != null){
                    // Call Web Service to register the quotation loss
                    ModifyQuotationRequest_helper mqHelper = new ModifyQuotationRequest_helper(recordId, 'REGISTER_LOSS', null, rejectParams, null);
                    HttpResponse mqResponse = mqHelper.invoke();
                    //Check the ws response status
                    Integer wsResponseStatusCode = mqResponse.getStatusCode();
                    // Check if the response was successful
                    if(wsResponseStatusCode == 200){
                        returnMap.put('success','true');
                        // Get the response body
                        ModifyQuotationRequest_helper.ResponseModifyQuotationRequest_Wrapper responseBody = ModifyQuotationRequest_helper.responseParse(mqResponse.getBody());
                        // Update the quoation status and owner
                        ModifyQuotationRequest_helper.Response_data mqData = responseBody.data;
                        ModifyQuotationRequest_helper.Response_status mqStatus = mqData.status;
                        oppProductsList[0].price_quote_status_id__c = mqStatus.id;
                        List<ModifyQuotationRequest_helper.Response_businessAgents> mqBusinessAgentsList = mqData.businessAgents;
                        if(!mqBusinessAgentsList.isEmpty()){
                            List<User> userList = [SELECT Id FROM User WHERE user_id__c = : mqBusinessAgentsList[0].id];
                            if(!userList.isEmpty()){
                                oppProductsList[0].price_quote_owner_id__c = userList[0].Id;
                            }
                        }
                        else{
                            oppProductsList[0].price_quote_owner_id__c = null;
                        }
                        update oppProductsList[0];
                    }
                    else if(wsResponseStatusCode == 409){
                       returnMap.put('success','false');
                       WebServiceUtils.ResponseErrorMessage_Wrapper errorDetails = WebServiceUtils.parse(mqResponse.getBody());
                       // Set the error message
					   String errorMessage = Label.PriceRegisterLossKnownError + ' ' + errorDetails.errormessage;
					   returnMap.put('errorMessage',errorMessage);
                    }
                    else{
                       returnMap.put('success','false');
                       String errorMessage = Label.PriceRegisterLossUnknownError;
					   returnMap.put('errorMessage',errorMessage);
                    }
                }
            }
        }
        catch(Exception e){
            returnMap.put('success','false');
            String errorMessage = Label.PriceRegisterLossUnknownError;
			returnMap.put('errorMessage',errorMessage);
        }
        return returnMap;
    }
    public static string TraceabilityMessage (String OpportunityId,String OppStatus,String Body,String AttachedFiles)
    {
        List<Opportunity> itemOpp= [SELECT Id,opportunity_status_type__c FROM Opportunity WHERE Id=: OpportunityId];
        List<OpportunityLineItem> itemOppProduct= getIdProductByOpportunity(itemOpp[0].Id);
        String HTMLComments='';
        if(OppStatus!='32')
        {//Yulino 27/11/2018 : se quitó String.valueOf() de algunos parametros
            HTMLComments = '<b>Producto:</b> ' + itemOppProduct[0].Product2.Name + '<br/>' +
                '<b>Importe:</b> '+ itemOppProduct[0].Opportunity.Amount +'<br/>' +
                '<b>Plazo:</b> '+itemOppProduct[0].gipr_Plazo__c +' '+ itemOppProduct[0].gipr_Periodicidad__c +'<br/>';  /// EN CASO DE QUE APLIQUE
            if(itemOppProduct[0].Product2.Type_of_quote__c=='COTIZADOR')
            {
                HTMLComments=HTMLComments+'<b>TEA propuesta (%):</b> '+itemOppProduct[0].proposed_apr_per__c+ '% <br/>' +
                    '<b>Comisión estructuración:</b> '+itemOppProduct[0].restructuring_fee_per__c +'% <br/>'+
                    '<b>Comisión Liquidacion Anticipada(%):</b> '+itemOppProduct[0].cancellation_fee_per__c+'% <br/>';
            }else if(itemOppProduct[0].Product2.Type_of_quote__c=='Web'){HTMLComments=HTMLComments+'<b>TEA propuesta (%):</b> '+itemOppProduct[0].proposed_apr_per__c + '% <br/>';  }
            else if(itemOppProduct[0].Product2.Type_of_quote__c=='Tarifario'){ HTMLComments=HTMLComments+'<b>Comisión Propuesta:</b> '+itemOppProduct[0].proposed_fee_per__c +'% <br/>';  }
            else if(itemOppProduct[0].Product2.Type_of_quote__c=='COTIZA Beta')
            {
                HTMLComments=HTMLComments+'<b>TEA Propuesta (%):</b> '+itemOppProduct[0].proposed_apr_per__c+'% <br/>'
                    +'<b>ID COTIZA:</b> '+itemOppProduct[0].price_quote_id__c+' <br/>';
            }
            HTMLComments =HTMLComments+'<b>Comentarios:</b> ' +Body;
        }
        else
        {
            HTMLComments = '<b>Producto:</b> ' + itemOppProduct[0].Product2.Name + '<br/>' +
                '<b>Importe:</b> '+ itemOppProduct[0].Opportunity.Amount +'<br/>' +
                '<b>Comentarios:</b> ' +Body+ '<br/><br/>'+
                '<b>Archivos adjuntos:</b> <br/>' +AttachedFiles;
        }
        return HTMLComments;
    }
    public static string getStatusLabel (String OppStatus)
    {
        list<Schema.PicklistEntry> PicklistEntries = Opportunity.opportunity_status_type__c.getDescribe().getPicklistValues();
        map<String,String> ApiToLabel = new map<String,String>();
        for (Schema.PicklistEntry pe : PicklistEntries){
            ApiToLabel.put(pe.getValue(),pe.getLabel());
        }
        return ApiToLabel.get(OppStatus);
    }
    /**
        Get BBVA Information Grouped Table
        Object: Account_BBVA_Information__c
    */
    @AuraEnabled public static List<WRP_Table> getAccountBBVAInformation (String AccountId)
    {
        list<AggregateResult> listInfoBBVA = [select account_id__r.Id Name,product_group_classification_id__c, type__c,MIN(account_id__r.bank_turnover_volume_amount__c)exp1,SUM(average_balance_amount__c)exp2 from Account_BBVA_Information__c where account_id__r.ParentId=:AccountId and (type__c = '01' OR type__c = '02') AND product_group_classification_id__c != '' and is_last_date__c = true group by account_id__r.id,product_group_classification_id__c, type__c];
        set<id> Ids= new set<id>();
        for(AggregateResult item : listInfoBBVA){ Ids.add((id)item.get('Name'));}
        list<Account> listAccNames= [select id,Name from Account where id in : Ids];
        string NameById='';
        map<String, WRP_Table> mapResult = new map<String, WRP_Table>();
        integer i=0;
        Double dd;
        Double di;
        Double r;
        String aux='';
        String Id_us='';
        for (AggregateResult ar : listInfoBBVA)  {
            dd=0;di=0;r=0;
                for (AggregateResult ar2 : listInfoBBVA)  {
                    if((String)ar2.get('Name')==(String)ar.get('Name'))
                        if((String)ar2.get('product_group_classification_id__c')==label.LblDirectDebt && (String)ar2.get('type__c')=='01')
                            dd=(Double)ar2.get('exp2');
                            else if((String)ar2.get('product_group_classification_id__c')==label.LblIndirectDebt && (String)ar2.get('type__c')=='01')
                                di=(Double)ar2.get('exp2');
                                else if((String)ar2.get('product_group_classification_id__c')==label.LblResources && (String)ar2.get('type__c')=='02')
                                    r=(Double)ar2.get('exp2');
                }
            if((string)ar.get('Name')!=aux){
                for(Account itemacc: listAccNames)
                {
                    if(ar.get('Name')==itemacc.id)
                        NameById=itemacc.Name;
                }
                mapResult.put(String.valueOf(i), new WRP_Table(NameById,(Double)ar.get('exp1'),dd,di,r,(string)ar.get('Name'))); aux=(string)ar.get('Name'); i++;
            }
        }
        return mapResult.values();
    }
    /**
     * Creation of a new Case status
     * */
    Public static void setnewCase(){
        
    }
    
    /**
        Creation of WRAPER Classs to the Position Grouped Table 
        Object: Account_BBVA_Information__c
    */
    public class WRP_Table{
        @AuraEnabled public String Acc {get; set;}
        @AuraEnabled public Double BusinessVolume  {get; set;}
        @AuraEnabled public Double DirectDebt  {get; set;}
        @AuraEnabled public Double IndirectDebt  {get; set;}
        @AuraEnabled public Double Resources   {get; set;}
        @AuraEnabled public String IdAcc   {get; set;}
        public WRP_Table(String toAcc, Double toBusinessVolume,Double toDirectDebt,Double toIndirectDebt,Double toResources,String toIdAcc){
            this.Acc = toAcc;
            this.BusinessVolume = toBusinessVolume;
            this.DirectDebt = toDirectDebt;
            this.IndirectDebt = toIndirectDebt;
            this.Resources = toResources;
            this.IdAcc = ToIdAcc;
        }
    }
    public Product_cls(){//Yulino 28/11/2018 : Se agregó el constructor privado
    }
}