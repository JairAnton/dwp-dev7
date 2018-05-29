global class ReevaluateButtonClass implements dwp_dbpn.DynamicFlowValidationInterface {


    global static List<String> getErrorMessagesList(String recordId, String source, String validationClass)
    {

        id id1 = userinfo.getProfileId();
        List<String> lstErrorMessage = new List<String>();
        String prof = [SELECT Name FROM profile WHERE id = :id1 LIMIT 1].Name;


       return lstErrorMessage;
    }


    @auraenabled
    public static void updateOpp(String Idopp){
        id id1 = userinfo.getProfileId();
        list<String > lstIds = new list<String>();
         lstIds.add(Idopp);
         Map<String,Set<String>> reevaluatePrice=  dwp_dace.DynamicActionsEngine_helper.getAvailableActions(lstIds,'Opportunity','SanctionPrice');
         Map<String,Set<String>> reevaluateRisk=  dwp_dace.DynamicActionsEngine_helper.getAvailableActions(lstIds,'Opportunity','PenalizeRisk');
       String prof = [SELECT Name FROM profile WHERE id = :id1 LIMIT 1].Name;
        if(prof=='Ejecutivo' || prof=='Administrador del Sistema' || prof=='Migracion'){
        Opportunity opp =[SELECT Id,opportunity_status_type__c FROM Opportunity WHERE Id =:  Idopp LIMIT 1];
         if(reevaluatePrice.get(Idopp).contains('Sanction Price') &&( prof=='Ejecutivo' || prof=='Administrador del Sistema'  || prof=='Migracion'))
          opp.opportunity_status_type__c=label.LblStatusResultbtnSanctionPrice;
           if(reevaluateRisk.get(Idopp).contains('Penalize Risk') && (prof=='Ejecutivo' || prof=='Administrador del Sistema'  || prof=='Migracion'))

        opp.opportunity_status_type__c=label.LblStatusResultbtnSanctionRisk;

        update opp;

        }

    }

}
