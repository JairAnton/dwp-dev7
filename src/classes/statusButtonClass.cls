/**statusButtonClass
*  object.
* <p /><p />
* Modification log:<p />
* -------------------------------------------------------------------
* Developer                    Date                Description<p />
* -------------------------------------------------------------------
* Julio Medellin               18/05/2018          Original version.<p />
*
* @author Julio Medellin
*/
Global class statusButtonClass implements dwp_dbpn.DynamicButtonsStatusInterface {

    Global Set<String> getDynamicButtonStatus(String recordId, String sObjectName)
    {
        list<string> IdsRecord = new list<string>();
        IdsRecord.add(recordId);
        Map<String,String> fieldValues = new Map<String,String>();
        Map<String,Set<String>> PdfBtn=   dwp_dace.DynamicActionsEngine_helper.getAvailableActions(IdsRecord,'Opportunity','ButtonVisibility');
        Map<String,Set<String>> reevaluate=  dwp_dace.DynamicActionsEngine_helper.getAvailableActions(IdsRecord,'Opportunity','BtnReevaluate');
        Map<String,Set<String>> reevaluatePrice=  dwp_dace.DynamicActionsEngine_helper.getAvailableActions(IdsRecord,'Opportunity','BtnPrice');
        Map<String,Set<String>> reevaluateRisk=  dwp_dace.DynamicActionsEngine_helper.getAvailableActions(IdsRecord,'Opportunity','BtnRisk');
        Map<String,Set<String>> formalizate=  dwp_dace.DynamicActionsEngine_helper.getAvailableActions(IdsRecord,'Opportunity','Approvalformalization');
        Map<String,Set<String>> formalization=  dwp_dace.DynamicActionsEngine_helper.getAvailableActions(IdsRecord,'Opportunity','btnFormalization_RuleSet');
        Map<String,Set<String>> reject=  dwp_dace.DynamicActionsEngine_helper.getAvailableActions(IdsRecord,'Opportunity','btnReject');
        Map<String,Set<String>> approve=  dwp_dace.DynamicActionsEngine_helper.getAvailableActions(IdsRecord,'Opportunity','btnApprove');

        Set<String> buttonsStatusSet = new Set<String>();
        id id1 = userinfo.getProfileId();
        String Qry = 'SELECT '+showFields('OpportunityLineItem')+' FROM OpportunityLineItem WHERE OpportunityId =\'' + recordId + '\' LIMIT 1';
        OpportunityLineItem OLI = Database.query(qry);
        boolean mandatoryOk= true;

        String productCode =[SELECT ID,ProductCode FROM OpportunityLineItem WHERE OpportunityId =:recordId].ProductCode;
        list<fprd__GBL_product_config__mdt>  ProdConf =   [SELECT Id,fprd__default_value__c,fprd__Dependent_field__c,fprd__dependent_parent_field__c,
                                                           fprd__Header_order__c,fprd__isHeader__c,fprd__isHidden__c,fprd__isImportant__c,
                                                           fprd__isMandatory__c,fprd__isReadOnly__c,fprd__Limite_Inferior__c,fprd__Limite_Superior__c,
                                                           fprd__LoVValue__c,fprd__LoV_labels__c,fprd__LoV_values__c,
                                                           fprd__LoV__c,fprd__map_field__c,fprd__order__c,fprd__parent_value__c,
                                                           fprd__product__c,fprd__Related_map_fields__c,fprd__section_order__c,
                                                           fprd__section__c,fprd__type__c
                                                           FROM fprd__GBL_product_config__mdt WHERE fprd__product__c =:productCode LIMIT 1];

        Map<String, Object> fieldToValue = OLI.getPopulatedFieldsAsMap();

        for(fprd__GBL_product_config__mdt conf : ProdConf){
            for (String key : fieldToValue.keySet()) {
                if(key == conf.fprd__map_field__c){
                    if(conf.fprd__dependent_parent_field__c == ''){
                        if(fieldToValue.get(key)==''){
                            mandatoryOk=false;
                        }
                    }else{
                        if(fieldToValue.get(conf.fprd__dependent_parent_field__c)==conf.fprd__parent_value__c){
                            if(fieldToValue.get(key)==''){
                                mandatoryOk=false;
                            }
                        }
                        else{
                               mandatoryOk=false;
                            }
                    }


                }
            }

        }

        String prof = [SELECT Name FROM profile WHERE id = :id1 LIMIT 1].Name;
        if(mandatoryOk && (prof=='Ejecutivo' || prof=='Administrador del Sistema' || prof=='Migracion'))
            buttonsStatusSet.add('btnQuote');
        if(approve.get(recordId).contains('Approve') && (prof=='Ejecutivo' || prof=='Administrador del Sistema' || prof=='Migracion'))
            buttonsStatusSet.add('btnApprove');
        if(reject.get(recordId).contains('Reject') && (prof=='Ejecutivo' || prof=='Administrador del Sistema' || prof=='Migracion'))
            buttonsStatusSet.add('btnReject');
        if(PdfBtn.get(recordId).contains('PDFBtn') &&(prof=='Operativo' || prof=='Administrador del Sistema' || prof=='Migracion'))
            buttonsStatusSet.add('btnPDF');
        if(reevaluate.get(recordId).contains('ButtonReevaluateVisible') && (prof=='Ejecutivo' || prof=='Administrador del Sistema' || prof=='Migracion'))
            buttonsStatusSet.add('btnReevaluate');
        if(Formalizate.get(recordId).contains('formalizate') && (prof=='Ejecutivo' || prof=='Administrador del Sistema' || prof=='Migracion'))
            buttonsStatusSet.add('btnFormalize');
        if(formalization.get(recordId).contains('btnFormalization') && (prof=='Operativo' || prof=='Administrador del Sistema' || prof=='Migracion'))
            buttonsStatusSet.add('btnFormalization');
        if(reevaluatePrice.get(recordId).contains('BtnPriceValue') &&( prof=='Ejecutivo' || prof=='Administrador del Sistema'  || prof=='Migracion'))
            buttonsStatusSet.add('btnSanctionPrice');
        if(reevaluateRisk.get(recordId).contains('BtnRiskValue') && (prof=='Ejecutivo' || prof=='Administrador del Sistema'  || prof=='Migracion'))
            buttonsStatusSet.add('btnPenalizeRisk');
        return buttonsStatusSet;
    }

    private string showFields(String Objecto) {
        Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Map <String, Schema.SObjectField> fieldMap = schemaMap.get(Objecto).getDescribe().fields.getMap();
        string fields = '';
        for(Schema.SObjectField sfield : fieldMap.Values())
        {
            fields+= sfield+',';
        }
        fields = fields.substring(0, fields.length()-1);
        return fields;
    }


}
