global class Sanction_Price_Analist_ValidationClass implements dwp_dbpn.DynamicFlowValidationInterface {
    global static List<String> getErrorMessagesList(String recordId, String source ,  String validation){
        List<String> lstError = new List<String>();
        List<Profile> profileAdmin = [SELECT Id FROM Profile WHERE Name = :Label.profAdministrator]; 
        if(profileAdmin[0].Id != UserInfo.getProfileId()){
            List<Case> lstCases = [SELECT   Id, 
                                        opportunity_id__c, 
                                        IsClosed,
                                        OwnerId,
                                        Status
                                FROM Case 
                                WHERE opportunity_id__c = :recordId 
                                AND IsClosed = false];
            if(lstCases[0].OwnerId != UserInfo.getUserId()){
                lstError.add(Label.SanctionPriceAnalistValidationMessage);
            }
        }
        
        return lstError;
    }
}