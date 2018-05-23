global class ReevaluateButtonClass implements dwp_dbpn.DynamicFlowValidationInterface {
    
   
    global static List<String> getErrorMessagesList(String recordId, String source, String validationClass)
    {
        
        id id1 = userinfo.getProfileId();
        List<String> lstErrorMessage = new List<String>(); 
        String prof = [SELECT Name FROM profile WHERE id = :id1 LIMIT 1].Name;   
                   
        if(prof=='Ejecutivo' || prof=='System Administrator' || prof=='Migracion'){
       
        Opportunity opp =[SELECT Id,StageName FROM Opportunity WHERE Id =: recordId LIMIT 1];
        opp.reevaluate__c =true;
        update opp;    
        }
     
       return lstErrorMessage;     
    }

    
    
}