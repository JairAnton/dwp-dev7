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
    public static string start(String recordId){
      list<string> IdsRecord = new list<string>();
       IdsRecord.add(recordId);
      string value;
      Map<String,Set<String>> Price=  dwp_dace.DynamicActionsEngine_helper.getAvailableActions(IdsRecord,'Opportunity','btnApprovalRisk');
      Map<String,Set<String>> Risk=  dwp_dace.DynamicActionsEngine_helper.getAvailableActions(IdsRecord,'Opportunity','btnApprovalPrice');

      if(risk.get(recordId).contains('ButtonApprovalRiskVisible'))
          value = 'Risk';
       if(price.get(recordId).contains('ButtonApprovalPriceVisible'))
          value = 'Price';
        return value;

    }



@auraenabled
public static void approvePrice(String Id){

opportunity opp  =[SELECT ID FROM Opportunity];


}

@auraenabled
public static void approveRisk(String Id){

    opportunity opp  = [SELECT Id FROM Opportunity];

}

}
