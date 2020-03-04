/**
* ------------------------------------------------------------------------------------------------
* @Name BE_DynamicModalRecordForm_helper
* @Author Diego Carbajal diego.carbajal@bbva.com
* @Date Created: 2020-02-28
* @Group 
* @Description Clase helper para la clase BE_DynamicModalRecordForm_ctr
* 
*/
public with sharing class BE_DynamicModalRecordForm_helper {
    /**@Description constructor BE_DynamicModalRecordForm_ctr*/
    private BE_DynamicModalRecordForm_helper() {}

    /**@Description Method to get ModalConfig*/
    public static List<BE_Modal_Record_Form__mdt> getModalConfig(String config) {
        return [SELECT Id, MasterLabel, sObject_Target__c, Filter_SOQL__c, Order_Records__c, view_mode__c, delete_mode__c, Records_per_page__c,
        No_sObject_Access_Message__c, No_sObject_Delete_Message__c FROM BE_Modal_Record_Form__mdt WHERE DeveloperName=:config limit 1];
    }
    
    /**@Description Method getValidations*/
    public static Map<String, Object> getValidations(Map<String, Object> header, BE_Modal_Record_Form__mdt modal) {
        Final Map<String, Object> mapRes = new Map<String, Object>();
        Final List<BE_DynamicModalRecordForm_ctr.Structure> structure = (modal == null ? new List<BE_DynamicModalRecordForm_ctr.Structure>() : BE_DynamicModalRecordForm_ctr.getConfig(modal.Id));
        mapRes.put('structure', structure);
        Final Integer structureSize = structure.size();
        mapRes.put('validate', structureSize > 0 ? BE_DynamicModalRecordForm_ctr.validateStructure(structure) : false);
        mapRes.put('headerSuccess', (Boolean)header.get('isSuccess') ? false : true);
        return mapRes;
    }

    /**@Description Method to putIdField*/
    public static List<BE_DynamicModalRecordForm_ctr.Structure> putIdField(List<BE_DynamicModalRecordForm_ctr.Structure> structure) {
        Final BE_Modal_Record_Field__mdt fieldId = new BE_Modal_Record_Field__mdt(MasterLabel = 'Id', Field_ApiName__c='Id', 
        Modal_Record_Row__c = structure[0].fields[0].Modal_Record_Row__c, Field_Width__c=6, Order__c=0);
        Final BE_DynamicModalRecordForm_ctr.Structure str = new BE_DynamicModalRecordForm_ctr.Structure('IdField', 0);
        str.fields = new List<BE_Modal_Record_Field__mdt>{fieldId};
        Final List<BE_DynamicModalRecordForm_ctr.Structure> lstStr = new List<BE_DynamicModalRecordForm_ctr.Structure>{str};
        lstStr.addAll(structure);
        return lstStr;
    }

    public static List<BE_DynamicModalRecordForm_ctr.Structure> putTypesFields(List<BE_DynamicModalRecordForm_ctr.Structure> structure, Map<String, String> sObjFieldsMap) {
        for(BE_DynamicModalRecordForm_ctr.Structure str: structure) {
            for(BE_Modal_Record_Field__mdt mdf: str.fields) {
                mdf.Data_Type__c = sObjFieldsMap.get(mdf.Field_ApiName__c);
            }
        }
        return structure;
    }

    /**@Description Method to putFieldsLabel*/
    public static List<BE_DynamicModalRecordForm_ctr.Structure> putFieldsLabel(List<BE_DynamicModalRecordForm_ctr.Structure> structure, List<String> fieldsApiName, String sObjectType) {
        Final Map<String, String> mapLabel = getLabelFields(fieldsApiName, sObjectType);
        for(BE_DynamicModalRecordForm_ctr.Structure str: structure) {
            for(BE_Modal_Record_Field__mdt strField: str.fields) {
                strField.MasterLabel = mapLabel.get(strField.Field_ApiName__c);
            }
        }
        return structure;
    }

    /**@Description Method to getLabelFields*/
    public static Map<String, String> getLabelFields(List<String> fieldsApiName, String sObjectType) {
        Final Map<String, String> fields = new Map<String, String>();
        Final Schema.sObjectType schema = Schema.getGlobalDescribe().get(sObjectType);
        for(String field: fieldsApiName) {
            fields.put(field, schema.getDescribe().fields.getMap().get(field).getDescribe().Label);
        }
        return fields;
    }

    /**@Description Method to generateStructure*/
    public static List<List<Map<String, Object>>> generateStructure(List<BE_DynamicModalRecordForm_ctr.Structure> structure, List<sObject> data) {
        Final List<List<Map<String, Object>>> lstResult = new List<List<Map<String, Object>>>();
        List<Map<String, Object>> lstMapRecord;
        for(sObject obj: data) {
            lstMapRecord = new List<Map<String, Object>>();
            for(BE_DynamicModalRecordForm_ctr.Structure str: structure) {
                lstMapRecord.add(new Map<String, Object>{
                    'fields' => getFieldsStructure(str.fields, obj), 'order' => str.order, 'uniqueId' => str.uniqueId});
            }
            lstResult.add(lstMapRecord);
        }
        return lstResult;
    }

    /**@Description Method to getFieldsStructure*/
    public static List<Map<String, Object>> getFieldsStructure(List<BE_Modal_Record_Field__mdt> fields, sObject obj) {
        Final List<Map<String, Object>> lstMap = new List<Map<String, Object>>();
        Final String[] lstDataTypes = new String[]{'Id', 'Boolean', 'Date', 'DateTime', 'Time', 'Currency', 'Percent', 'Double',
                                                    'Textarea', 'Email', 'Url', 'Phone'};
        Map<String, Object> mapField;
        Integer cont = 1;
        for(BE_Modal_Record_Field__mdt mrf: fields) {
            mapField = new Map<String, Object>{'key' => obj.get('Id') +'-'+cont, 'id' => obj.get('Id'), 'label' => mrf.MasterLabel,
                        'fieldName' => mrf.Field_ApiName__c, 'order' => mrf.Order__c, 'fieldWidth' => mrf.Field_Width__c, 
                        'dataType' => mrf.Data_Type__c, 'value' => obj.get(mrf.Field_ApiName__c)};
            for(String dataTypes: lstDataTypes) {
                mapField.put('is'+dataTypes, dataTypes == mrf.Data_Type__c);
            }
            mapField.put('isString', mrf.Data_Type__c == 'String' || mrf.Data_Type__c == 'reference' || mrf.Data_Type__c == 'picklist' ? true : false);
            lstMap.add(mapField);
            cont++;
        }
        return lstMap;
    }
}
