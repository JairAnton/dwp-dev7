global class statusAssistantButtons implements dwp_dbpn.DynamicButtonsStatusInterface {//yulino 27/11/2018 : se quitó global

    Global static Set<String> getDynamicButtonStatus(String recordId, String sObjectName)
    {
        Set<String> buttonsStatusSet = new Set<String>();
        List<Profile> lstProfile = [SELECT Id, Name FROM Profile WHERE Id = :UserInfo.getProfileId()];
        if(lstProfile[0].Name=='Ejecutivo' || lstProfile[0].Name=='Administrador del sistema' || lstProfile[0].Name=='System Administrator'){
            buttonsStatusSet.add('btnAssistant');
        }
        return buttonsStatusSet;
    }
	
    public statusAssistantButtons(){//Yulino 27/11/2018 : se agregó el contructor
    }

}