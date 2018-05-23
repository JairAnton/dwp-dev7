Global class statusButtonClass implements dwp_dbpn.DynamicButtonsStatusInterface {
 
    Global Set<String> getDynamicButtonStatus(String recordId, String sObjectName)
        {
            list<string> IdsRecord = new list<string>();
            IdsRecord.add(recordId);
            Map<String,Set<String>> PdfBtn=   dwp_dace.DynamicActionsEngine_helper.getAvailableActions(IdsRecord,'Opportunity','ButtonVisibility');
            Map<String,Set<String>> reevaluate=  dwp_dace.DynamicActionsEngine_helper.getAvailableActions(IdsRecord,'Opportunity','Reevaluate');
            Map<String,Set<String>> reevaluate2=  dwp_dace.DynamicActionsEngine_helper.getAvailableActions(IdsRecord,'Opportunity','Reevaluate');
            Map<String,Set<String>> Formalizate=  dwp_dace.DynamicActionsEngine_helper.getAvailableActions(IdsRecord,'Opportunity','Reevaluate');

            
            Set<String> buttonsStatusSet = new Set<String>();
            id id1 = userinfo.getProfileId();
 
            String prof = [SELECT Name FROM profile WHERE id = :id1 LIMIT 1].Name;        
            if(PdfBtn.get(recordId).contains('PDFBtn') &&(prof=='Operativo' || prof=='Administrador del Sistema' || prof=='Migracion'))
                 buttonsStatusSet.add('btnPDF'); 
                 buttonsStatusSet.add('btnReevaluate');
            if(prof=='Ejecutivo' || prof=='Administrador del Sistema' || prof=='Migracion')
                 buttonsStatusSet.add('btnFormalize');
            if(prof=='Ejecutivo' || prof=='Administrador del Sistema'  || prof=='Migracion')
                 buttonsStatusSet.add('btnSanctionPrice');
             if(prof=='Ejecutivo' || prof=='Administrador del Sistema'  || prof=='Migracion')
                 buttonsStatusSet.add('btnPenalizeRisk');
            return buttonsStatusSet;
        }    
    
    
}