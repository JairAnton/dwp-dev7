/**
* @author Global_HUB developers
* @date 17-07-2018
*
* @group Global_HUB
*
* @description Controller class from reevaluateButton_cmp
**/
public class ReevaluateButtonClass {
    private static boolean risk;
    private static boolean price;
    
    @auraenabled
    public static Map<String,Object> start (String Idopp){
        /**
        *  @description Method to get Risk o Price from opportunity_status_type__c to put a button Risk, Price or both buttons
        *  @return String
        * */  
        String msg, genericError;
        Opportunity opp = [Select Id,StageName, opportunity_status_type__c, frm_ContractNumber__c, OwnerId From Opportunity where Id =:Idopp];
        List <OpportunityLineItem> lstOLI = [Select Id, product_risk_approval_indicator__c, price_quote_status_id__c, product_price_approval_indicator__c, product_formalization_indicator__c, proposed_apr_per__c, price_quote_id__c, price_quote_owner_id__c, product_price_approval_method__c From OpportunityLineItem where OpportunityId =:Idopp];
        Map<String,Object> mapReturn = new Map<String,Object>();
        try{
            if(!lstOLI.isEmpty()){
                //Call a RECOVER Service One product            
                if (lstOLI[0].price_quote_id__c !='' && lstOLI[0].product_price_approval_method__c == 'Web' && (opp.opportunity_status_type__c == '11' || opp.opportunity_status_type__c == '13' || opp.opportunity_status_type__c == '10' || opp.opportunity_status_type__c == '08' || opp.opportunity_status_type__c == '20')){
                    //helper to call the service
                    ModifyQuotationRequest_helper modifyHelper = new ModifyQuotationRequest_helper(opp.Id, 'RECOVER',lstOLI[0].proposed_apr_per__c,opp.frm_ContractNumber__c, null); 
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
                        } when 409{
                            WebServiceUtils.ResponseErrorMessage_Wrapper jerror = WebServiceUtils.parse(invoke.getBody());
                            genericError = jerror.errormessage;                        
                        } when else{                        
                            genericError = Label.GenericError;
                        }
                    }
                }
                if(opp.StageName == '04'){
                    if((opp.opportunity_status_type__c == '16' || opp.opportunity_status_type__c == '17' || opp.opportunity_status_type__c == '18' || opp.opportunity_status_type__c == '15' || opp.opportunity_status_type__c == '14')&&(lstOLI[0].product_risk_approval_indicator__c == true)){
                        msg = 'Risk';
                    }else if((opp.opportunity_status_type__c == '13' || opp.opportunity_status_type__c == '10' || opp.opportunity_status_type__c == '11' || opp.opportunity_status_type__c == '08')&&(lstOLI[0].product_price_approval_indicator__c == true && lstOLI[0].product_risk_approval_indicator__c == false)){
                        msg = 'Price';
                    }else if((opp.opportunity_status_type__c == '13' || opp.opportunity_status_type__c == '10' || opp.opportunity_status_type__c == '11' || opp.opportunity_status_type__c == '08')&&(lstOLI[0].product_price_approval_indicator__c == true && lstOLI[0].product_risk_approval_indicator__c == true)){
                        msg = 'Both';
                    }
                }else if(opp.StageName == '05'){
                    if(opp.opportunity_status_type__c == '20' && (lstOLI[0].product_risk_approval_indicator__c == true && lstOLI[0].product_price_approval_indicator__c == true && lstOLI[0].product_formalization_indicator__c == true)){
                        msg = 'Both';                    
                    }else if(opp.opportunity_status_type__c == '20' && (lstOLI[0].product_risk_approval_indicator__c == true && lstOLI[0].product_price_approval_indicator__c == false && lstOLI[0].product_formalization_indicator__c == true)){
                        msg = 'Risk';
                    }else if(opp.opportunity_status_type__c == '20' && (lstOLI[0].product_risk_approval_indicator__c == false && lstOLI[0].product_price_approval_indicator__c == true && lstOLI[0].product_formalization_indicator__c == true)){
                        msg = 'Price';
                    }
                }
            }
        }catch(Exception e){
            genericError = e.getMessage();
        }
        mapReturn.put('msg',msg);
        mapReturn.put('genericError',genericError);
        return mapReturn;
    }
    
    @auraenabled
    public static string  setToRisk(String Idopp){
        /**
        *  @description Method to update the opportunity status to reevalute to risk and insert a Action Audit
        *  @return String
        * */ 
        List <dwp_cvad__Action_Audit__c> lstactionRisk = new List <dwp_cvad__Action_Audit__c>();
        Opportunity opp =[SELECT Id,opportunity_status_type__c, StageName, isProcess__c FROM Opportunity WHERE Id =: Idopp];
        try{
            opp.isProcess__c=true;
            opp.StageName='04';
            opp.opportunity_status_type__c='24';
            update opp;
            
            lstactionRisk.add(Action_Audit_Helper.getAudit(label.reevalRisk, 'Opportunity', opp.Id, DateTime.now(), label.AuditRiskApproval, UserInfo.getUserId(), label.restudyStyle, opp.sio_code__c, false));
            insert lstactionRisk;   
            
            return 'Updated';
        }catch(Exception e){
            return e.getMessage();
        }
    }
    
    @auraenabled
    public static string  setToPrice(String Idopp){
        /**
        *  @description Method to update the opportunity status to reevalute to price and insert a Action Audit
        *  @return String
        * */
        List <dwp_cvad__Action_Audit__c> lstactionPrice = new List <dwp_cvad__Action_Audit__c>();
        Opportunity opp =[SELECT Id,opportunity_status_type__c, StageName, isProcess__c FROM Opportunity WHERE Id =: Idopp];
        try{
            opp.isProcess__c=true;
            opp.StageName='04';
            opp.opportunity_status_type__c='12';
            update opp;
            
            lstactionPrice.add(Action_Audit_Helper.getAudit(label.reevalPrice, 'Opportunity', opp.Id, DateTime.now(), label.AuditPriceApproval, UserInfo.getUserId(), label.restudyStyle, '', false));
            insert lstactionPrice;
            
            return 'Updated';
        }catch(Exception e){
            return e.getMessage();
        }
    }
    
    
    
}