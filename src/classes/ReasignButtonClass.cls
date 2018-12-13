public without sharing class ReasignButtonClass {//yulino 11/12/2018 : Se agregó without sharing y contructor al final de la clase
    @AuraEnabled
    public static User start( Id recordId) {
        User lstUser = new User();
        try{
            Case cas = [Select Id, OwnerId from Case where Id =: recordId];
            
            lstUser = [Select id, Name from User where Id =: UserInfo.getUserId() AND Profile.Name =: Label.lblAnalistaProf AND  Id !=: cas.OwnerId];
        }catch(Exception e){
            return null;
        }
        return lstUser;
    }
    @AuraEnabled
    public static List <User> fetchUser(String searchKeyWord, Id recordId) {
        String searchKey = searchKeyWord + '%';
        Case cas = [Select Id, OwnerId from Case where Id =: recordId];
        List <User> returnList = new List <User> ();
        List <User> lstUser = [Select id, Name from User where Name LIKE: searchKey AND Profile.Name =: Label.lblAnalistaProf AND Id !=: cas.OwnerId AND IsActive = true order by Name DESC limit 5];
        
        for (User usr: lstUser) {
            returnList.add(usr);
        }
        return returnList;        
    }
    @auraenabled
    public static  Map<String,Object> reasignown (String IdCase, User recorduser){
        String genericError;
        Opportunity opp;
        List <OpportunityLineItem> lstOLI;
        Case cas = [Select Id, OwnerId, opportunity_id__c from Case where Id =: IdCase];
        User usr = [Select Id, user_id__c from User where Id = :recorduser.id];
        if(cas.opportunity_id__c != null){
             opp = [Select Id,StageName, opportunity_status_type__c, frm_ContractNumber__c, OwnerId From Opportunity where Id =:cas.opportunity_id__c];
        }
        if(opp != null){
			lstOLI = [Select Id, product_risk_approval_indicator__c, price_quote_status_id__c, product_price_approval_indicator__c, product_formalization_indicator__c, proposed_apr_per__c, price_quote_id__c, price_quote_owner_id__c, product_price_approval_method__c From OpportunityLineItem where OpportunityId =:opp.Id];
        }
        Map<String,Object> mapReturn = new Map<String,Object>();
        try{
            if(!lstOLI.isEmpty()){
                //Call a RECOVER Service One product            
                if (lstOLI[0].price_quote_id__c !='' && lstOLI[0].product_price_approval_method__c == 'Web'){
                    //helper to call the service
                    ModifyQuotationRequest_helper modifyHelper = new ModifyQuotationRequest_helper(opp.Id, 'REASSIGN',lstOLI[0].proposed_apr_per__c,opp.frm_ContractNumber__c, usr.user_id__c); 
                    //invoke the service
                    System.HttpResponse invoke = modifyHelper.invoke();
                    //get json body
                    ModifyQuotationRequest_helper.ResponseModifyQuotationRequest_Wrapper jbody = ModifyQuotationRequest_helper.responseParse(invoke.getBody());
                    switch on invoke.getStatusCode(){                        
                        when 200{
                            if(jbody.data != null && jbody.data.status != null){
                                lstOLI[0].price_quote_status_id__c = jbody.data.status.id;
                                update lstOLI;
                            }
                            if(jbody.data != null && jbody.data.businessAgents != null){
                                List <User> userList = [SELECT Id FROM User where user_id__c =: jbody.data.businessAgents[0].id];
                                if(!userList.isEmpty()){
                                    lstOLI[0].price_quote_owner_id__c = userList[0].Id;
                                }else{
                                    lstOLI[0].price_quote_owner_id__c = null;
                                }
                                update lstOLI;
                            }
                            cas.OwnerId = recorduser.Id;
                            update cas;
                            mapReturn.put('Updated','Updated');
                        } when 409{
                            WebServiceUtils.ResponseErrorMessage_Wrapper jerror = WebServiceUtils.parse(invoke.getBody());
                            genericError = jerror.errormessage;                        
                        } when else{                        
                            genericError = Label.GenericError;
                        }
                    }
                    
                }else{
                    cas.OwnerId = recorduser.Id;
                    update cas;
                    mapReturn.put('Updated','Updated');
                }
            }
            
        }catch(Exception e){
            genericError = e.getMessage();
        }
        mapReturn.put('genericError',genericError);
        return mapReturn;
    } 

    private ReasignButtonClass(){
    }   
}