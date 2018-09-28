/**
* @author Global_HUB developers
* @date 16-07-2018
*
* @group Global_HUB
*
* @description Controller class from Approve_cmp
**/
public class approveButtonClass {
    
    @auraenabled
    public static string start(Id recordId){
        /**
         *  @description Method to get Risk o Price from opportunity_status_type__c 
         *  @return String
         * */  
        list<string> IdsRecord = new list<string>();
        IdsRecord.add(recordId);
        string value;
        Opportunity opp = [Select Id,StageName, opportunity_status_type__c From Opportunity where Id =:recordId];
        if(opp.opportunity_status_type__c == '15'){
            value = 'Risk';
        } else if(opp.opportunity_status_type__c == '10'){
            value = 'Price';
        }
        return value;
    }
    
    
    @auraenabled
    public static Map<String,Object> approvePrice(String Id){
        /**
         *  @description Method to update the opportunity status to price approved and insert a Action Audit
         *  @return String
         * */ 
        Map<String,Object> mapReturn = new Map<String,Object>();
        mapReturn.put('isOk', true);
        try{
            List <dwp_cvad__Action_Audit__c> lstactionPrice = new List <dwp_cvad__Action_Audit__c>();
            opportunity opp  =[SELECT ID,opportunity_status_type__c,isProcess__c, (SELECT Id, product2.Type_of_quote__c, price_quote_status_id__c FROM OpportunityLineItems) FROM Opportunity WHERE ID =:Id];        
            opp.isProcess__c=true;
            opp.opportunity_status_type__c	='11';
            Boolean isOk = true;
            if(opp.OpportunityLineItems[0].product2.Type_of_quote__c == 'Web' && opp.OpportunityLineItems[0].price_quote_status_id__c == 'MODIFIED'){
                ModifyQuotationRequest_helper modifyHelper = new ModifyQuotationRequest_helper(Id,'GENERATE_QUOTATION_SHEET',null,'',null);
                try{
                    System.HttpResponse invokeModify = modifyHelper.invoke();
                    switch on invokeModify.getStatusCode(){
                        when 200 {
                            ModifyQuotationRequest_helper.ResponseModifyQuotationRequest_Wrapper responseBody = ModifyQuotationRequest_helper.responseParse(invokeModify.getBody());
                            ModifyQuotationRequest_helper.Response_data mqData = responseBody.data;
                            ModifyQuotationRequest_helper.Response_status mqStatus = mqData.status;
                            
                            OpportunityLineItem oliRecord = new OpportunityLineItem();
                            oliRecord.Id = opp.OpportunityLineItems[0].Id;
                            oliRecord.price_quote_status_id__c = mqStatus.id;

                            List<ModifyQuotationRequest_helper.Response_businessAgents> mqBusinessAgentsList = mqData.businessAgents;
                            
                            if(!mqBusinessAgentsList.isEmpty()){
                                List<User> userList = [SELECT Id FROM User WHERE user_id__c = : mqBusinessAgentsList[0].id];
                                if(!userList.isEmpty()){
                                    oliRecord.price_quote_owner_id__c = userList[0].Id;
                                }else{
                                    oliRecord.price_quote_owner_id__c = null;
                                }
                            }
                            update oliRecord;

                        }
                        when 409{
                            WebServiceUtils.ResponseErrorMessage_Wrapper errorW = WebServiceUtils.parse(invokeModify.getBody());
                            isOk = false;
                            mapReturn.put('isOk', false);
                            mapReturn.put('errorMessage',Label.PriceApproveErrorKnow + ' ' + errorW.errormessage);
                        }
                        when else{
                            isOk = false;
                            mapReturn.put('isOk', false);
                            mapReturn.put('errorMessage',Label.PriceApproveErrorNotKnow);
                        }
                    }
                }catch(Exception e){
                    System.debug(e);
                    isOk = false;
                    mapReturn.put('isOk', false);
                    mapReturn.put('errorMessage',Label.PriceApproveErrorNotKnow);
                }
            }
            if(isOk){
                update opp;
                lstactionPrice.add(Action_Audit_Helper.getAudit(label.PriceApproval, 'Opportunity', opp.Id, DateTime.now(), label.AuditPriceApproval, UserInfo.getUserId(), label.AuditStyleApproveTop, '', false));
                insert lstactionPrice; 
            }
            return mapReturn;

        }catch(Exception e){
            mapReturn.put('isOk', false);
            mapReturn.put('errorMessage',e.getMessage());
            return mapReturn;
        }
        
    }
    
    @auraenabled
    public static String approveRisk(String Id){
        /**
         *  @description Method to update the opportunity status to Risk approved and insert a Action Audit
         *  @return String
         * */
        try{            
            
            List <dwp_cvad__Action_Audit__c> lstactionRisk = new List <dwp_cvad__Action_Audit__c>();
            opportunity opp  =[SELECT ID,opportunity_status_type__c,isProcess__c FROM Opportunity WHERE ID =:Id];
            opp.isProcess__c=true;
            opp.opportunity_status_type__c	='17';
            update opp;
            lstactionRisk.add(Action_Audit_Helper.getAudit(label.RiskApproval, 'Opportunity', opp.Id, DateTime.now(), label.AuditRiskApproval, UserInfo.getUserId(), label.AuditStyleApproveTop, opp.sio_code__c, false));
            insert lstactionRisk;
            
            return 'Updated';
            
        }catch(Exception e){
            return e.getMessage();
        }
    }
    
}