Global class statusButtonClass implements dwp_dbpn.DynamicButtonsStatusInterface {

    Global Set<String> getDynamicButtonStatus(String recordId, String sObjectName)
        {
            list<string> IdsRecord = new list<string>();
            IdsRecord.add(recordId);
            Map<String,Set<String>> PdfBtn=   dwp_dace.DynamicActionsEngine_helper.getAvailableActions(IdsRecord,'Opportunity','ButtonVisibility');
            Map<String,Set<String>> reevaluatePrice=  dwp_dace.DynamicActionsEngine_helper.getAvailableActions(IdsRecord,'Opportunity','SanctionPrice');
            Map<String,Set<String>> reevaluateRisk=  dwp_dace.DynamicActionsEngine_helper.getAvailableActions(IdsRecord,'Opportunity','PenalizeRisk');
            Map<String,Set<String>> Formalizate=  dwp_dace.DynamicActionsEngine_helper.getAvailableActions(IdsRecord,'Opportunity','Approvalformalization');

            Set<String> buttonsStatusSet = new Set<String>();
            id id1 = userinfo.getProfileId();
            Opportunity opp =[SELECT Id,opportunity_status_type__c FROM Opportunity WHERE Id =:  recordId LIMIT 1];

            String prof = [SELECT Name FROM profile WHERE id = :id1 LIMIT 1].Name;
            buttonsStatusSet.add('btnQuote');
          //  if(PdfBtn.get(recordId).contains('PDFBtn') &&(prof=='Operativo' || prof=='Administrador del Sistema' || prof=='Migracion') && (!reevaluatePrice.get(recordId).contains('Sanction Price') &&  !reevaluateRisk.get(recordId).contains('Penalize Risk'))  )
                 buttonsStatusSet.add('btnPDF');
                buttonsStatusSet.add('btnReevaluate');
           // if(Formalizate.get(recordId).contains('formalizate') && (prof=='Ejecutivo' || prof=='Administrador del Sistema' || prof=='Migracion') && (!reevaluatePrice.get(recordId).contains('Sanction Price') &&  !reevaluateRisk.get(recordId).contains('Penalize Risk')) )
                 buttonsStatusSet.add('btnFormalize');
          //  if(reevaluatePrice.get(recordId).contains('Sanction Price') &&( prof=='Ejecutivo' || prof=='Administrador del Sistema'  || prof=='Migracion')){
                 buttonsStatusSet.add('btnSanctionPrice');
                 opp.opportunity_status_type__c=label.LblStatusResultbtnSanctionPrice;
            //  }
           // if(reevaluateRisk.get(recordId).contains('Penalize Risk') && (prof=='Ejecutivo' || prof=='Administrador del Sistema'  || prof=='Migracion')){
                 buttonsStatusSet.add('btnPenalizeRisk');
               opp.opportunity_status_type__c=label.LblStatusResultbtnSanctionRisk;
             // }
            update opp;
            return buttonsStatusSet;
        }


}
