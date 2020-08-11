/**
   -------------------------------------------------------------------------------------------------
   @Name <BE_CustomListField>
   @Author Martin Alejandro Mori Chavez (martin.mori.contractor@bbva.com)
   @Date 2020-08-10
   @Description Class to create custom list fields
   @Changes
   Date        Author   Email                  				Type		Description
   2020-08-10  MAMC     martin.mori.contractor@bbva.com    	Creation
   -------------------------------------------------------------------------------------------------
 */
public with sharing class BE_CustomListField_Cls {
    /**constructor**/
    private BE_CustomListField_Cls() {}
    
    /**Method used to set sanction price summarize fields**/
    public static List<itemField> createListField(String oliId, String uniqueNameTable) {
        Final List<itemField> items = new List<itemField>();
        Final List<field__mdt> lstFieldMDT = [SELECT field_api_name__c, Field_Custom_Label__c, order__c, Use_Product_Configuration_Value__c FROM Field__mdt WHERE field_form__r.unique_id__c = :uniqueNameTable ORDER BY order__c];
		Final Set<String> setFields = new Set<String>();
        Final Set<String> fieldsProdConf = new Set<String>();
        for(Field__mdt field : lstFieldMDT) {
            setFields.add(field.field_api_name__c);
            if(field.Use_Product_Configuration_Value__c) {
                fieldsProdConf.add(field.field_api_name__c);
            }
        }
        Final List<String> lstField = new List<String>(setFields);
        Final List<sObject> lstRecord = Database.query('SELECT Product2Id,' + String.escapeSingleQuotes(String.join(lstField, ',')) + ' FROM OpportunityLineItem WHERE Id = :oliId');
        Map<String, Object> mapPC = new Map<String, Object>();
        if(!fieldsProdConf.isEmpty()) {
            mapPC = createMapPC(lstRecord, fieldsProdConf);
        }
        Decimal position = 0;
        for(Field__mdt field : lstFieldMDT) {
            itemField item = new itemField();
            item.label = (field.Field_Custom_Label__c == null) ? Schema.getGlobalDescribe().get('OpportunityLineItem').getDescribe().fields.getMap().get(field.field_api_name__c).getDescribe().getLabel() : field.Field_Custom_Label__c;
            item.value = (field.Use_Product_Configuration_Value__c) ? ''+mapPC.get(field.field_api_name__c) : ''+lstRecord[0].get(field.field_api_name__c);
            if(position==field.order__c) {
                item.value = items.get(items.size()-1).value + ' ' + item.value;
                items.set(items.size()-1, item);
            } else {
                items.add(item);
            }
            position=field.order__c;
        }
        position++;
        return items;
    }
    
    /**Method to create map product configuration **/
    private static Map<String, Object> createMapPC(List<sObject> lstRecord, Set<String> fieldsProdConf) {
        Final Map<String, Object> mapReturn = new Map<String, Object>();
        Final String prodId = (String)lstRecord[0].get('Product2Id');
        Final fprd__GBL_Product_Configuration__c[] lstProductConf = [SELECT fprd__LoV_labels__c, fprd__LoV_values__c, fprd__Product__r.Name, fprd__Map_field__c FROM fprd__GBL_Product_Configuration__c 
                                                                     WHERE fprd__Product__c = :prodId AND fprd__Map_field__c IN: fieldsProdConf];
        for(fprd__GBL_Product_Configuration__c pc : lstProductConf) {
            if(!String.isEmpty(pc.fprd__LoV_values__c)) {
                Final String[] strLabelTmp = pc.fprd__LoV_labels__c.split(',');
                Final String[] strValueTmp = pc.fprd__LoV_values__c.split(',');
                Final Integer position = strValueTmp.indexOf('' + lstRecord[0].get(pc.fprd__Map_field__c));
                if(position >= 0) {
                    mapReturn.put(pc.fprd__Map_field__c, strLabelTmp[position]);
                }
            }
        }
        return mapReturn;
    }
    
    /**Method for map parameters **/
	public class itemField {
		/**
		 * record id param
		 */
		private String label;
		/**
		 * status of opportunity param
		 */
		private String value;
	}
}