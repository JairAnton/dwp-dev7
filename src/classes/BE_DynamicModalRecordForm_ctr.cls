/*
* ------------------------------------------------------------------------------------------------
* @Name BE_DynamicModalRecordForm_ctr
* @Author Diego Carbajal diego.carbajal@bbva.com
* @Date Created: 2020-02-28
* @Group 
* @Description Esta clase es utilizada en los componentes LWC por requerimiento del negocio
* 
*/
public with sharing class BE_DynamicModalRecordForm_ctr {

    /**@Description sObjFields*/
    public static String sObjFields = 'Id';

    /**@Description Method to get Modal header*/
    @AuraEnabled(cacheable=true)
    public static Map<String, Object> getHeader(String config) {
        Map<String, Object> response = new Map<String, Object>{'isSuccess' => false, 'message' => 'No se ha encontrado la configuración especificada.'};
        List<BE_Modal_Record_Form__mdt> header = getModalConfig(config);
        if(header.size() > 0) {
            String accessMessage = header[0].No_sObject_Access_Message__c;
            response.put('message', accessMessage != null ? accessMessage : 'No tiene permisos para acceder a los registros de este objeto.');
            Boolean access = Dwp_Utils_helper.sObjectAccessCRUD(header[0].sObject_Target__c, 'isAccessible');
            if(access) {
                response.put('header', header[0]);
                response.put('isSuccess', true);
                response.remove('message');
            }
        }
        return response;
    }

    /**@Description Method to get Modal info*/
    @AuraEnabled
    public static Response getInfo(String recordId, String config) {
        Response result = new Response();
        result.isSuccess = false;
        try {
            Map<String, Object> header = getHeader(config);
            BE_Modal_Record_Form__mdt modal = (Boolean)header.get('isSuccess') ? (BE_Modal_Record_Form__mdt)header.get('header') : null;
            List<Structure> structure = (modal != null ? getConfig(modal.Id) : null);
            Boolean validate = ( structure != null ? validateStructure(structure) : false);
            if(!(Boolean)header.get('isSuccess')) {
                result.message = (String) header.get('message');
            } else if(validate) {
                String[] lstFieldsApiName = formatSOQLFields(modal.sObject_Target__c);
                Map<String, String> fieldsReference = convertReferenceFields(modal.sObject_Target__c, lstFieldsApiName);
                lstFieldsApiName = fieldsReference.values();
                BE_SingleRelatedList_Ctr.Params param = new BE_SingleRelatedList_Ctr.Params();
                param.sObjName = modal.sObject_Target__c;
                param.filterSQOL = modal.Filter_SOQL__c;
                param.filterSQOL = (modal.Order_Records__c != null ? param.filterSQOL +' '+modal.Order_Records__c : param.filterSQOL);
                param.sObjFields = sObjFields;
                structure = putIdField(structure);
                structure = putTypesFields(structure, BE_SingleRelatedList_Ctr.getSObjectFields(modal.sObject_Target__c));
                structure = putFieldsLabel(structure, lstFieldsApiName, modal.sObject_Target__c);
                List<sObject> data = BE_SingleRelatedList_Ctr.getSOQLData(recordId, param);
                result.data = (data.size() > 0 ? data : null);
                result.result =  generateStructure(structure, data);
                result.isSuccess = true;
            } else {
                result.message = Label.BE_DynamicModalRecordForm;//Obtain custom label
            }
        } catch (Exception e) {
            System.debug('BE_DynamicModalRecordForm_ctr.getInfo() => '+e.getMessage());
            result.message = e.getMessage();
        }
        return result;
    }

    /**@Description Method to get ModalConfig*/
    public static List<BE_Modal_Record_Form__mdt> getModalConfig(String config) {
        return [SELECT Id, MasterLabel, sObject_Target__c, Filter_SOQL__c, Order_Records__c, view_mode__c, delete_mode__c, Records_per_page__c,
        No_sObject_Access_Message__c, No_sObject_Delete_Message__c FROM BE_Modal_Record_Form__mdt WHERE DeveloperName=:config limit 1];
    }

    /**@Description Method to get Metadata Config*/
    public static List<Structure> getConfig(String idConfig){
        List<Structure> structure = new List<structure>();
        try {
            //Get Metadata Rows Config
            Set<Id> idRows = new Set<Id>();
            for(BE_Modal_Record_Row__mdt row: [SELECT Id, Row_Order__c, Modal_Record_Form__c FROM BE_Modal_Record_Row__mdt WHERE Modal_Record_Form__c=:idConfig order by Row_Order__c asc]) {
                structure.add(new Structure(row.Id, Integer.valueOf(row.Row_Order__c)));
                idRows.add(row.Id);
            }
            
            //Get Metadata Fields Config
            List<BE_Modal_Record_Field__mdt> fields = [SELECT Id, MasterLabel, Field_ApiName__c, Modal_Record_Row__c, Data_Type__c, Field_Width__c, 
                                                        Order__c, ReadOnly__c, Required__c, Help_Text__c FROM BE_Modal_Record_Field__mdt 
                                                        WHERE Modal_Record_Row__c IN: idRows order by Order__c asc];

            //Generate Structure
            for(Structure str: structure) {
                List<BE_Modal_Record_Field__mdt> lstFields = new List<BE_Modal_Record_Field__mdt>();
                for(BE_Modal_Record_Field__mdt field: fields) {
                    if(str.uniqueId == field.Modal_Record_Row__c) {
                        lstFields.add(field);
                    }
                }
                str.fields = lstFields;
            } 
        } catch(Exception e) {
            System.debug('Exception BE_DynamicModalRecordForm_ctr.getModalConfig() ==> '+e.getMessage());
        }
        return structure;
    }

    /**@Description Method to validate structure Metadata Config*/
    public static Boolean validateStructure(List<Structure> structure) {
        Boolean result = true;
        for(Structure str: structure) {
            Integer totalWidth = 0;
            for(BE_Modal_Record_Field__mdt field: str.fields) {
                totalWidth +=Integer.valueOf(field.Field_Width__c);
                //Obtain SOQL Fields
                sObjFields = sObjFields + ',' + field.Field_ApiName__c;
                if(totalWidth > 12) {
                    result = false;
                }
            }
        }
        return result;
    }

    /**@Description Method to putIdField*/
    public static List<Structure> putIdField(List<Structure> structure) {
        BE_Modal_Record_Field__mdt fieldId = new BE_Modal_Record_Field__mdt(MasterLabel = 'Id', Field_ApiName__c='Id', 
        Modal_Record_Row__c=structure[0].fields[0].Modal_Record_Row__c, Field_Width__c=6, Order__c=0);
        Structure str = new Structure('IdField', 0);
        str.fields = new List<BE_Modal_Record_Field__mdt>{fieldId};
        List<Structure> lstStr = new List<Structure>{str};
        lstStr.addAll(structure);
        return lstStr;
    }

    /**@Description Method to formatSOQLFields*/
    public static String[] formatSOQLFields(String sObj) {
        sObjFields = sObjFields.replace(' ', '');
        String[] lstFieldsApiName = (sObjFields.contains(',') ? (List<String>)sObjFields.split(',') : new List<String>{sObjFields});
        Schema.SObjectType schema = Schema.getGlobalDescribe().get(sObj);
        String fieldsSOQL = lstFieldsApiName[0];
        for(Integer i = 1; i < lstFieldsApiName.size(); i++) {
            String field = lstFieldsApiName[i];
            if(String.valueOf(schema.getDescribe().fields.getMap().get(lstFieldsApiName[i]).getDescribe().getType()) == 'picklist') {
                field ='toLabel('+field+')';
            }
            fieldsSOQL = fieldsSOQL + ',' + field;
        }
        sObjFields = fieldsSOQL;
        return lstFieldsApiName;
    }

    /**@Description Method to putTypesFields*/
    public static List<Structure> putTypesFields(List<Structure> structure, Map<String, String> sObjFieldsMap) {
        for(Structure str: structure) {
            for(BE_Modal_Record_Field__mdt mdf: str.fields) {
                mdf.Data_Type__c = sObjFieldsMap.get(mdf.Field_ApiName__c);
            }
        }
        return structure;
    }

    /**@Description Method to putFieldsLabel*/
    public static List<Structure> putFieldsLabel(List<Structure> structure, List<String> fieldsApiName, String sObjectType) {
        Map<String, String> mapLabel = getLabelFields(fieldsApiName, sObjectType);
        for(Structure str: structure) {
            for(BE_Modal_Record_Field__mdt strField: str.fields) {
                strField.MasterLabel = mapLabel.get(strField.Field_ApiName__c);
            }
        }
        return structure;
    }

    /**@Description Method to getLabelFields*/
    public static Map<String, String> getLabelFields(List<String> fieldsApiName, String sObjectType) {
        Map<String, String> fields = new Map<String, String>();
        Schema.sObjectType schema = Schema.getGlobalDescribe().get(sObjectType);
        for(String field: fieldsApiName) {
            fields.put(field, schema.getDescribe().fields.getMap().get(field).getDescribe().Label);
        }
        return fields;
    }

    /**@Description Method to generateStructure*/
    public static List<List<Map<String, Object>>> generateStructure(List<Structure> structure, List<sObject> data) {
        List<List<Map<String, Object>>> lstResult = new List<List<Map<String, Object>>>();
        List<Map<String, Object>> lstMapRecord;
        for(sObject obj: data) {
            lstMapRecord = new List<Map<String, Object>>();
            for(Structure str: structure) {
                lstMapRecord.add(new Map<String, Object>{
                    'fields' => getFieldsStructure(str.fields, obj), 'order' => str.order, 'uniqueId' => str.uniqueId});
            }
            lstResult.add(lstMapRecord);
        }
        return lstResult;
    }

    public static List<Map<String, Object>> getFieldsStructure(List<BE_Modal_Record_Field__mdt> fields, sObject obj) {
        List<Map<String, Object>> lstMap = new List<Map<String, Object>>();
        Map<String, Object> mapField;
        Integer cont = 1;
        for(BE_Modal_Record_Field__mdt mrf: fields) {
            mapField = new Map<String, Object>{'key' => obj.get('Id') +'-'+cont, 'id' => obj.get('Id'), 'label' => mrf.MasterLabel,
                        'fieldName' => mrf.Field_ApiName__c, 'order' => mrf.Order__c, 'fieldWidth' => mrf.Field_Width__c, 
                        'dataType' => mrf.Data_Type__c, 'value' => obj.get(mrf.Field_ApiName__c)};
            mapField.put('isId', mrf.Data_Type__c == 'Id' ? true : false);
            mapField.put('isBoolean', mrf.Data_Type__c == 'Boolean' ? true : false);
            mapField.put('isDate', mrf.Data_Type__c == 'Date' ? true : false);
            mapField.put('isDateTime', mrf.Data_Type__c == 'DateTime' ? true : false);
            mapField.put('isTime', mrf.Data_Type__c == 'Time' ? true : false);
            mapField.put('isCurrency', mrf.Data_Type__c == 'Currency' ? true : false);
            mapField.put('isPercent', mrf.Data_Type__c == 'Percent' ? true : false);
            mapField.put('isNumber', mrf.Data_Type__c == 'Double' ? true : false);
            mapField.put('isTextarea', mrf.Data_Type__c == 'Textarea' ? true : false);
            mapField.put('isEmail', mrf.Data_Type__c == 'Email' ? true : false);
            mapField.put('isUrl', mrf.Data_Type__c == 'Url' ? true : false);
            mapField.put('isPhone', mrf.Data_Type__c == 'Phone' ? true : false);
            mapField.put('isString', mrf.Data_Type__c == 'String' || mrf.Data_Type__c == 'reference' || mrf.Data_Type__c == 'picklist' ? true : false);
            lstMap.add(mapField);
            cont++;
        }
        return lstMap;
    }

    public static Map<String, String> convertReferenceFields(String sObj, List<String> fields) {
        Map<String, String> mapFields = new Map<String, String>();
        Map<String, String> fieldsValues = BE_SingleRelatedList_Ctr.getSObjectFields(sObj);
        for(String field: fields) {
            if(fieldsValues.get(field) == 'reference') {
                if(field.endsWith('Id')) {
					mapFields.put(field.removeEnd('Id')+'.Name', field);
                    sObjFields = sObjFields.replace(field, field.removeEnd('Id')+'.Name');
                } else {
                    mapFields.put(field.removeEnd('c')+'r.Name', field);
                	sObjFields = sObjFields.replace(field, field.removeEnd('c')+'r.Name');
                }
            } else {
                mapFields.put(field, field);
            }
        }
        return mapFields;
    }

    @AuraEnabled
    public static Map<String, Object> deletesobject(String recordId, String config) {
        Map<String, Object> response = new Map<String, Object>{'isSuccess' => false, 'message' => 'No se ha encontrado la configuración especificada.'};
        List<BE_Modal_Record_Form__mdt> lstMrf = getModalConfig(config);
        Boolean validateConfig = (lstMrf.size() > 0 ? true : false);
        try {
            if(validateConfig) {
                String deleteMessage = lstMrf[0].No_sObject_Delete_Message__c;
                response.put('message', deleteMessage != null ? deleteMessage : 'Usted no tiene permisos de eliminación sobre el objeto.');
                Boolean permissionDelete = Dwp_Utils_helper.sObjectAccessCRUD(lstMrf[0].sObject_Target__c, 'isDeletable');
                if(permissionDelete) {
                    response = Dwp_Utils_helper.deletesObjectRecord(lstMrf[0].sObject_Target__c, recordId);
                }
            }
        } catch(Exception e) {
            System.debug('BE_DynamicModalRecordForm_ctr.deletesObjectRecord() => '+e.getMessage());
            response.put('message', e.getMessage());
        }
         return response;
    }

    public class Structure {

        public Structure(String uniqueId, Integer order) {
            this.uniqueId = uniqueId;
            this.order = order;
        }

        @AuraEnabled
        public String uniqueId;
        @AuraEnabled
        public Integer order;
        @AuraEnabled
        public List<BE_Modal_Record_Field__mdt> fields;
    }

    public class Response {
        @AuraEnabled
        public Boolean isSuccess;
        @AuraEnabled
        public String message;
        @AuraEnabled
        public List<Structure> structure;
        @AuraEnabled
        public List<sObject> data;
        @AuraEnabled
        public List<List<Map<String, Object>>> result;
    }
}