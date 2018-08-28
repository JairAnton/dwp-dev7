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
    public static String start (String Idopp){
        /**
         *  @description Method to get Risk o Price from opportunity_status_type__c to put a button Risk, Price or both buttons
         *  @return String
         * */  
        string msg;
        Opportunity opp = [Select Id,StageName, opportunity_status_type__c From Opportunity where Id =:Idopp];
        List <OpportunityLineItem> lstOLI = [Select Id, product_risk_approval_indicator__c, product_price_approval_indicator__c, product_formalization_indicator__c From OpportunityLineItem where OpportunityId =:Idopp];
        for(OpportunityLineItem oli : lstOLI){
            if(opp.StageName == '04'){
                if((opp.opportunity_status_type__c == '16' || opp.opportunity_status_type__c == '17' || opp.opportunity_status_type__c == '18' || opp.opportunity_status_type__c == '15' || opp.opportunity_status_type__c == '14')&&(oli.product_risk_approval_indicator__c == true)){
                    msg = 'Risk';
                }else if((opp.opportunity_status_type__c == '13' || opp.opportunity_status_type__c == '10' || opp.opportunity_status_type__c == '11' || opp.opportunity_status_type__c == '08')&&(oli.product_price_approval_indicator__c == true && oli.product_risk_approval_indicator__c == false)){
                    msg = 'Price';
                }else if((opp.opportunity_status_type__c == '13' || opp.opportunity_status_type__c == '10' || opp.opportunity_status_type__c == '11' || opp.opportunity_status_type__c == '08')&&(oli.product_price_approval_indicator__c == true && oli.product_risk_approval_indicator__c == true)){
                    msg = 'Both';
                }
            }else if(opp.StageName == '05'){
                if(opp.opportunity_status_type__c == '20' && (oli.product_risk_approval_indicator__c == true && oli.product_price_approval_indicator__c == true && oli.product_formalization_indicator__c == true)){
                    msg = 'Both';                    
                }else if(opp.opportunity_status_type__c == '20' && (oli.product_risk_approval_indicator__c == true && oli.product_price_approval_indicator__c == false && oli.product_formalization_indicator__c == true)){
                    msg = 'Risk';
                }else if(opp.opportunity_status_type__c == '20' && (oli.product_risk_approval_indicator__c == false && oli.product_price_approval_indicator__c == true && oli.product_formalization_indicator__c == true)){
                    msg = 'Price';
                }
            }            
            
        } 
        return msg;
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