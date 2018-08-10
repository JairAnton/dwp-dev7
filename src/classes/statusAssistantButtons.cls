global class statusAssistantButtons implements dwp_dbpn.DynamicButtonsStatusInterface {

    Global Set<String> getDynamicButtonStatus(String recordId, String sObjectName)
    {
        Set<String> buttonsStatusSet = new Set<String>();
        List<Profile> lstProfile = [SELECT Id, Name FROM Profile WHERE Id = :UserInfo.getProfileId()];
        if(lstProfile[0].Name=='Ejecutivo' || lstProfile[0].Name=='Administrador del sistema' || lstProfile[0].Name=='System Administrator'){
            buttonsStatusSet.add('btnAssistant');
        }
        return buttonsStatusSet;
    }


}