global class Assistant_ValidationClass implements dwp_dbpn.DynamicFlowValidationInterface {    
    global static List<String> getErrorMessagesList(String recordId, String source, String validationClass){
        list<String> lstErrorMessage = new List<String>();
        List<Profile> lstProfile = [SELECT Id, Name FROM Profile WHERE Id = :UserInfo.getProfileId()];
        if(lstProfile[0].Name == 'Ejecutivo'){
            if(recordId!=UserInfo.getUserId()){
                List<PermissionSetAssignment> lstPermissionSet = [SELECT    Id, 
                                                                            PermissionSet.Name,
                                                                            AssigneeId
                                                                FROM PermissionSetAssignment
                                                                WHERE PermissionSet.Name = 'Assistant_Teams_Management'
                                                                AND AssigneeId = :UserInfo.getUserId()];
                
                if(lstPermissionSet.isEmpty())lstErrorMessage.add('No tiene permiso para gestionar el equipo de asistentes para este ejecutivo'); 
            }
        }
        return lstErrorMessage;
    }
}