/**approveButtonClass
*  object.
* <p /><p />
* Modification log:<p />
* -------------------------------------------------------------------
* Developer                    Date                Description<p />
* -------------------------------------------------------------------
* Julio Medellin               25/06/2018          Original version.<p />
*
* @author Julio Medellin
*/
public class approveButtonClass {


    @auraenabled
    public static string start(Id recordId){
        list<string> IdsRecord = new list<string>();
        IdsRecord.add(recordId);
        string value;
        Map<String,Set<String>> Risk=  dwp_dace.DynamicActionsEngine_helper.getAvailableActions(IdsRecord,'Opportunity','btnApprovalRisk');
        Map<String,Set<String>> Price=  dwp_dace.DynamicActionsEngine_helper.getAvailableActions(IdsRecord,'Opportunity','btnApprovalPrice');
        if(Risk.get(recordId).contains('ButtonApprovalRiskVisible'))
            value = 'Risk';
        if(Price.get(recordId).contains('ButtonApprovalPriceVisible'))
            value = 'Price';
        return value;

    }



    @auraenabled
    public static void approvePrice(String Id){
        opportunity opp  =[SELECT ID,opportunity_status_type__c,isProcess__c FROM Opportunity WHERE ID =:Id];
        opp.isProcess__c=true;
        opp.opportunity_status_type__c	='11';
        update opp;
        opp.isProcess__c=false;
        new OpportunityTraceability_cls().addOpportunityTraceability('Precio aprobado','Sancion de precio','Opportunity',Id,'approve','TRSP00001',UserInfo.getUserId(),'embedded',1,true);
        update opp;
    }

    @auraenabled
    public static void approveRisk(String Id){
        opportunity opp  =[SELECT ID,opportunity_status_type__c,isProcess__c FROM Opportunity WHERE ID =:Id];
        opp.isProcess__c=true;
        opp.opportunity_status_type__c	='47';
        update opp;
        opp.isProcess__c=false;
        update opp;
        new OpportunityTraceability_cls().addOpportunityTraceability('Riesgo aprobado','Sanción de riesgo','Opportunity',Id,'approve','TRSR00001',UserInfo.getUserId(),'embedded',1,true);

    }

}
