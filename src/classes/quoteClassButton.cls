/**quoteClassButton
*  object.
* <p /><p />
* Modification log:<p />
* -------------------------------------------------------------------
* Developer                    Date                Description<p />
* -------------------------------------------------------------------
* Julio Medellin               July/02/2018          Original version.<p />
*
* @author Julio Medellin
*/
global without sharing class quoteClassButton  implements dwp_dbpn.DynamicFlowValidationInterface{

    global static List<String> getErrorMessagesList(String recordId, String source, String validationClass)
    {

        list<String> lstErrorMessage = new List<String>();
        Opportunity op = [SELECT stageName FROM Opportunity WHERE Id = : recordId];
        try{
            id id1 = userinfo.getProfileId();

            String prof = [SELECT Name FROM profile WHERE id = :id1 LIMIT 1].Name;


            String Qry = 'SELECT '+showFields('OpportunityLineItem')+' FROM OpportunityLineItem WHERE OpportunityId =\'' + recordId + '\' LIMIT 1';
            OpportunityLineItem OLI = Database.query(qry);
            boolean mandatoryOk= true;

            String productCode =[SELECT ID,ProductCode FROM OpportunityLineItem WHERE OpportunityId =:recordId LIMIT 1].ProductCode;
            list<fprd__GBL_product_config__mdt>  ProdConf =   [SELECT fprd__section_order__c,fprd__product__c, fprd__LoV_values__c, fprd__Limite_Inferior__c, fprd__Limite_Superior__c,fprd__isMandatory__c,
                                                               fprd__isReadOnly__c,fprd__section__c, Label, fprd__default_value__c, fprd__Dependent_field__c, DeveloperName, fprd__isHidden__c, fprd__Related_map_fields__c,
                                                               Id, fprd__LoV_labels__c, fprd__map_field__c, fprd__order__c, fprd__type__c, fprd__parent_value__c, fprd__dependent_parent_field__c, fprd__isImportant__c
                                                               FROM fprd__GBL_product_config__mdt WHERE fprd__product__c =:productCode];

            Map<String, Object> fieldToValue = OLI.getPopulatedFieldsAsMap();
            if(String.isBlank(productCode))
                mandatoryOk=false;
            String  FormatedParentField;
            for(fprd__GBL_product_config__mdt conf : ProdConf){
                 if(String.isBlank(String.valueOf(fieldToValue.get(conf.fprd__map_field__c))))
                    {
                      mandatoryOk=false;
                    }
                  if(String.isNotBlank(conf.fprd__dependent_parent_field__c))
                 FormatedParentField= conf.fprd__dependent_parent_field__c.replace(productCode, '_c');
                 if(String.isNotBlank(conf.fprd__dependent_parent_field__c) && String.isBlank(String.valueOf(fieldToValue.get(FormatedParentField)))){
                   mandatoryOk=false;
                 }

                 if(conf.fprd__map_field__c == 'gipr_Tipo_Garantia__c' && fieldToValue.get(conf.fprd__map_field__c)!='01'){
                  String QryWarranty = 'SELECT '+showFields('fprd__GBL_Guarantee__c')+' FROM fprd__GBL_Guarantee__c WHERE fprd__GBL_Opportunity_product__c =\'' + recordId + '\'';
                   list<fprd__GBL_Guarantee__c> Garantias  = Database.query(QryWarranty);
                    if(Garantias.size()>0){
                       for(fprd__GBL_Guarantee__c garantia :Garantias){
                       if(String.isBlank(garantia.guarantee_modality_type__c) || String.isBlank(garantia.guarantee_status_type__c) || garantia.guarantee_term_number__c == 0 || garantia.guarantee_id__c == 0)
                       mandatoryOk=false;
                        }
                     }
                 }


                }




    //        if(!mandatoryOk)
     //               lstErrorMessage.add(label.lblQuoteError);
        }
        catch(exception e){
            system.debug('Exception: '+e );
            lstErrorMessage.add(label.lblQuoteGeneralError);
        }
        return lstErrorMessage;
    }

    private static string showFields(String Objecto) {
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
