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
    public static String approvePrice(String Id){
        /**
         *  @description Method to update the opportunity status to price approved and insert a Action Audit
         *  @return String
         * */ 
        try{            
            
            List <dwp_cvad__Action_Audit__c> lstactionPrice = new List <dwp_cvad__Action_Audit__c>();
            opportunity opp  =[SELECT ID,opportunity_status_type__c,isProcess__c FROM Opportunity WHERE ID =:Id];        
            opp.isProcess__c=true;
            opp.opportunity_status_type__c	='11';
            update opp;
            lstactionPrice.add(Action_Audit_Helper.getAudit(label.PriceApproval, 'Opportunity', opp.Id, DateTime.now(), label.AuditPriceApproval, UserInfo.getUserId(), label.AuditStyleApproveTop, '', false));
            insert lstactionPrice;
            
            return 'Updated';
            
        }catch(Exception e){
            return e.getMessage();
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