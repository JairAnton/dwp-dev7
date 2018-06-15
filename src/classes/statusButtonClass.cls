Global class statusButtonClass implements dwp_dbpn.DynamicButtonsStatusInterface {

    Global Set<String> getDynamicButtonStatus(String recordId, String sObjectName)
        {
            list<string> IdsRecord = new list<string>();
            IdsRecord.add(recordId);
            Map<String,Set<String>> PdfBtn=   dwp_dace.DynamicActionsEngine_helper.getAvailableActions(IdsRecord,'Opportunity','ButtonVisibility');
            Map<String,Set<String>> reevaluate=  dwp_dace.DynamicActionsEngine_helper.getAvailableActions(IdsRecord,'Opportunity','BtnReevaluate');
            Map<String,Set<String>> reevaluatePrice=  dwp_dace.DynamicActionsEngine_helper.getAvailableActions(IdsRecord,'Opportunity','BtnPrice');
            Map<String,Set<String>> reevaluateRisk=  dwp_dace.DynamicActionsEngine_helper.getAvailableActions(IdsRecord,'Opportunity','BtnRisk');
            Map<String,Set<String>> formalizate=  dwp_dace.DynamicActionsEngine_helper.getAvailableActions(IdsRecord,'Opportunity','Approvalformalization');

            Set<String> buttonsStatusSet = new Set<String>();
            id id1 = userinfo.getProfileId();

            String prof = [SELECT Name FROM profile WHERE id = :id1 LIMIT 1].Name;
            buttonsStatusSet.add('btnQuote');
            if(PdfBtn.get(recordId).contains('PDFBtn') &&(prof=='Operativo' || prof=='Administrador del Sistema' || prof=='Migracion'))
                 buttonsStatusSet.add('btnPDF');
            if(reevaluate.get(recordId).contains('ButtonReevaluateVisible') && (prof=='Ejecutivo' || prof=='Administrador del Sistema' || prof=='Migracion'))
                buttonsStatusSet.add('btnReevaluate');
            if(Formalizate.get(recordId).contains('formalizate') && (prof=='Ejecutivo' || prof=='Administrador del Sistema' || prof=='Migracion'))
                 buttonsStatusSet.add('btnFormalize');
            if(reevaluatePrice.get(recordId).contains('BtnPriceValue') &&( prof=='Ejecutivo' || prof=='Administrador del Sistema'  || prof=='Migracion'))
                 buttonsStatusSet.add('btnSanctionPrice');
            if(reevaluateRisk.get(recordId).contains('BtnRiskValue') && (prof=='Ejecutivo' || prof=='Administrador del Sistema'  || prof=='Migracion'))
                 buttonsStatusSet.add('btnPenalizeRisk');
            return buttonsStatusSet;
        }


}
