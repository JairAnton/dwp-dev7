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

    /**@Description varaible sObjFields*/
    private static String sObjFields = 'Id';
    /**@Description variable MESSAGE for sonarQ*/
    Final static String MESSAGE = 'message';
    /**@Description variable IS_SUCCESS for sonarQ*/
    Final static String IS_SUCCESS = 'isSuccess';

    /**@Description constructor BE_DynamicModalRecordForm_ctr*/
    private BE_DynamicModalRecordForm_ctr() {}

    /**@Description Method to get Modal header*/
    @AuraEnabled(cacheable=true)
    public static Map<String, Object> getHeader(String config) {
        Final Map<String, Object> response = new Map<String, Object>{IS_SUCCESS => false, MESSAGE => 'No se ha encontrado la configuración especificada.'};
        Final List<BE_Modal_Record_Form__mdt> header = BE_DynamicModalRecordForm_helper.getModalConfig(config);
        Final Integer headerSize = header.size();
        if(headerSize > 0) {
            Final String accessMessage = header[0].No_sObject_Access_Message__c;
            response.put(MESSAGE, accessMessage == null ? 'No tiene permisos para acceder a los registros de este objeto.' : accessMessage);
            Final Boolean access = Dwp_Utils_helper.sObjectAccessCRUD(header[0].sObject_Target__c, 'isAccessible');
            if(access) {
                response.put('header', header[0]);
                response.put(IS_SUCCESS, true);
                response.remove(MESSAGE);
            }
        }
        return response;
    }

    /**@Description Method to get Modal info*/
    @AuraEnabled
    public static Response getInfo(String recordId, String config) {
        Response result = new Response();
        result.isSuccess = false;
        result.message = Label.Dwp_msgGenericError;
        try {
            Final Map<String, Object> header = getHeader(config);
            Final BE_Modal_Record_Form__mdt modal = (Boolean)header.get(IS_SUCCESS) ? (BE_Modal_Record_Form__mdt)header.get('header') : new BE_Modal_Record_Form__mdt();
            Final Map<String, Object> mapRes = BE_DynamicModalRecordForm_helper.getValidations(header, modal);
            if((Boolean)mapRes.get('headerSuccess')) {
                result.message = (String) header.get(MESSAGE);
            } else if((Boolean)mapRes.get('validate')) {
                result = getInfoValidated(modal, (List<Structure>) mapRes.get('structure'), recordId);
            } else {
                result.message = Label.BE_DynamicModalRecordForm;
            }
        } catch (Exception e) {
            System.debug('BE_DynamicModalRecordForm_ctr.getInfo() => '+e.getMessage());
        }
        return result;
    }

    /**@Description Method getInfoValidated*/
    public static Response getInfoValidated(BE_Modal_Record_Form__mdt modal, List<Structure> structure, String recordId) {
        Final Response result = new Response();        
        String[] lstFieldsApiName = formatSOQLFields(modal.sObject_Target__c);
        Final Map<String, String> fieldsReference = convertReferenceFields(modal.sObject_Target__c, lstFieldsApiName);
        lstFieldsApiName = fieldsReference.values();
        Final BE_SingleRelatedList_Ctr.Params param = new BE_SingleRelatedList_Ctr.Params();
        param.sObjName = modal.sObject_Target__c;
        param.filterSQOL = modal.Filter_SOQL__c;
        param.filterSQOL = (modal.Order_Records__c == null ? param.filterSQOL : param.filterSQOL +' '+modal.Order_Records__c);
        param.sObjFields = sObjFields;
        List<Structure> str = BE_DynamicModalRecordForm_helper.putIdField(structure);
        str = BE_DynamicModalRecordForm_helper.putTypesFields(str, BE_SingleRelatedList_Ctr.getSObjectFields(modal.sObject_Target__c));
        str = BE_DynamicModalRecordForm_helper.putFieldsLabel(str, lstFieldsApiName, modal.sObject_Target__c);
        Final List<sObject> data = BE_SingleRelatedList_Ctr.getSOQLData(recordId, param);
        Final Integer dataSize = data.size();
        result.data = (dataSize > 0 ? data : new List<SObject>());
        result.result =  BE_DynamicModalRecordForm_helper.generateStructure(str, data);
        result.isSuccess = true;
        return result;
    }

    /**@Description Method to get Metadata Config*/
    public static List<Structure> getConfig(String idConfig) {
        Final List<Structure> structure = new List<structure>();
        try {
            //Get Metadata Rows Config
            Final Set<Id> idRows = new Set<Id>();
            for(BE_Modal_Record_Row__mdt row: [SELECT Id, Row_Order__c, Modal_Record_Form__c FROM BE_Modal_Record_Row__mdt WHERE Modal_Record_Form__c=:idConfig order by Row_Order__c asc]) {
                structure.add(new Structure(row.Id, Integer.valueOf(row.Row_Order__c)));
                idRows.add(row.Id);
            }
            
            //Get Metadata Fields Config
            Final List<BE_Modal_Record_Field__mdt> fields = [SELECT Id, MasterLabel, Field_ApiName__c, Modal_Record_Row__c, Data_Type__c, Field_Width__c, 
                                                        Order__c, ReadOnly__c, Required__c, Help_Text__c FROM BE_Modal_Record_Field__mdt 
                                                        WHERE Modal_Record_Row__c IN: idRows order by Order__c asc];

            //Generate Structure
            for(Structure str: structure) {
                Final List<BE_Modal_Record_Field__mdt> lstFields = new List<BE_Modal_Record_Field__mdt>();
                for(BE_Modal_Record_Field__mdt field: fields) {
                    if(str.uniqueId == field.Modal_Record_Row__c) {
                        lstFields.add(field);
                    }
                }
                str.fields = lstFields;
            } 
        } catch(Exception e) {
            System.debug('Exception BE_DynamicModalRecordForm_ctr.getConfig() ==> '+e.getMessage());
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

    /**@Description Method to formatSOQLFields*/
    public static String[] formatSOQLFields(String sObj) {
        sObjFields = sObjFields.replace(' ', '');
        Final String[] lstFieldsApiName = (sObjFields.contains(',') ? (List<String>)sObjFields.split(',') : new List<String>{sObjFields});
        Final Schema.SObjectType schema = Schema.getGlobalDescribe().get(sObj);
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

    /**@Description Method to convertReferenceFields*/
    public static Map<String, String> convertReferenceFields(String sObj, List<String> fields) {
        Final Map<String, String> mapFields = new Map<String, String>();
        Final Map<String, String> fieldsValues = BE_SingleRelatedList_Ctr.getSObjectFields(sObj);
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

    /**@Description Method to deletesobject*/
    @AuraEnabled
    public static Map<String, Object> deletesobject(String recordId, String config) {
        Map<String, Object> response = new Map<String, Object>{IS_SUCCESS => false, MESSAGE => 'No se ha encontrado la configuración especificada.'};
        Final List<BE_Modal_Record_Form__mdt> lstMrf = BE_DynamicModalRecordForm_helper.getModalConfig(config);
        Final Integer lstMrfSize = lstMrf.size();
        Final Boolean validateConfig = (lstMrfSize > 0 ? true : false);
        try {
            if(validateConfig) {
                Final String deleteMessage = lstMrf[0].No_sObject_Delete_Message__c;
                response.put(MESSAGE, deleteMessage == null ? 'Usted no tiene permisos de eliminación sobre el objeto.' : deleteMessage);
                Final Boolean permissionDelete = Dwp_Utils_helper.sObjectAccessCRUD(lstMrf[0].sObject_Target__c, 'isDeletable');
                if(permissionDelete) {
                    response = Dwp_Utils_helper.deletesObjectRecord(lstMrf[0].sObject_Target__c, recordId);
                }
            }
        } catch(Exception e) {
            System.debug('BE_DynamicModalRecordForm_ctr.deletesObjectRecord() => '+e.getMessage());
            response.put(MESSAGE, e.getMessage());
        }
         return response;
    }

    /**@Description public class Structure*/
    public class Structure {

        /**@Description Variable uniqueId*/
        @AuraEnabled
        public String uniqueId;
        /**@Description Variable order*/
        @AuraEnabled
        public Integer order;
        /**@Description Variable fields*/
        @AuraEnabled
        public List<BE_Modal_Record_Field__mdt> fields;

        /**@Description Constructor Structure*/
        public Structure(String uniqueId, Integer order) {
            this.uniqueId = uniqueId;
            this.order = order;
        }
    }

    /**@Description public class Response*/
    public class Response {
        /**@Description Variable isSuccess*/
        @AuraEnabled
        public Boolean isSuccess;
        /**@Description Variable message*/
        @AuraEnabled
        public String message;
        /**@Description Variable structure*/
        @AuraEnabled
        public List<Structure> structure;
        /**@Description Variable data*/
        @AuraEnabled
        public List<sObject> data;
        /**@Description Variable result*/
        @AuraEnabled
        public List<List<Map<String, Object>>> result;
    }
}